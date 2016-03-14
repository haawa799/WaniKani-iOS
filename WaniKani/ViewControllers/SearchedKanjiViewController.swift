//
//  SearchedKanjiViewController.swift
//  WaniKani
//
//  Created by Andriy K. on 1/21/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit
import DataKit

class SearchedKanjiViewController: UIViewController {
  
  private var kanjiViewController: KanjiStrokesViewController? {
    didSet {
      kanjiViewController?.kanjiInfo = kanjiInfo
    }
  }
  var kanjiInfo: Kanji? {
    didSet {
      kanjiViewController?.kanjiInfo = kanjiInfo
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addBackground(BackgroundOptions.Data.rawValue)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    super.prepareForSegue(segue, sender: sender)
    
    if let kanjiVC = segue.destinationViewController as? KanjiStrokesViewController {
      kanjiViewController = kanjiVC
    }
  }
  @IBAction func dismiss(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
}


