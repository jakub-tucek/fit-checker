## What is FIT-Checker for iOS
_**FIT-Checker** for iOS is a simple app which helps you to stay up to date
with your latest classification._

## tl; dr Quick setup
* Clone the repo `git clone https://github.com/jakub-tucek/fit-checker`
* Install [Carthage](https://github.com/Carthage/Carthage) dependency manager
* Install [SwiftGen](https://github.com/AliSoftware/SwiftGen) for automated code generation
* Download and build dependencies: `carthage bootstrap --platform iOS --no-use-binaries`
* Build the project with XCode: <kbd>cmd ⌘</kbd> + <kbd>r</kbd>
* :tada: Have fun! :tada:

## Installation
Ok, quick setup is not that descriptive, lets make a tear down.

First things first,
clone the repo from Github:

```bash
$ git clone https://github.com/jakub-tucek/fit-checker
```

Once the repository is cloned, you have to install dependencies. We use [Carthage](https://github.com/Carthage/Carthage) instead of CocoaPods
as dependency manager. Follow [this guide](https://github.com/Carthage/Carthage#installing-carthage)
and install latest stable version of Carthage.

Because we believe that Swift and its ecosystem should be strongly typed and
code validity should be checked at build time, we use [SwiftGen](https://github.com/AliSoftware/SwiftGen) to generate boilerplate code.
For now, SwiftGen automatically generates Enums with text translations. Check
[this guide](https://github.com/AliSoftware/SwiftGen#installation) for SwiftGen
installation walkthrough.

Now the dependencies itself. Nothing fancy, run:

```bash
$ carthage bootstrap --platform iOS
```

**If you see any build errors after installation** caused by incompatible Swift version,
run `update` command on corrupted library with `--no-use-binaries` option. We are now
experiencing some issues with KeychainAccess binary, so after the `bootstrap` finishes,
we use:

```bash
$ carthage update KeychainAccess --no-use-binaries --platform iOS
```

Now you should be ready to run the app without any problem. If the app cannot be build,
please create a new issue if it's not already created.
