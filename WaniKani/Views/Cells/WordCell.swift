//
//  CriticalItemCell.swift
//  WaniKani
//
//  Created by Andriy K. on 11/5/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit

class WordCell: UICollectionViewCell, FlippableView, SingleReuseIdentifier {
  
  @IBOutlet private weak var vocabLabel: UILabel!
  @IBOutlet private weak var meaningLabel: UILabel!
  @IBOutlet private weak var kanaLabel: UILabel!
  @IBOutlet private weak var rightTextLabel: UILabel!
  
  func setupWith(vocabText: String?, meaning: String?, kana: String?, rightLabelText: String?) {
    vocabLabel?.text = vocabText
    meaningLabel?.text = meaning
    kanaLabel?.text = kana
    rightTextLabel?.text = rightLabelText
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    vocabLabel?.text = nil
    meaningLabel?.text = nil
    kanaLabel?.text = nil
    rightTextLabel?.text = nil
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    prepareForReuse()
  }
}
