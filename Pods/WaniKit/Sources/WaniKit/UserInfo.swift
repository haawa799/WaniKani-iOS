//
//  User.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import Foundation

public struct UserInfo {
  
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
  
  public var username: String
  public var gravatar: String?
  public var level: Int?
  public var title: String?
  public var about: String?
  public var website: String?
  public var twitter: String?
  public var topicsCount: Int?
  public var postsCount: Int?
  public var creationDate: NSDate?
  
}

extension UserInfo: DictionaryInitialization {
  
  public init(dict: NSDictionary) {
    username = dict[UserInfo.keyUsername] as! String
    if let creation = dict[UserInfo.keyCreationDate] as? Int {
      creationDate = NSDate(timeIntervalSince1970: NSTimeInterval(creation))
    }
    
    gravatar = (dict[UserInfo.keyGravatar] as? String)
    level = (dict[UserInfo.keyLevel] as? Int)
    title = (dict[UserInfo.keyTitle] as? String)
    
    about = (dict[UserInfo.keyAbout] as? String)
    website = (dict[UserInfo.keyWebsite] as? String)
    twitter = (dict[UserInfo.keyTwitter] as? String)
    
    topicsCount = (dict[UserInfo.keyTopicsCount] as? Int)
    postsCount = (dict[UserInfo.keyPostsCount] as? Int)
  }
}
