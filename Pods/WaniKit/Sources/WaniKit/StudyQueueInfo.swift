//
//  StudyQueueInfo.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import Foundation

public struct StudyQueueInfo {
  
  // Dictionary keys
  private static let keyAvaliableLessons = "lessons_available"
  private static let keyAvaliableReviews = "reviews_available"
  private static let keyNextReviewDate = "next_review_date"
  private static let keyReviewsNextHour = "reviews_available_next_hour"
  private static let keyReviewsNextDay = "reviews_available_next_day"
  //
  
  public var lessonsAvaliable: Int?
  public var reviewsAvaliable: Int?
  public var nextReviewDate: NSDate?
  public var reviewsNextHour: Int?
  public var reviewsNextDay: Int?
  
}

extension StudyQueueInfo: DictionaryInitialization {
  
  public init(dict: NSDictionary) {
    lessonsAvaliable = (dict[StudyQueueInfo.keyAvaliableLessons] as? Int)
    reviewsAvaliable = (dict[StudyQueueInfo.keyAvaliableReviews] as? Int)
    if let reviewDate = dict[StudyQueueInfo.keyNextReviewDate] as? Int {
      nextReviewDate = NSDate(timeIntervalSince1970: NSTimeInterval(reviewDate))
    }
    reviewsNextHour = (dict[StudyQueueInfo.keyReviewsNextHour] as? Int)
    reviewsNextDay = (dict[StudyQueueInfo.keyReviewsNextDay] as? Int)
  }
}
