//
//  AWSQLiteDB.swift
//  TestSqliteSwift
//
//  Created by 秦 道平 on 15/12/7.
//  Copyright © 2015年 秦 道平. All rights reserved.
//

import Foundation

// MARK: - SQLValue
public enum SQLValue {
    case Integer(Int)
    case Float(Double)
    case Text(String)
    case Blob(NSData)
    case Null
    
    public init(value: Any) {
        switch value {
        case let val as NSData:
            self = .Blob(val)
        case let val as NSDate:
            self = .Float(val.timeIntervalSince1970)
        case let val as Bool:
            self = .Integer(Int(val))
        case let val as Int:
            self = .Integer(val)
        case let val as Double:
            self = .Float(val)
        case let val as String:
            self = .Text(val)
        default:
            self = .Null
        }
        
    }
    
    public var integer: Int? {
        switch self {
        case .Integer(let value):
            return value
        default:
            return nil
        }
    }
    
    public var double: Double? {
        switch self {
        case .Float(let value):
            return value
        default:
            return nil
        }
    }
    
    public var string: String? {
        switch self {
        case .Text(let value):
            return value
        default:
            return nil
        }
    }
    
    public var data: NSData? {
        switch self {
        case .Blob(let value):
            return value
        default:
            return nil
        }
    }
    
    public var date: NSDate? {
        switch self {
        case .Float(let value):
            return NSDate(timeIntervalSince1970: value)
        default:
            return nil
        }
    }
}
// MARK: - SQLiteColumn
public struct SQLiteColumn {
    public var value:SQLValue?
    public var name:String?
    public var type:CInt
}

// MARK: - SQLiteDB
public enum SQLiteDBError:ErrorType {
    case SharedDBIsNotNilError
    case DBPathIsNilError
}
public class SQLiteDB {
    public static var sharedDB : SQLiteDB!
    private var db : COpaquePointer
    private var dbPath :String?
    public typealias SQLiteRow = [String:SQLiteColumn]
    /// Do not use this
    private init (){
        self.dbPath = nil
        self.db = nil
        do {
            try self.open()
        }
        catch { }
    }
    public init(path:String? = nil) {
        self.dbPath = path
        self.db = nil
        do {
            try self.open()
        }
        catch { }
    
    }
    deinit {
        self.close()
    }
    
