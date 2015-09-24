//
//  ReviewCell.swift
//  
//
//  Created by Andriy K. on 8/23/15.
//
//

import UIKit

class ReviewCell: UICollectionViewCell, FlippableView, SingleReuseIdentifier {

  @IBOutlet weak var numberLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  
  func setupWith(title: String, numberText: String) {
    titleLabel?.text = title
    numberLabel?.text = numberText
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel?.text = nil
    numberLabel?.text = nil
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    prepareForReuse()
  }
}