//
//  AvaliableItemCell.swift
//
//
//  Created by Andriy K. on 8/19/15.
//
//

import UIKit

protocol AvaliableItemCellDataSource: DisclosureVisibilityData, LeftRightTitleDatasource {}

protocol DisclosureVisibilityData: ViewModel {
  var disclosureVisible: Bool { get }
}

class AvaliableItemCell: UICollectionViewCell, FlippableView, SingleReuseIdentifier, ViewModelSetupable {
  
  private struct ConstraintConstant {
    static let expanded: CGFloat = 40
    static let nonExpanded: CGFloat = 22
  }
  
  @IBOutlet private weak var disclosureButton: UIButton!
  @IBOutlet private weak var leftLabel: UILabel!
  @IBOutlet weak var rightLabel: UILabel!
  @IBOutlet weak var rightLabelTrailingConstraint: NSLayoutConstraint!
  
  func setupWith(datasource: AvaliableItemCellDataSource) {
    leftLabel?.text = datasource.leftTitle
    rightLabel?.text = datasource.rightTitle
    leftLabel?.textColor = datasource.leftTextColor
    rightLabel?.textColor = datasource.rightTextColor
    
    if datasource.disclosureVisible {
      rightLabelTrailingConstraint.constant = ConstraintConstant.expanded
    } else {
      rightLabelTrailingConstraint.constant = ConstraintConstant.nonExpanded
    }
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