    /// 设置一个全局共享的数据库
    public class func setupSharedDBPath(path:String) throws ->SQLiteDB!{
        if sharedDB != nil {
            throw SQLiteDBError.SharedDBIsNotNilError
        }
        sharedDB = SQLiteDB(path: path)
        return sharedDB!
    }
    /// 打开数据库
    private func open() throws ->Bool {
        guard let dbPath = self.dbPath else {
            throw SQLiteDBError.DBPathIsNilError
        }
        let result = sqlite3_open(dbPath, &self.db)
        if result != SQLITE_OK {
            if let msg = self.lastErrMessage {
                NSLog("SQLiteDB:Failed to open DB:%s",msg)
            }
            return false
        }
        return true
    }
    public func close() -> Bool {
        guard self.db != nil else {
            return false
        }
        let result = sqlite3_close(self.db)
        if result != SQLITE_OK {
            if let msg = self.lastErrMessage {
                NSLog("SQLiteDB:Failed to close DB:%s",msg)
            }
            return false
        }
        return true
    }
    // MARK: error
    /// 最近的一次出错信息
    public var lastErrMessage:String?{
        get{
            let err = sqlite3_errmsg(self.db)
            let msg = String.fromCString(err)
            return msg
        }
    }
    /// 输出最近的一次出错信息
    private func logLastErrMessage(){
        if let msg = self.lastErrMessage {
            NSLog("SQLiteDB:\(msg)")
        }
    }
    // MARK: api
    /// 最后插入的一条数据的 id
    public var lastInsertedRowID:Int64 {
        return sqlite3_last_insert_rowid(self.db)
    }
    /// 绑定值
    public func bindValue(value:Any, toIndex index:Int, inStatement statement:COpaquePointer){
        let idx = Int32(index)
        switch value {
        case let v as Bool:
            sqlite3_bind_int(statement, idx, Int32(Int(v)))
        case let v as Int64:
            sqlite3_bind_int64(statement, idx, v)
        case let v as Int:
            sqlite3_bind_int(statement, idx, Int32(v))
        case let v as Double:
            sqlite3_bind_double(statement, idx, v)
        case let v as String:
            sqlite3_bind_text(statement, idx, NSString(string:v).UTF8String, -1, nil)
        case let v as NSDate:
            sqlite3_bind_double(statement, idx, v.timeIntervalSince1970)
        default:
            sqlite3_bind_null(statement, idx)
        }
    }
    /// 执行修改语句
    public func execute(sql:String, parameters:Any...) -> Bool {
        guard self.db != nil else {
            return false
        }
        var statement : COpaquePointer = nil
        defer {
            sqlite3_finalize(statement)
        }
        var result = sqlite3_prepare_v2(self.db, sql, -1, &statement, nil)
        if result != SQLITE_OK {
            self.logLastErrMessage()
            return false
        }
        for (index,value) in parameters.enumerate() {
            self.bindValue(value, toIndex: index + 1, inStatement: statement)
        }
        result = sqlite3_step(statement)
        if result != SQLITE_OK && result != SQLITE_DONE {
            if result == SQLITE_ROW {
                NSLog("SQLiteDB:query in execute")
                return true
            }
            else{
                self.logLastErrMessage()
                return false    
            }
            
        }
        return true
    }
    /// 执行查询语句
    public func query(sql:String, parameters:Any...)->[SQLiteRow] {
        guard self.db != nil else {
            return []
        }
        var statement : COpaquePointer = nil
        defer {
            sqlite3_finalize(statement)
        }
        let result = sqlite3_prepare_v2(self.db, sql, -1, &statement, nil)
        if result != SQLITE_OK {
            self.logLastErrMessage()
            return []
        }
        for (index,value) in parameters.enumerate() {
            self.bindValue(value, toIndex: index + 1, inStatement: statement)
        }
        var rows : [SQLiteRow] = []
        while (sqlite3_step(statement) == SQLITE_ROW) {
            var row = SQLiteRow()
            let columnCount = sqlite3_column_count(statement)
            for c in 0..<columnCount {
                let column = self.getColumn(statement, index: c)
                if let column = column,columnName = column.name {
                    row[columnName] = column
                }
            }
            rows.append(row)
        }
        return rows
        
    }
    // MARK: column
    /// 获取列类型
    private func getColumnType(stmt:COpaquePointer,index:CInt ) -> CInt {
        var type:CInt = 0
        
        // Column types - http://www.sqlite.org/datatype3.html (section 2.2 table column 1)
        let blobTypes = ["BINARY", "BLOB", "VARBINARY"]
        let textTypes = ["CHAR", "CHARACTER", "CLOB", "NATIONAL VARYING CHARACTER", "NATIVE CHARACTER", "NCHAR", "NVARCHAR", "TEXT", "VARCHAR", "VARIANT", "VARYING CHARACTER"]
        let dateTypes = ["DATE", "DATETIME", "TIME", "TIMESTAMP"]
        let intTypes  = ["BIGINT", "BIT", "BOOL", "BOOLEAN", "INT", "INT2", "INT8", "INTEGER", "MEDIUMINT", "SMALLINT", "TINYINT"]
        let nullTypes = ["NULL"]
        let realTypes = ["DECIMAL", "DOUBLE", "DOUBLE PRECISION", "FLOAT", "NUMERIC", "REAL"]
        
        // Determine type of column - http://www.sqlite.org/c3ref/c_blob.html
        let declaredType = sqlite3_column_decltype(stmt, index)
        if declaredType != nil{
            var declaredType = String.fromCString(declaredType)!.uppercaseString
           
            if let index = declaredType.indexOf("(") {
                declaredType = declaredType[0..<index]
            }
            
            if intTypes.contains(declaredType) {
                return SQLITE_INTEGER
            }
            if realTypes.contains(declaredType) {
                return SQLITE_FLOAT
            }
            if textTypes.contains(declaredType) {
                return SQLITE_TEXT
            }
            if blobTypes.contains(declaredType) {
                return SQLITE_BLOB
            }
            if dateTypes.contains(declaredType) {
                return SQLITE_FLOAT
            }
            if nullTypes.contains(declaredType) {
                return SQLITE_NULL
            }
            return SQLITE_NULL
        }
        else {
            type = sqlite3_column_type(stmt, index)
        }
        
        return type
    }
    /// 获取列名字
    private func getColumnName(statement:COpaquePointer, index:CInt) -> String?{
        let columnName_c = sqlite3_column_name(statement, index)
        return  String.fromCString(columnName_c)
    }
    /// 获取列的名字，类型和值
    private func getColumn(statement:COpaquePointer, index:CInt) -> SQLiteColumn? {
        let columnType = self.getColumnType(statement, index: index)
        let columnName = self.getColumnName(statement, index: index)
        var v:Any?
        switch columnType {
            case SQLITE_INTEGER:
                v = Int(sqlite3_column_int(statement, index))
            case SQLITE_FLOAT:
                v = Double(sqlite3_column_double(statement, index))
            case SQLITE_TEXT:
                let s = UnsafePointer<Int8>(sqlite3_column_text(statement, index))
                v = String.fromCString(s)
            case SQLITE_BLOB:
                let data = sqlite3_column_blob(statement, index)
                let size = sqlite3_column_bytes(statement, index)
                v = NSData(bytes:data, length: Int(size))
            default:
                v = nil
        }
        if let v = v {
            let columnValue = SQLValue(value: v)
            return SQLiteColumn(value: columnValue, name: columnName, type: columnType)
        }
        return nil
    }
}
// MARK: - String
extension String {
    internal func indexOf(sub: String) -> Int? {
        var pos: Int?
        
        if let range = self.rangeOfString(sub) {
            if !range.isEmpty {
                pos = self.startIndex.distanceTo(range.startIndex)
            }
        }
        
        return pos
    }
    
    internal subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.startIndex.advancedBy(r.startIndex)
            let endIndex = startIndex.advancedBy(r.endIndex - r.startIndex)
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
    
}