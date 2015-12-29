//
//  AwardsManager.swift
//  WaniKani
//
//  Created by Andriy K. on 10/21/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

//wanikani.score.leaderboard.0

import UIKit
import GameKit
import GCHelper

enum LevelProgressionStage {
  case PLEASANT
  case PAINFUL
  case DEATH
  case HELL
  case PARADISE
  case REALITY
  
  var achievementGameCenterID: String {
    let lowerCaseString = "\(self)".lowercaseString
    return baseIdentifier + lowerCaseString
  }
  
  private var baseIdentifier: String {
    return "achievements.lessons."
  }
  
  private var index: Int {
    switch self {
    case .PLEASANT: return 0
    case .PAINFUL: return 1
    case .DEATH: return 2
    case .HELL: return 3
    case .PARADISE: return 4
    case .REALITY: return 5
    }
  }
  
  // percentage is value from 1.0 to 100.0
  static func stageForLevel(level: Int) -> (stage: LevelProgressionStage, percentage: Double) {
    var stage: LevelProgressionStage
    var percentage: Double = 1.0
    switch level {
    case  1...10: percentage = (Double(level -  0) / 11 ) * 100; stage = .PLEASANT;
    case 11...20: percentage = (Double(level - 10) / 11 ) * 100; stage = .PAINFUL;
    case 21...30: percentage = (Double(level - 20) / 11 ) * 100; stage = .DEATH;
    case 31...40: percentage = (Double(level - 30) / 11 ) * 100; stage = .HELL;
    case 41...50: percentage = (Double(level - 40) / 11 ) * 100; stage = .PARADISE;
    case 51...60: percentage = (Double(level - 50) / 11 ) * 100; stage = .REALITY;
    default : stage = .PLEASANT
    }
    return (stage, percentage)
  }
  
  static func stagesLowerThen(level: Int) -> [LevelProgressionStage] {
    let stage = stageForLevel(level).stage
    let index = stage.index
    return Array(allValues[0..<index])
  }
  
  
  
  static let allValues = [PLEASANT, PAINFUL, DEATH, HELL, PARADISE, REALITY]
}

class AwardsManager: NSObject {
  
  static let sharedInstance = AwardsManager()
  private var previousLevelNotSubmitted: Int?
  
  let syncAlreadySetting = Setting(key: "syncNeededSettingKey", script: nil, description: nil)
  
  private let player: GKLocalPlayer = GKLocalPlayer.localPlayer()
  private let rootViewController: UIViewController = {
    let q = UIApplication.sharedApplication().delegate as! AppDelegate
    return q.rootViewController
  }()
  
  //initiate gamecenter
  func authenticateLocalPlayer() {
    guard SettingsSuit.sharedInstance.shouldUseGameCenter == true else {return}
    GCHelper.sharedInstance.authenticateLocalUser()
  }
  
  func resetAchievements() {
    guard SettingsSuit.sharedInstance.shouldUseGameCenter == true else {return}
    guard player.authenticated == true else {print("not authentificated"); return}
    
    GKAchievement.resetAchievementsWithCompletionHandler(nil)
  }
  
  private var lastSubmitedLevel = IntUserDefault(key: "lastSubmitedLevel")
  
  func userLevelUp(oldLevel oldLevel: Int?, newLevel: Int) {
    
    guard SettingsSuit.sharedInstance.shouldUseGameCenter == true else {return}
    
    guard player.authenticated == true else {print("not authentificated"); return}
    guard lastSubmitedLevel.value != newLevel else {print("level was sumbitted before"); return}
    
    var achievementsToReport = [GKAchievement]()

    // Unlock older achievements
    let olderStages = LevelProgressionStage.stagesLowerThen(newLevel)
    for stage in olderStages {
      let key = stage.achievementGameCenterID
      let achievement = GKAchievement(identifier: key, player: player)
      if achievement.completed == false {
        achievement.showsCompletionBanner = false
        achievement.percentComplete = 100
        achievementsToReport.append(achievement)
      }
    }
    
    achievementsToReport.last?.showsCompletionBanner = true

    // This stage progress
    let thisStageInfo = LevelProgressionStage.stageForLevel(newLevel)
    let thisStage = thisStageInfo.stage
    let percentage = thisStageInfo.percentage
    let key = thisStage.achievementGameCenterID
    let achievement = GKAchievement(identifier: key, player: player)
    if achievement.completed == false {
      achievement.percentComplete = percentage
      achievement.showsCompletionBanner = false
      achievementsToReport.append(achievement)
    }
    
    GKAchievement.reportAchievements(achievementsToReport) { (error) -> Void in
      guard error == nil else {return}
    }

  }
  
  func showGameCenterViewController() {
    guard SettingsSuit.sharedInstance.shouldUseGameCenter == true else {
      let alert = UIAlertController(title: "GameCenter disabled", message: "Enable GameCenter to browse Leaderboards and Achievements", preferredStyle: UIAlertControllerStyle.Alert)
      alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
      rootViewController.presentViewController(alert, animated: true, completion: nil)
      return
    }
    GCHelper.sharedInstance.showGameCenter(appDelegate.rootViewController, viewState: GKGameCenterViewControllerState.Leaderboards)
  }
  
  //send high score to leaderboard
  func saveHighscore(scoreUpdate:Int) {
    
    guard SettingsSuit.sharedInstance.shouldUseGameCenter == true else {return}
    
    if GKLocalPlayer.localPlayer().authenticated && scoreUpdate > 0 {
      
      let leaderboard = GKLeaderboard()
      leaderboard.identifier = "wanikani.score.leaderboard.0"
      leaderboard.loadScoresWithCompletionHandler({ (score, error) -> Void in
        var oldValue: Int64 = 0
        if let _ = score, let localScore = leaderboard.localPlayerScore where error == nil {
          oldValue = localScore.value
        }
        
        let scoreReporter = GKScore(leaderboardIdentifier: "wanikani.score.leaderboard.0")
        
        scoreReporter.value = oldValue + Int64(scoreUpdate)
        
        let scoreArray: [GKScore] = [scoreReporter]
        
        GKScore.reportScores(scoreArray, withCompletionHandler: { (error) -> Void in
          if let error = error {
            print(error)
          } else {
            GKNotificationBanner.showBannerWithTitle("\(scoreUpdate) reviews recorded", message: "Total reviews: \(oldValue + scoreUpdate)", completionHandler: { () -> Void in
              //
            })
          }
        })
        
      })
    }
    
  }
  
}


extension AwardsManager: GKGameCenterControllerDelegate {
  func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
    rootViewController.dismissViewControllerAnimated(true, completion: nil)
  }
}


