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

class KanjiPracticeViewController: UIViewController {
  
  @IBOutlet weak var strokeDrawingView: StrokeDrawingView! {
    didSet {
      strokeDrawingView.delegate = self
    }
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
