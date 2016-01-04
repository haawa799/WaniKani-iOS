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
  
  @IBOutlet weak var pageControl: UIPageControl! {
    didSet {
      guard let pages = kanjiArray?.count where pages > 0 else { return }
      pageControl?.numberOfPages = pages
    }
  }
  
  var swipeLeftGesture: UISwipeGestureRecognizer!
  var swipeRightGesture: UISwipeGestureRecognizer!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: "swipeLeft")
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left
    swipeRightGesture = UISwipeGestureRecognizer(target: self, action: "swipeRight")
    swipeRightGesture.direction = UISwipeGestureRecognizerDirection.Right
    strokeDrawingView.addGestureRecognizer(swipeLeftGesture)
    strokeDrawingView.addGestureRecognizer(swipeRightGesture)
    strokeDrawingView.userInteractionEnabled = true
  }
  
  func swipeLeft() {
    let maxIndex = pageControl.numberOfPages
    let currentIndex = pageControl.currentPage
    let desiredIndex = currentIndex + 1
    
    guard let kanjiArray = kanjiArray where (desiredIndex >= 0) && (desiredIndex < maxIndex) else { return }
    let kanji = kanjiArray[desiredIndex]
    strokeDrawingView?.stopForeverAnimation()
    strokeDrawingView?.clean()
    strokeDrawingView?.dataSource = kanji
    pageControl.currentPage = desiredIndex
  }
  
  func swipeRight() {
    let maxIndex = pageControl.numberOfPages
    let currentIndex = pageControl.currentPage
    let desiredIndex = currentIndex - 1
    
    guard let kanjiArray = kanjiArray where (desiredIndex >= 0) && (desiredIndex < maxIndex) else { return }
    let kanji = kanjiArray[desiredIndex]
    strokeDrawingView?.stopForeverAnimation()
    strokeDrawingView?.clean()
    strokeDrawingView?.dataSource = kanji
    pageControl.currentPage = desiredIndex
  }
  
  
  var kanjiCharacters: [String]? {
    didSet {
      guard let kanjiCharacters = kanjiCharacters where kanjiCharacters.count > 0 else { return }
      
      trashAction(self)
      
      
      var kanjiArray = [Kanji]()
      for kanjiCharacter in kanjiCharacters {
        if let kanji = Kanji.kanjiFromString(kanjiCharacter) {
          kanjiArray.append(kanji)
        }
      }
      self.kanjiArray = kanjiArray
    }
  }
  
  private var kanjiArray: [Kanji]? {
    didSet {
      guard let kanjiArray = kanjiArray else { return }
      strokeDrawingView?.stopForeverAnimation()
      strokeDrawingView?.clean()
      strokeDrawingView?.dataSource = kanjiArray.first
      pageControl?.numberOfPages = kanjiArray.count
      pageControl?.currentPage = 0
    }
  }
  
}

extension KanjiPracticeViewController: StrokeDrawingViewDataDelegate {
  func layersAreNowReadyForAnimation() {
    if strokeDrawingView?.dataSource != nil {
      strokeDrawingView?.playForever(1.3)
    }
  }
}
