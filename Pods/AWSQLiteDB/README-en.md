# AWSQLiteDB

AWSQLiteDB a simple wrapper for libsqlite3.0 in Swift

## Installing

### Carthage

Carthage is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with Homebrew using the following command:

	$ brew update
	$ brew install carthage
	
Buid for iOS	
	
1. Create a Cartfile that lists the frameworks you’d like to use in your project.

		git "git@github.com:adow/AWSQLiteDB.git" >= 0.1.2
	
2. Run `carthage update`. This will fetch dependencies into a Carthage/Checkouts folder, then build each one.
3. On your application targets’ “General” settings tab, in the “Linked Frameworks and Libraries” section, drag and drop each framework you want to use from the Carthage/Build folder on disk.
4. On your application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase”. Create a Run Script with the following contents:

		/usr/local/bin/carthage copy-frameworks
		
	and add the paths to the frameworks you want to use under “Input Files”, e.g.:

		$(SRCROOT)/Carthage/Build/iOS/AWSQLiteDB.framework

### Cocoapods

	source 'https://github.com/CocoaPods/Specs.git'
	platform :ios, '8.0'
	use_frameworks!
	
	pod 'AWSQLiteDB', '~> 0.1.2'

### Manually

#### Git Submodule

1. Make sure that your project is in Git repository;
2. Add `AWSQLiteDB` as submodule;

		git submodule add git@github.com:adow/AWSQLiteDB.git
	
3. Drag and drop `AWSQLiteDB.xcodeproj` to your project;
4. On your application targets, `General` tab, `Embedded Binaries` setting, click `+` to add `AWSQLiteDB.framework`. You will find `AWSQLiteDB.framework` is also in `Build Phases` / `Link Binary with Libraries`.

#### Or Use AWSQLiteDB.swift in your project (Compatible with iOS7)

1. Copy `AWSQLiteDB.swift` to your project;
2. On your applicationtargets `Build Phases` tab, `Link Binary with Linbrries` setting, add `libsqlite3.0.tbd`;


## Usage

### Open Database

	let cache_dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
	let db_filename = "\(cache_dir)/sql.db"
	let db = SQLiteDB(path: db_filename)
	
### Close Database

Connection will be close when SQLiteDB instance released.
	
	db.close()
	
### Use Shared Instance

	let cache_dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
	let db_filename = "\(cache_dir)/sql.db"
	guard let _ = try? SQLiteDB.setupSharedDBPath(db_filename) else {
	    return
	}
	
### Execute

Create Table

	var sql = "create table test (id INTEGER PRIMARY KEY AUTOINCREMENT, name CHAR(32) NOT NULL)"
	print("create table:\(SQLiteDB.sharedDB.execute(sql))")
	
Insert

	sql = "insert into test (id,name) values (?,?)"
	var result = SQLiteDB.sharedDB.execute(sql, parameters:9, "adow")
	print("insert:\(result)")
	
update

	sql = "update test set name=? where id =?"
	result = SQLiteDB.sharedDB.execute(sql, parameters: "reynold qin",9)
	print("update:\(result)")	
	
### Query

	sql = "select * from test"
	let rows = SQLiteDB.sharedDB.query(sql)
	for r in rows {
	    let id = r["id"]!.value!.integer!
	    let name = r["name"]!.value!.string!
	    print("\(id):\(name)")
	}

## References

* [Accessing an SQLite Database in Swift](http://stackoverflow.com/questions/24102775/accessing-an-sqlite-database-in-swift)
* [ SQLite3 C/C++ 开发接口简介（API函数）一、二、三](http://blog.csdn.net/u012485637/article/details/44486923)
* [SQLite - C/C++](http://www.runoob.com/sqlite/sqlite-c-cpp.html)