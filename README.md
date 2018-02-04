# ExecOnline Learn

============

## Installation

Make sure you have the latest version of Xcode installed from
the App Store. Then run the following commands to install Xcode's
command line tools and `bundler`, if you don't have that yet.

```sh
[sudo] gem install bundler
xcode-select --install
```

The following commands will set up the project.

```sh
git clone git@github.com:AliceAponasko/EOLearn.git
cd EOLearn
bundle install
```
Now let's get those Pods!

```sh
pod install
```

Great! You should be good to go!

## Getting Started

Now that we have the codebase, we can run the
app using Xcode 9. Make sure to
open the `EOLearn.xcworkspace` workspace, and not the `EOLearn.xcodeproj` project.

```sh
open EOLearn.xcworkspace/
```

Once XCode is open, click `Run` button at the top left corner.

## Tools

* Xcode Version 9.2 (9C40b)
* [Cocoapods](https://cocoapods.org/)
* [SwiftLint](https://github.com/realm/SwiftLint)
