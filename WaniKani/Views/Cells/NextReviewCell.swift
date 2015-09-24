//
//  NextReviewCell.swift
//
//
//  Created by Andriy K. on 8/27/15.
//
//

import UIKit

protocol NextReviewCellDelegate: class {
  func notificationsEnabled(enabled: Bool)
}

class NextReviewCell: UICollectionViewCell, FlippableView, SingleReuseIdentifier {
  
  weak var delegate: NextReviewCellDelegate?
  
  @IBOutlet weak var notifyMeLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var flatSwitch: AIFlatSwitch!
  
  func setupWith(title: String, notifications: Bool) {
    titleLabel?.text = title
    flatSwitch?.selected = notifications
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel?.text = nil
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    prepareForReuse()
  }
  
  @IBAction func switchValueChange(sender: AIFlatSwitch) {
    delegate?.notificationsEnabled(sender.selected)
  }
}