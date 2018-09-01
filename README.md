# InoJournal

InoJournal is a simple app to add quick entries to a sqlite database. It is intended as a work journal/log to keep track of what I'm doing day by day, sort of like a private Twitter.

This app is not intended for public use. No support is given to compile, run, or use it.

![Alt text](screenshot.png?raw=true "InoJournal")

## Dependencies

It is build in Swift 4.

This project depends on [stephencelis/SQLite.swift](https://github.com/stephencelis/SQLite.swift) and [Nike-Inc/Willow](https://github.com/Nike-Inc/Willow)
It uses [Carthage](https://github.com/Carthage/Carthage) to add the SQLite framework.

## Quick Installation

* Clone this repository
* install [Carthage](https://github.com/Carthage/Carthage) (if you use brew: "brew install carthage")
* go to the project directory and run the add_frameworks.sh script (type ./add_frameworks.sh script in the Terminal)
* run your project in XCode and compile the app

## What does Carthage and add_frameworks.sh do?

At the moment add_frameworks.sh just runs one command:

``` bash
carthage bootstrap --platform macOS
```
It should create a Carthage/Builds directory with the compiled SQLite framework. The project is already configured to reference those files.

You should read the [Carthage documentation](https://github.com/Carthage/Carthage). It is a pretty cool tool.


### Planned

* add a preference panel
* add window that lists all entries
* add support for tags
* add a way to delete entries
* move database to app support directory
* allow user to set hotkey
* limit character count
