//
//  SettingsViewController.swift
//
//
//  Created by Andriy K. on 9/13/15.
//
//

import UIKit

class SettingsViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView! {
    didSet {
      collectionView?.dataSource = self
      collectionView?.alwaysBounceVertical = true
      let scriptCell = UINib(nibName: "SettingsScriptCell", bundle: nil)
      collectionView?.registerNib(scriptCell, forCellWithReuseIdentifier: SettingsScriptCell.identifier)
      let headerNib = UINib(nibName: "DashboardHeader", bundle: nil)
      collectionView?.registerNib(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: DashboardHeader.identifier)
    }
  }
}

extension SettingsViewController: UICollectionViewDataSource {
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    var name = ""
    var state = false
    
    switch indexPath.row {
    case 0:
      name = UserScriptsSuit.sharedInstance.fastForwardScript.name
      state = UserScriptsSuit.sharedInstance.fastForwardEnabled
    default:
      break
    }
    
    let identifier = SettingsScriptCell.identifier
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! SettingsScriptCell
    cell.setupWith(name: name, initialState: state)
    cell.delegate = self
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: DashboardHeader.identifier, forIndexPath: indexPath) as! DashboardHeader
    switch indexPath.section {
    case 0:
      header.titleLabel?.text = "Reviews"
      header.color = collectionView.tintColor
    default: break
    }
    return header
  }
}

extension SettingsViewController: SettingsScriptCellDelegate {
  
  func scriptCellChangedState(cell: SettingsScriptCell ,state: Bool) {
    guard let indexPath = collectionView?.indexPathForCell(cell) else {return}
    switch indexPath.row {
    case 0:
      UserScriptsSuit.sharedInstance.fastForwardEnabled = state
    default: break
    }
  }
}
