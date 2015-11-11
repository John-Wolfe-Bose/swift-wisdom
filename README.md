This library is mean to be a general grab bag of Swift methods made by the engineers at IntrepidPursuits.  As this library goes, useful components will be isolated into separate podspecs where appropriate.

The reason for the grab bag approach is to make it easier to facilitate the adding of materials and encourage componentization and sharing of common functionality.

```
source 'https://github.com/IntrepidPursuits/swift-wisdom.git'
pod 'IntrepidSwiftWisdom'
use_frameworks!
```

### Components

* [Qu](#qu)
* [After](#after)
* [Nib Initable](#nib-initable)
* [Color Descriptor](#color-descriptor)
* [Cell Configuring](#cell-configuring)
* [User Defaults](#user-defaults)

#### Qu

A basic wrapper for dispatch operations in Swift.  Syntax example:

```Swift
    Qu.Background {
        // Sleep for long operation
        sleep(4)
        log("1")
    } .Also {
        sleep(4)
        log("2")
    } .Also {
        sleep(1)
        log("3")
    } .Also {
        sleep(1)
        log("4")
    } .Also {
        sleep(1)
        log("5")
    } .ThenAfter(.Previous(3)) {
        log("6: After 5, 4, & 3")
    } .Then {
        sleep(1)
        log("7: After 6")
    } .FinallyOn(.Main) {
        sleep(1)
        log("Finished: After All")
    }
```

#### After

A simple way to perform or repeat future operations:

```Swift
After(2.5) {
  print("Two and a half seconds later")
}

RepeatAtInterval(1.0, numberOfTimes: 5) {
  print("Once a second, 5 times")
}
```

#### Nib Initable

Load views from nibs:

```Swift
let myCustomView = MyCustomView.fromNib()
```

#### Color Descriptor

Setup Easy Color Schemes

```Swift
enum ColorPalette : ColorDescriptor {
    case White = "254,216,130,255"
    case DarkGreen = "51,58,24,255"
    case DarkGray = "64,48,56,255"

    var color: UIColor {
        return rawValue.color
    }
}
```

And use:

```Swift
someView.backgroundColor = ColorPalette.White.color
```

#### Cell Configuring

A simple way to cover most table view registering / dequeing

##### Register

```Swift
tableView.registerCell(YourCell.self)
tableView.registerHeader(YourHeader.self)
```

##### Dequeue

```Swift
let cell: YourCell = tableView.dequeueCell(indexPath)
//
let header: YourHeader = tableView.dequeueHeader(section)
```

#### User Defaults

A way to read and write from defaults simply and type-safe

##### Define

```Swift
enum Setting : String, EnumSettingsKeyAccessible {
    case DisplayName
    case LastOpenDate
}
```

##### Read

```Swift
let displayName: String? = Setting.DisplayName.readFromDefaults
```

##### write

```Swift
Setting.DisplayName.writeToDefaults(displayName)
```

#### Contributions

All contributions and updates are welcome!  Here's some basic guidelines when submitting an addition:

- Submit via a Pull Request documenting the addition
- Follow appropriate folder conventions
- Prefix all extension methods and variables with `ip_` to avoid namespacing.  Swift namespacing doesn't apply the same way to extensions and prefixes help avoid issues.
- Document functionality if it is ambiguous