//
//  DashboardHeader.swift
//  
//
//  Created by Andriy K. on 8/19/15.
//
//

import UIKit

class DashboardHeader: UICollectionReusableView {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet private var coloredViews: [UIView]!
  
  var color: UIColor = UIColor(red:0.92, green:0.12, blue:0.39, alpha:1) {
    didSet {
      guard let coloredViews = coloredViews else {return}
      for v in coloredViews {
        v.backgroundColor = color
      }
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel?.text = nil
  }
  
}

extension DashboardHeader: SingleReuseIdentifier {
  static var identifier: String {
    return "dashboardHeader"
  }
}
