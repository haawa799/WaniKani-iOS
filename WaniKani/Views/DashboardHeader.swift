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
  @IBOutlet private weak var backgroundImage: UIImageView!
  
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
