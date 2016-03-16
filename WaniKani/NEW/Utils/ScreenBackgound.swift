//
//  ScreenBackgound.swift
//  WaniKani
//
//  Created by Andriy K. on 3/14/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

enum BackgroundOptions: String {
  case Data = "data_bg"
  case Dashboard = "art0"
  case Setup = "bg"
}

protocol BluredBackground {
  func addBackground(imageName: String) -> Bool
}

extension BluredBackground where Self: UIViewController {
  func addBackground(imageName: String) -> Bool {
    guard let image = UIImage(named: imageName) else { return false }
    
    let effect = UIBlurEffect(style: UIBlurEffectStyle.Light)
    let bluredView = UIVisualEffectView(effect: effect)
    bluredView.frame = view.bounds
    bluredView.translatesAutoresizingMaskIntoConstraints = false
    view.insertSubview(bluredView, atIndex: 0)
    let views1 = ["bluredView": bluredView]
    let hConstraints1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[bluredView]-0-|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: views1)
    view.addConstraints(hConstraints1)
    let wConstraints1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[bluredView]-0-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: views1)
    view.addConstraints(wConstraints1)
    
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