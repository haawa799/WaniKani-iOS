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
    switch section {
    case 0: return 2
    case 1: return 1
    default:
      break
    }
    return 0
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 2
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    var name = ""
    var state = false
    
    switch (indexPath.row, indexPath.section) {
    case (0, 0):
      name = UserScriptsSuit.sharedInstance.fastForwardScript.name
      state = UserScriptsSuit.sharedInstance.fastForwardEnabled
    case (1, 0):
      name = UserScriptsSuit.sharedInstance.ignoreButtonScript.name
      state = UserScriptsSuit.sharedInstance.ignoreButtonEnabled
    case (0, 1):
      name = "Status bar hidden on Reviews"
      state = UserScriptsSuit.sharedInstance.hideStatusBarEnabled
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
    header.color = collectionView.tintColor
    switch indexPath.section {
    case 0:
      header.titleLabel?.text = "Scripts for Reviews"
    case 1:
      header.titleLabel?.text = "Other options"
    default: break
    }
    return header
  }
}

extension SettingsViewController: SettingsScriptCellDelegate {
  
  func scriptCellChangedState(cell: SettingsScriptCell ,state: Bool) {
    guard let indexPath = collectionView?.indexPathForCell(cell) else {return}
    switch (indexPath.row, indexPath.section) {
    case (0, 0):
      UserScriptsSuit.sharedInstance.fastForwardEnabled = state
    case (1, 0):
      UserScriptsSuit.sharedInstance.ignoreButtonEnabled = state
    case (0, 1):
      UserScriptsSuit.sharedInstance.hideStatusBarEnabled = state
    default: break
    }
  }
}
