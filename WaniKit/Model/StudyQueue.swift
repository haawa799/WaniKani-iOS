//
//  StudyQueue.swift
//  
//
//  Created by Andriy K. on 8/12/15.
//
//

import RealmSwift

public class StudyQueue: Object {
  
  // Dictionary keys
  private static let keyAvaliableLessons = "lessons_available"
  private static let keyAvaliableReviews = "reviews_available"
  private static let keyNextReviewDate = "next_review_date"
  private static let keyReviewsNextHour = "reviews_available_next_hour"
  private static let keyReviewsNextDay = "reviews_available_next_day"
  //
  
  public dynamic var lessonsAvaliable: Int = 0
  public dynamic var reviewsAvaliable: Int = 0
  public dynamic var nextReviewDate: NSDate = NSDate()
  public dynamic var reviewsNextHour: Int = 0
  public dynamic var reviewsNextDay: Int = 0
}

extension StudyQueue: DictionaryConvertable {
  
  class func objectFromDictionary(dict: NSDictionary) -> StudyQueue? {
    let studyQueue = StudyQueue()
    studyQueue.lessonsAvaliable = (dict[keyAvaliableLessons] as? Int) ?? 0
    studyQueue.reviewsAvaliable = (dict[keyAvaliableReviews] as? Int) ?? 0
    if let reviewDate = dict[keyNextReviewDate] as? Int {
      studyQueue.nextReviewDate = NSDate(timeIntervalSince1970: NSTimeInterval(reviewDate))
    }
    studyQueue.reviewsNextHour = (dict[keyReviewsNextHour] as? Int) ?? 0
    studyQueue.reviewsNextDay = (dict[keyReviewsNextDay] as? Int) ?? 0
    return studyQueue
  }
}

// Dates related
extension StudyQueue {
  
  public func nextReviewWaitingData() -> (string: String, hours: Int) {
    let calendar: NSCalendar = NSCalendar.currentCalendar()
    
    let flags = NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute
    let components = calendar.components(flags, fromDate: NSDate(), toDate: nextReviewDate, options: nil)
    
    var nextReviewString = "Avaliable now!"
    
    let years = components.year
    let months = components.month
    let days = components.day
    let hours = components.hour
    let minutes = components.minute
    
    if years <= 0 {
      if months <= 0 {
        if days <= 0 {
          if hours <= 0 {
            if minutes > 0 {
              var s = "s"
              if minutes == 1 {
                s = ""
              }
              nextReviewString = "~ \(minutes) minute\(s)"
            }
          } else {
            var s = "s"
            if hours == 1 {
              s = ""
            }
            nextReviewString = "~ \(hours) hour\(s)"
          }
        } else {
          var s = "s"
          if days == 1 {
            s = ""
          }
          nextReviewString = "~ \(days) day\(s)"
        }
      } else {
        var s = "s"
        if months == 1 {
          s = ""
        }
        nextReviewString = "~ \(months) month\(s)"
      }
    } else {
      var s = "s"
      if years == 1 {
        s = ""
      }
      nextReviewString = "~ \(years) year\(s)"
    }
    return (nextReviewString, hours)
  }
}
