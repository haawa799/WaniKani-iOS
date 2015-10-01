//
//  LevelInfoView.swift
//  WaniKani
//
//  Created by Andriy K. on 9/30/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit

class LevelInfoView: UIView {
  @IBOutlet weak var label: UILabel! {
    didSet {
      label.adjustsFontSizeToFitWidth = true
    }
  }
}
