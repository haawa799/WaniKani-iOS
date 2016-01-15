//
//  User.swift
//  
//
//  Created by Andriy K. on 8/11/15.
//
//
import RealmSwift
import WaniKit

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
  public dynamic var levels: WaniKaniLevels?
}

extension User {
  
  convenience init(userInfo: UserInfo) {
    
    self.init()
    updateUserWithUserInfo(userInfo)
  }
  
  func updateUserWithUserInfo(userInfo: UserInfo) {
    
    username = userInfo.username
    creationDate = userInfo.creationDate ?? NSDate()
    
    gravatar = userInfo.gravatar ?? ""
    level = userInfo.level ?? 0
    title = userInfo.title ?? ""
    
    about = userInfo.about ?? ""
    website = userInfo.website ?? ""
    twitter = userInfo.twitter ?? ""
    
    topicsCount = userInfo.topicsCount ?? 0
    postsCount = userInfo.postsCount ?? 0
  }
  
}
