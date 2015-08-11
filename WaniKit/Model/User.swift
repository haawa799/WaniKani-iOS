//
//  User.swift
//  
//
//  Created by Andriy K. on 8/11/15.
//
//
import RealmSwift

public class User: Object {
  
  dynamic var username: NSString = ""
  dynamic var gravatar: NSString = ""
  dynamic var level: Int = 0
  dynamic var title: NSString = ""
  dynamic var about: NSString = ""
  dynamic var website: NSString = ""
  dynamic var twitter: NSString = ""
  dynamic var topicsCount: Int = 0
  dynamic var postsCount: Int = 0
  dynamic var creationDate: NSDate = NSDate()
  
  class func userFromDictionary(dict: NSDictionary) -> User? {
    if let username = dict["username"] as? String, let creationDate = dict["creation_date"] as? Int {
      let userFromWaki = User()
      userFromWaki.username = username
      userFromWaki.creationDate = NSDate(timeIntervalSince1970: NSTimeInterval(creationDate))
      
      userFromWaki.gravatar = (dict["gravatar"] as? String) ?? ""
      userFromWaki.level = (dict["level"] as? Int) ?? 0
      userFromWaki.title = (dict["title"] as? String) ?? ""
      
      userFromWaki.about = (dict["about"] as? String) ?? ""
      userFromWaki.website = (dict["website"] as? NSString) ?? ""
      userFromWaki.twitter = (dict["twitter"] as? String) ?? ""
      
      userFromWaki.topicsCount = (dict["topics_count"] as? Int) ?? 0
      userFromWaki.postsCount = (dict["posts_count"] as? Int) ?? 0
      
      return userFromWaki
    }
    
    return nil
  }
  
  public override static func primaryKey() -> String? {
    return "username"
  }
  
}
