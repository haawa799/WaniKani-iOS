//
//  User.swift
//  
//
//  Created by Andriy K. on 8/11/15.
//
//
import RealmSwift


public class User: Object {
  
  // Dictionary keys
  private static let keyUsername = "username"
  private static let keyGravatar = "gravatar"
  private static let keyLevel = "level"
  private static let keyTitle = "title"
  private static let keyAbout = "about"
  private static let keyWebsite = "website"
  private static let keyTwitter = "twitter"
  private static let keyTopicsCount = "topics_count"
  private static let keyPostsCount = "posts_count"
  private static let keyCreationDate = "creation_date"
  //
  
  public dynamic var username: NSString = ""
  public dynamic var gravatar: NSString = ""
  public dynamic var level: Int = 0
  public dynamic var title: NSString = ""
  public dynamic var about: NSString = ""
  public dynamic var website: NSString = ""
  public dynamic var twitter: NSString = ""
  public dynamic var topicsCount: Int = 0
  public dynamic var postsCount: Int = 0
  public dynamic var creationDate: NSDate = NSDate()
  
  public dynamic var studyQueue: StudyQueue?
  public dynamic var levelProgression: LevelProgression?
  
  public override static func primaryKey() -> String? {
    return "username"
  }
  
}

extension User: DictionaryConvertable {
  class func objectFromDictionary(dict: NSDictionary) -> User? {
    if let username = dict[keyUsername] as? String, let creationDate = dict[keyCreationDate] as? Int {
      let userFromWaki = User()
      userFromWaki.username = username
      userFromWaki.creationDate = NSDate(timeIntervalSince1970: NSTimeInterval(creationDate))
      
      userFromWaki.gravatar = (dict[keyGravatar] as? String) ?? ""
      userFromWaki.level = (dict[keyLevel] as? Int) ?? 0
      userFromWaki.title = (dict[keyTitle] as? String) ?? ""
      
      userFromWaki.about = (dict[keyAbout] as? String) ?? ""
      userFromWaki.website = (dict[keyWebsite] as? NSString) ?? ""
      userFromWaki.twitter = (dict[keyTwitter] as? String) ?? ""
      
      userFromWaki.topicsCount = (dict[keyTopicsCount] as? Int) ?? 0
      userFromWaki.postsCount = (dict[keyPostsCount] as? Int) ?? 0
      
      return userFromWaki
    }
    
    return nil
  }
}
