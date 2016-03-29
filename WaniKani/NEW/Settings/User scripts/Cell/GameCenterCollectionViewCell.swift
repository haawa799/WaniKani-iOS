//
//  GameCenterCollectionViewCell.swift
//  WaniKani
//
//  Created by Andriy K. on 10/26/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit

class GameCenterCollectionViewCell: UICollectionViewCell, FlippableView, SingleReuseIdentifier, ViewModelSetupable {
  @IBOutlet weak var label: UILabel!
}

extension GameCenterCollectionViewCell {
  func setupWithViewModel(viewModel: ViewModel?) {
    guard let viewModel = viewModel as? SingleTitleViewModel else { return }
    label?.text = viewModel.title
  }
}
