//
//  SettingsScriptCell.swift
//  WaniKani
//
//  Created by Andriy K. on 9/23/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit

protocol SettingsScriptCellDelegate: class {
  func scriptCellChangedState(cell: SettingsScriptCell ,state: Bool)
}

class SettingsScriptCell: UICollectionViewCell, FlippableView, SingleReuseIdentifier {
  
  weak var delegate: SettingsScriptCellDelegate?
  
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var flatSwitch: AIFlatSwitch!
  
  @objc @IBAction private func switchValueChanged(sender: AIFlatSwitch) {
    delegate?.scriptCellChangedState(self, state: sender.selected)
  }
  
  func setupWith(name name: String, initialState: Bool) {
    titleLabel.text = name
    flatSwitch.selected = initialState
  }
  
}
