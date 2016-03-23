//
//  SetupStepViewController.swift
//  WaniKani
//
//  Created by Andriy K. on 11/17/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit


class SetupStepViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addBackground(BackgroundOptions.Setup.rawValue)
    setupNavigationButtons()
  }
  
  var nextButton: UIBarButtonItem?
  var previousButton: UIBarButtonItem?
  
  private func setupNavigationButtons() {
    if needsNextButton() {
      nextButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SetupStepViewController.nextStep))
      navigationItem.rightBarButtonItem = nextButton
    }
    
    if needsPreviousStep() {
      previousButton = UIBarButtonItem(title: "Previous", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SetupStepViewController.previousStep))
      navigationItem.leftBarButtonItem = previousButton
    } else {
      self.navigationItem.leftBarButtonItem = nil
      self.navigationItem.hidesBackButton = true
    }
  }
}

extension SetupStepViewController {
  
  func nextStep() {
    
  }
  
  func previousStep() {
    
  }
  
  func needsPreviousStep() -> Bool {
    return true
  }
  
  func needsNextButton() -> Bool {
    return true
  }
}
