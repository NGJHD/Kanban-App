const express  = require("express");
const fs       = require("fs");
const path     = require("path");

const app       = express();
const PORT      = 5555;
const DATA_FILE = path.join(__dirname, "kanban.json");

const now      = Date.now();
const today    = new Date(now).toISOString().slice(0, 10);
const lastWeek = new Date(now - 7 * 86400000).toISOString().slice(0, 10);

const DEFAULT_DATA = {
  sortSettings: {
    todo:     "created",
    progress: "created",
  },
  cards: [
    { id: "1", desc: "Review all components for consistency", priority: "high",   col: "todo",     createdAt: new Date(now - 4  * 86400000).toISOString() },
    { id: "2", desc: "Connect new backend endpoints",         priority: "medium", col: "progress", createdAt: new Date(now - 3  * 86400000).toISOString() },
    { id: "3", desc: "Schedule 5 sessions with power users",  priority: "low",    col: "todo",     createdAt: new Date(now - 2  * 86400000).toISOString() },
    { id: "4", desc: "Deploy to staging",                     priority: "low",    col: "done",     createdAt: new Date(now - 10 * 86400000).toISOString(), completedAt: today     },
    { id: "5", desc: "Token refresh fails on mobile",         priority: "high",   col: "progress", createdAt: new Date(now - 1  * 86400000).toISOString() },
    { id: "6", desc: "Write release notes",                   priority: "medium", col: "done",     createdAt: new Date(now - 9  * 86400000).toISOString(), completedAt: today     },
    { id: "7", desc: "Set up CI/CD pipeline",                 priority: "high",   col: "done",     createdAt: new Date(now - 14 * 86400000).toISOString(), completedAt: lastWeek  },
    { id: "8", desc: "Migrate legacy endpoints",              priority: "medium", col: "done",     createdAt: new Date(now - 12 * 86400000).toISOString(), completedAt: lastWeek  },
  ],
};

// Migrate old format (plain array) to new format on first run after update
function loadData() {
  if (!fs.existsSync(DATA_FILE)) {
    fs.writeFileSync(DATA_FILE, JSON.stringify(DEFAULT_DATA, null, 2));
    console.log("Created kanban.json with default data.");
    return DEFAULT_DATA;
  }
  const raw = JSON.parse(fs.readFileSync(DATA_FILE, "utf8"));
  // If the file is still the old plain-array format, migrate it
  if (Array.isArray(raw)) {
    const migrated = { sortSettings: { todo: "created", progress: "created" }, cards: raw };
    fs.writeFileSync(DATA_FILE, JSON.stringify(migrated, null, 2));
    console.log("Migrated kanban.json to new format.");
    return migrated;
  }
  return raw;
}

loadData(); // ensure file exists and is valid on startup

app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));

// GET full data { cards, sortSettings }
app.get("/api/data", (req, res) => {
  try {
    res.json(loadData());
  } catch (err) {
    console.error("Read error:", err);
    res.status(500).json({ error: "Failed to read data." });
  }
});

// POST full data { cards, sortSettings }
app.post("/api/data", (req, res) => {
  try {
    const { cards, sortSettings } = req.body;
    if (!Array.isArray(cards)) return res.status(400).json({ error: "Expected cards array." });
    fs.writeFileSync(DATA_FILE, JSON.stringify({ cards, sortSettings }, null, 2));
    res.json({ ok: true });
  } catch (err) {
    console.error("Write error:", err);
    res.status(500).json({ error: "Failed to write data." });
  }
});

app.listen(PORT, () => {
  console.log(`Kanban board running at http://localhost:${PORT}`);
});
