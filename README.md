# UICollectionUpdates

Wrapper for UITableView and UICollectionView model-oriented batch updates. Supports safe batch updates (In case of throw you can perform reloadData())

[![Version](https://img.shields.io/cocoapods/v/UICollectionUpdates.svg?style=flat)](https://cocoapods.org/pods/UICollectionUpdates)
[![License](https://img.shields.io/cocoapods/l/UICollectionUpdates.svg?style=flat)](https://cocoapods.org/pods/UICollectionUpdates)
[![Platform](https://img.shields.io/cocoapods/p/UICollectionUpdates.svg?style=flat)](https://cocoapods.org/pods/UICollectionUpdates)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Usage

```swift

import UICollectionUpdates

let updates = UICollectionUpdates(
    reloadIndexPaths: [IndexPath(item: 0, section: 0), IndexPath(item: 2, section: 0)],
    deleteIndexPaths: [IndexPath(item: 1, section: 0)],
    deleteSections: [1]
)
do {
    try collectionView.perform(updates: updates, completion: { succeed in
        print("The animation has been successfull: \(succeed)")
    })
} catch {
    // Inconsistent update
    collectionView.reloadData()
}
```

## Installation

### [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

```ruby
# Podfile
use_frameworks!

target 'YOUR_TARGET_NAME' do
    pod 'UICollectionUpdates'
end
```

### [Carthage](https://github.com/Carthage/Carthage)

Add this to `Cartfile`

```
github "konshin/UICollectionUpdates" "0.1.4"
```

```bash
$ carthage update
```

## Author

konshin, alexey@konshin.net

## License

UICollectionUpdates is available under the MIT license. See the LICENSE file for more info.
