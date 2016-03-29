//
//  SettingsScriptCell.swift
//  WaniKani
//
//  Created by Andriy K. on 9/23/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit

protocol SettingsScriptCellDataSource: SingleTitleViewModel {
  var switchState: Bool { get }
}

protocol SettingsScriptCellDelegate: class {
  func scriptCellChangedState(cell: SettingsScriptCell ,state: Bool)
}

class SettingsScriptCell: UICollectionViewCell, FlippableView, SingleReuseIdentifier, ViewModelSetupable {
  
  weak var delegate: SettingsScriptCellDelegate?
  
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var flatSwitch: AIFlatSwitch!
  
  @objc @IBAction private func switchValueChanged(sender: AIFlatSwitch) {
    delegate?.scriptCellChangedState(self, state: sender.selected)
  }
  
  func setupWith(dataSource: SettingsScriptCellDataSource) {
    titleLabel.text = dataSource.title
    flatSwitch.selected = dataSource.switchState
  }
  
}

extension SettingsScriptCell {
  
  func setupWithViewModel(viewModel: ViewModel?) {
    guard let viewModel = viewModel as? SettingsScriptCellDataSource else { return }
    setupWith(viewModel)
  }
  
}
