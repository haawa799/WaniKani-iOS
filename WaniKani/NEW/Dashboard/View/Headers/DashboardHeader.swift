//
//  DashboardHeader.swift
//  
//
//  Created by Andriy K. on 8/19/15.
//
//

import UIKit

protocol SingleTitleViewModel: ViewModel {
  var title: String { get }
}

protocol DashboardHeaderDatasource: SingleTitleViewModel {
  var bgColor: UIColor? { get }
}

extension DashboardHeaderDatasource {
  var bgColor: UIColor? {
    return ColorConstants.dashboardColor
  }
}

class DashboardHeader: UICollectionReusableView, SingleReuseIdentifier, ViewModelSetupable {
  
  @IBOutlet weak var realHeaderWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var realHeader: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet private var coloredViews: [UIView]!
  
  var color: UIColor? = UIColor(red:0.92, green:0.12, blue:0.39, alpha:1) {
    didSet {
      guard let coloredViews = coloredViews else {return}
      for v in coloredViews {
        v.backgroundColor = color
      }
    }
  }
  
  func setupWith(viewModel: DashboardHeaderDatasource) {
    titleLabel?.text = viewModel.title
    color = viewModel.bgColor
  }
  
  func resize(newWidth: CGFloat) {
    realHeaderWidthConstraint.constant = newWidth
  }
}

// MARK: - UICollectionReusableView
extension DashboardHeader {
  override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel?.text = nil
  }
}

// MARK: - ViewModelSetupable
extension DashboardHeader {
  func setupWithViewModel(viewModel: ViewModel?) {
    guard let viewModel = viewModel as? DashboardHeaderDatasource else { return }
    setupWith(viewModel)
  }
}