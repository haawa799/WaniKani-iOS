//✅
//  ScreenBackgound.swift
//  WaniKani
//
//  Created by Andriy K. on 3/14/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

enum BackgroundOptions: String {
  case Data = "data_bg_blured"
  case Dashboard = "dashboard_bg_blured"
  case Setup = "setup_bg_blured"
}

protocol BluredBackground {
  func addBackground(imageName: String) -> Bool
}

extension BluredBackground where Self: UIViewController {
  func addBackground(imageName: String) -> Bool {
    guard let image = UIImage(named: imageName) else { return false }
    
    let imageView = UIImageView(image: image)
    imageView.frame = view.bounds
    imageView.translatesAutoresizingMaskIntoConstraints = false
    view.insertSubview(imageView, atIndex: 0)
    let views = ["imageView": imageView]
    let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[imageView]-0-|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: views)
    view.addConstraints(hConstraints)
    let wConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[imageView]-0-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: views)
    view.addConstraints(wConstraints)
    
    return true
  }
}

extension UIViewController: BluredBackground {}