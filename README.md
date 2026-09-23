# Kanban App

Vibe coded this nodejs kanban app to my own liking. Why don't I use an existing one? I think they have too many features. Too many for my caveman brain to use.

<img width="1914" height="1024" alt="project-kanban-board" src="https://github.com/user-attachments/assets/56aced86-e8b9-4797-adc9-103fc210703f" />


Features
- Double click on an empty part of a column (or click the faint + next to its heading) to add a card
- There is no title for the card, only description.
- Markdown supported in the description
- Double click on the description to edit it
- Click the priority dropdown button to change priority immediately
- Drag and drop between columns
- Everything saves to a local JSON file
- When you drag to completed, the current date will be assigned as the completed date automatically (you can change it by double clicking)
- You can sort by priority or by date
- The floating search bar at the bottom filters the entire board
- The dot in the top left shows save status: green is saved, grey is saving, red means something went wrong (hover it for details)

## Running it

Double click **start.bat**. It starts the server with no console window and opens
the board in your browser. If the server is already running it just opens the
browser - it will never start a second copy.

Double click **stop.bat** to shut the server down. Because there is no window,
this is the only way to stop it short of a reboot.

The board lives at http://127.0.0.1:5555 and listens on loopback only, so it is
not reachable from other machines and Windows Firewall will not prompt.

## Portable use

The release zip is self contained: it bundles `runtime/node.exe` and
`node_modules`, so it runs from a USB stick on a machine with no Node.js
installed. Extract it anywhere and double click `start.bat`.

If you cloned the repo instead, `runtime/` and `node_modules/` are not in git.
`start.bat` falls back to your system Node and runs `npm install` on first use.

