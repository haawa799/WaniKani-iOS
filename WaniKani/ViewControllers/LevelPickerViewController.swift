//
//  LevelPickerViewController.swift
//  WaniKani-Kanji-Strokes
//
//  Created by Andriy K. on 12/28/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit

class LevelPickerViewController: UIViewController {
  
  let numberOfLevels = 10
  
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView?.dataSource = self
      tableView?.delegate = self
    }
  }
  
  var index = 0 {
    didSet {
      tableView?.reloadData()
    }
  }
  
  func levelForIndexPath(indexPath: NSIndexPath) -> Int {
    return (index * numberOfLevels) + indexPath.row
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    super.prepareForSegue(segue, sender: sender)
    
    if let level = sender as? Int, let vc = segue.destinationViewController as? LevelViewController {
      
      let trueLevel = level + 1
      vc.title = "lvl: \(trueLevel)"
      vc.level = trueLevel
      hidesBottomBarWhenPushed = true
    }
  }
}

extension LevelPickerViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numberOfLevels
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("levelCell")!
    let level = levelForIndexPath(indexPath)
    cell.textLabel?.text = "Lvl:  \(level + 1)"
    return cell
  }
}

extension LevelPickerViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("levelSelected", sender: levelForIndexPath(indexPath))
  }
  
}