//
//  AvaliableItemCell.swift
//
//
//  Created by Andriy K. on 8/19/15.
//
//

import UIKit

protocol AvaliableItemCellDataSource: ViewModel {
  var leftTitle: String { get }
  var rightTitle: String { get }
  var disclosureVisible: Bool { get }
}

class AvaliableItemCell: UICollectionViewCell, FlippableView, SingleReuseIdentifier, ViewModelSetupable {
  
  @IBOutlet private weak var disclosureButton: UIButton!
  @IBOutlet private weak var leftLabel: UILabel!
  @IBOutlet weak var rightLabel: UILabel!
  
  func setupWith(datasource: AvaliableItemCellDataSource) {
    leftLabel?.text = datasource.leftTitle
    rightLabel?.text = datasource.rightTitle
    disclosureButton?.hidden = !datasource.disclosureVisible
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    leftLabel?.text = nil
    rightLabel?.text = nil
    disclosureButton?.hidden = true
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    prepareForReuse()
  }
}

// MARK: - ViewModelSetupable
extension AvaliableItemCell {
  func setupWithViewModel(viewModel: ViewModel?) {
    guard let viewModel = viewModel as? AvaliableItemCellDataSource else { return }
    setupWith(viewModel)
  }
}