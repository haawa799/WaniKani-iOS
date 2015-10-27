//
//  GameCenterViewController.swift
//  WaniKani
//
//  Created by Andriy K. on 10/26/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit
import GameKit

class GameCenterViewController: UIViewController {
  
  private(set) var gameCenterViewController: GKGameCenterViewController = {
    let vc = GKGameCenterViewController()
    vc.viewState = GKGameCenterViewControllerState.Leaderboards
    vc.leaderboardIdentifier = "wanikani.score.leaderboard.0"
    return vc
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    gameCenterViewController.gameCenterDelegate = self
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewWillAppear(animated)
    presentViewController(gameCenterViewController, animated: false, completion: nil)
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    gameCenterViewController.dismissViewControllerAnimated(false, completion: nil)
  }
  
  
  
}

extension GameCenterViewController: GKGameCenterControllerDelegate {
  func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
    gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
  }
}
