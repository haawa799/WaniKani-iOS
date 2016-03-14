# WaniKit

[![Build Status](https://travis-ci.org/haawa799/WaniKit.svg?branch=master)](https://travis-ci.org/haawa799/WaniKit)
[![License](https://img.shields.io/cocoapods/l/WaniKit.svg?style=flat)](http://cocoapods.org/pods/WaniKit)
[![Version](https://img.shields.io/cocoapods/v/WaniKit.svg?style=flat)](http://cocoapods.org/pods/WaniKit)
[![Carthage compatible](https://img.shields.io/badge/Carthage-✓-5f7cae.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/WaniKit.svg?style=flat)](http://cocoapods.org/pods/WaniKit)

![alt text](icon.png)
####WaniKit - Swift wrapper for WaniKani.com API. It's based on `NSOperation` and `NSOperationQueue`, as described in [this WWDC2015 talk](https://developer.apple.com/videos/play/wwdc2015-226/).

####I built it mainly for my - [iOS WaniKani client](https://github.com/haawa799/WaniKani-iOS).

## Installation

### Cocoapods
WaniKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "WaniKit"
```

### Carthage
WaniKit is avaliable through Carthage. To install

1. In Cartfile add:
```ruby
github "haawa799/WaniKit"
```

2. Build framework for different platforms with:
```shell
carthage update --platform iOS
```
or
```shell
carthage update --platform Mac
```

3. Manually add framework to your targets

## Usage


1. Create manager object, and provide it with WaniKani API key (can be found in Settings of your WaniKani profile)

	```swift
	let manager = WaniApiManager()
    manager.setApiKey("0123abc0123abc0123abc") // Pass key here
    ```

2. Fetch Study queue data, here's an example of how the API call looks

	```swift
	manager.fetchStudyQueue { (result) -> Void in
		switch result {
		case .Error(let error):
			print(error())
		case .Response(let response):
			let resp = response()
			if let userInfo = resp.userInfo {
				print("userInfo: \(userInfo)")
			}
			if let studyQueueInfo = resp.studyQInfo {
				print("studyQInfo: \(studyQInfo)")
			}
		}
	}
	```

3. Fetch Level progression

	```swift
	manager.fetchLevelProgression { (result) -> Void in
		switch result {
		case .Error(let error):
			print(error())
		case .Response(let response):
			let resp = response()
			if let userInfo = resp.userInfo {
				print("userInfo: \(userInfo)")
			}
			if let levelProgressInfo = resp.levelProgression {
				print("levelProgression: \(levelProgressInfo)")
			}
		}
	}
	```

4. If for any reason you need only user info

	```swift
	manager.fetchUserInfo { (result) -> Void in
      switch result {
      case .Error(let error):
        print(error())
      case .Response(let response):
        let resp = response()
        if let userInfo = resp {
          print(userInfo)
        }
      }
    }
	```

5. Radicals for specific level

	```swift
	manager.fetchRadicalsList(7) { (result) -> Void in
      switch result {
      case .Error(let error):
        print(error())
      case .Response(let response):
        let resp = response()
        if let userInfo = resp.userInfo {
          print(userInfo)
        }
        if let radicals = resp.radicals {
          print(radicals)
        }
      }
    }
	```

6. Kanji for specific level
	```swift
	manager.fetchKanjiList(8) { (result) -> Void in
      switch result {
      case .Error(let error):
        print(error())
      case .Response(let response):
        let resp = response()
        if let userInfo = resp.userInfo {
          print(userInfo)
        }
        if let kanji = resp.kanji {
          print(kanji)
        }
      }
    }
	```
7. Vocab for specific level
	```swift
	manager.fetchVocabList(9) { (result) -> Void in
      switch result {
      case .Error(let error):
        print(error())
      case .Response(let response):
        let resp = response()
        if let userInfo = resp.userInfo {
          print(userInfo)
        }
        if let vocab = resp.vocab {
          print(vocab)
        }
      }
    }
	```
8. Critical items, with percentage parameter
	```swift
	manager.fetchCriticalItems(85) { (result) -> Void in
      switch result {
      case .Error(let error):
        print(error())
      case .Response(let response):
        let resp = response()
        if let userInfo = resp.userInfo {
          print(userInfo)
        }
        if let criticalItems = resp.criticalItems {
          print(criticalItems)
        }
      }
    }
	```

##

## Important note

Manager operates using serial queue, therefore requests will be executed in order in which you are calling them, and no one will start until one before it will finish.

Also there can only be one operation of each kind in the queue, therefore if you for example call `fetchStudyQueue` three times it will execute it only once.

If you need multiple same requests sent at the same time, you can use two managers or open an issue here on Github.


## Author

Andriy Kharchyshyn., haawaplus@gmail.com
######@haawa799
######Go say hi at linked in https://ua.linkedin.com/in/andrew-kharchyshyn-39639164

## License

WaniKit is available under the MIT license. See the LICENSE file for more info.
