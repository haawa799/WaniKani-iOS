//
//  SettingsViewController.swift
//
//
//  Created by Andriy K. on 9/13/15.
//
//

import UIKit
import GameKit
import EasyGameCenter

class SettingsViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBOutlet weak var collectionView: UICollectionView! {
    didSet {
      collectionView?.dataSource = self
      collectionView?.delegate = self
      collectionView?.alwaysBounceVertical = true
      let scriptCell = UINib(nibName: "SettingsScriptCell", bundle: nil)
      collectionView?.registerNib(scriptCell, forCellWithReuseIdentifier: SettingsScriptCell.identifier)
      let gameCenterCell = UINib(nibName: "GameCenterCollectionViewCell", bundle: nil)
      collectionView?.registerNib(gameCenterCell, forCellWithReuseIdentifier: GameCenterCollectionViewCell.identifier)
      let headerNib = UINib(nibName: "DashboardHeader", bundle: nil)
      collectionView?.registerNib(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: DashboardHeader.identifier)
    }
  }
  
  let settings = SettingsSuit.sharedInstance.settings
  
}

extension SettingsViewController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    switch (indexPath.section, indexPath.row) {
    case (1, 2): AwardsManager.sharedInstance.showGameCenterViewController()
    default: break
    }
  }
}

extension SettingsViewController: UICollectionViewDataSource {
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return settings[section]!.settings.count
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return settings.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let setting = settings[indexPath.section]!.settings[indexPath.row]
    let name = setting.description ?? ""
    
    switch (indexPath.section, indexPath.row) {
    case (1, 2):
      let identifier = GameCenterCollectionViewCell.identifier
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! GameCenterCollectionViewCell
      cell.label.text = name
      return cell
    default :
      let identifier = SettingsScriptCell.identifier
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! SettingsScriptCell
      cell.setupWith(name: name, initialState: setting.enabled)
      cell.delegate = self
      return cell
    }
  }
  
  func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: DashboardHeader.identifier, forIndexPath: indexPath) as! DashboardHeader
    header.color = collectionView.tintColor
    header.titleLabel?.text = settings[indexPath.section]?.name
    return header
  }
}

extension SettingsViewController: SettingsScriptCellDelegate {
  
  func scriptCellChangedState(cell: SettingsScriptCell ,state: Bool) {
    guard let indexPath = collectionView?.indexPathForCell(cell) else {return}
    let q = settings[indexPath.section]!.settings[indexPath.row]
    q.enabled = state
  }
}
