//
//  LevelsBlockCell.swift
//  WaniKani
//
//  Created by Andriy K. on 1/11/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

class LevelsBlockCell: UICollectionViewCell {
  
  @IBOutlet weak var topLabel: UILabel!
  @IBOutlet weak var botLabel: UILabel!
  @IBOutlet weak var middleLabel: UILabel!
  
  func setupWith(topText topText: String, botText: String, midText: String) {
    topLabel.text = topText
    botLabel.text = botText
    middleLabel.text = midText
  }
  
}

extension LevelsBlockCell: SingleReuseIdentifier {}
