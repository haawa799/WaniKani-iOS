//
//  LevelPickerViewController.swift
//  WaniKani-Kanji-Strokes
//
//  Created by Andriy K. on 12/28/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit

class LevelPickerViewController: UIViewController {
  
  
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView?.dataSource = self
      tableView?.delegate = self
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    super.prepareForSegue(segue, sender: sender)
    
    if let level = sender as? Int, let vc = segue.destinationViewController as? LevelViewController {
      
      let trueLevel = level + 1
      vc.title = "lvl: \(trueLevel)"
      vc.level = trueLevel
    }
  }
  
}

extension LevelPickerViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 60
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("levelCell")!
    cell.textLabel?.text = "Lvl:  \(indexPath.row + 1)"
    return cell
  }
}

extension LevelPickerViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("levelSelected", sender: indexPath.row)
  }
  
}