//
//  StudyQueue.swift
//  
//
//  Created by Andriy K. on 8/12/15.
//
//

import RealmSwift
import WaniKit

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

extension StudyQueue {
  
  func updateWith(studyQueueInfo: StudyQueueInfo?) {
    guard let studyQueueInfo = studyQueueInfo else { return }
    lessonsAvaliable = studyQueueInfo.lessonsAvaliable ?? 0
    reviewsAvaliable = studyQueueInfo.reviewsAvaliable ?? 0
    nextReviewDate = studyQueueInfo.nextReviewDate ?? NSDate()
    reviewsNextHour = studyQueueInfo.reviewsNextHour ?? 0
    reviewsNextDay = studyQueueInfo.reviewsNextDay ?? 0
  }
  
  convenience init(studyQueueInfo: StudyQueueInfo) {
    self.init()
    updateWith(studyQueueInfo)
  }
  
}

// Dates related
extension StudyQueue {
  
  public func nextReviewWaitingData() -> (string: String, hours: Int) {
    let calendar: NSCalendar = NSCalendar.currentCalendar()
    
    let flags: NSCalendarUnit = [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute]
    let components = calendar.components(flags, fromDate: NSDate(), toDate: nextReviewDate, options: [])
    
    var nextReviewString = "今"
    
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
              nextReviewString = "\(minutes)min"
            }
          } else {
            nextReviewString = "\(hours)h"
          }
        } else {
          var s = "s"
          if days == 1 {
            s = ""
          }
          nextReviewString = "\(days) day\(s)"
        }
      } else {
        var s = "s"
        if months == 1 {
          s = ""
        }
        nextReviewString = "\(months) month\(s)"
      }
    } else {
      var s = "s"
      if years == 1 {
        s = ""
      }
      nextReviewString = "\(years) year\(s)"
    }
    return (nextReviewString, hours)
  }
}

extension CollectionViewViewModel {
  
  static func collectionViewModelWith(studyQueue studyQueue: StudyQueue) -> CollectionViewViewModel {
    
    let color = ColorConstants.dashboardColor
    
    let sections = [
      // Section 0
      CollectionViewSection(nil, []),
      
      // Section 1
      CollectionViewSection(CollectionViewCellDataItem((DashboardHeaderViewModel(title: "Available", color: color) as ViewModel), DashboardHeader.identifier), [
        CollectionViewCellDataItem((AvaliableItemCellViewModel(title: "Lessons", number: studyQueue.lessonsAvaliable) as ViewModel), AvaliableItemCell.identifier),
        CollectionViewCellDataItem((AvaliableItemCellViewModel(title: "Reviews", number: studyQueue.reviewsAvaliable) as ViewModel), AvaliableItemCell.identifier)
        ]),
      
      // Section 2
      CollectionViewSection(CollectionViewCellDataItem((DashboardHeaderViewModel(title: "Reviews", color: color) as ViewModel), DashboardHeader.identifier), [
        CollectionViewCellDataItem((LeftRightTitleViewModel(left: "Next review",right: studyQueue.nextReviewWaitingData().string) as ViewModel), ReviewCell.identifier),
        CollectionViewCellDataItem((LeftRightTitleViewModel(left: "Next hour",right: "\(studyQueue.reviewsNextHour)") as ViewModel), ReviewCell.identifier),
        CollectionViewCellDataItem((LeftRightTitleViewModel(left: "Next day",right: "\(studyQueue.reviewsNextDay)") as ViewModel), ReviewCell.identifier)
        ])
    ]
    return CollectionViewViewModel(sections: sections)
  }
}
