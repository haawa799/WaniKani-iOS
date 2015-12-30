//
//  KanjiPracticeViewController.swift
//  WaniKani
//
//  Created by Andriy K. on 12/30/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit
import StrokeDrawingView
import WaniKit
import ACEDrawingView

class KanjiPracticeViewController: UIViewController {
  
  @IBOutlet weak var strokeDrawingView: StrokeDrawingView! {
    didSet {
      strokeDrawingView.delegate = self
    }
  }
  @IBOutlet weak var drawingView: ACEDrawingView! {
    didSet {
      drawingView?.lineColor = UIColor(red:0.99, green:0, blue:0.65, alpha:1)
      drawingView?.lineWidth = 5
    }
  }
  
  @IBAction func undoAction(sender: AnyObject) {
    drawingView.undoLatestStep()
  }
  
  @IBAction func trashAction(sender: AnyObject) {
    drawingView.clear()
  }
  
  func setKanji() {
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  var kanjiCharacter: String? {
    didSet {
      guard let kanjiCharacter = kanjiCharacter else { return }
      kanji = Kanji(kanji: kanjiCharacter)
    }
  }
  
  private var kanji: Kanji? {
    didSet {
      guard let kanji = kanji else { return }
      strokeDrawingView?.stopForeverAnimation()
      strokeDrawingView?.clean()
      strokeDrawingView?.dataSource = kanji
    }
  }
  
}

extension KanjiPracticeViewController: StrokeDrawingViewDataDelegate {
  func layersAreNowReadyForAnimation() {
    if kanji != nil {
      strokeDrawingView?.playForever()
    }
  }
}
