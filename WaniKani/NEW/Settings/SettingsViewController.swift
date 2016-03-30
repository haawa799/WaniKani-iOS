//
//  SettingsViewController.swift
//
//
//  Created by Andriy K. on 9/13/15.
//
//

import UIKit
import GameKit

protocol SettingsViewControllerDelegate: class {
  func cellPressed(indexPath: NSIndexPath)
  func cellCheckboxStateChange(id: String, state: Bool)
}

class SettingsViewController: UIViewController, StoryboardInstantiable {
  
  weak var delegate: SettingsViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addBackground(BackgroundOptions.Dashboard.rawValue)
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
  
  var collectionViewModel: CollectionViewViewModel? {
    didSet {
      collectionView?.reloadData()
    }
  }
  
}

extension SettingsViewController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    delegate?.cellPressed(indexPath)
  }
}

extension SettingsViewController: UICollectionViewDataSource {
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    guard let collectionViewModel = collectionViewModel else { return 0 }
    return collectionViewModel.numberOfSections()
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collectionViewModel?.numberOfItemsInSection(section) ?? 0
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    var cell: UICollectionViewCell!
    guard let item = collectionViewModel?.cellDataItemForIndexPath(indexPath) else { return cell }
    cell = collectionView.dequeueReusableCellWithReuseIdentifier(item.reuseIdentifier, forIndexPath: indexPath)
    (cell as? SettingsScriptCell)?.delegate = self
    (cell as? ViewModelSetupable)?.setupWithViewModel(item.viewModel)
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    guard let _ = collectionViewModel?.headerItem(section) else { return CGSizeZero }
    guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSizeZero }
    return flowLayout.headerReferenceSize
  }
  
  func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    var header: UICollectionReusableView!
    guard let item = collectionViewModel?.headerItem(indexPath.section) else { return header }
    header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: item.reuseIdentifier, forIndexPath: indexPath)
    (header as? ViewModelSetupable)?.setupWithViewModel(item.viewModel)
    guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return header }
    let size = self.collectionView(collectionView, layout: flowLayout, referenceSizeForHeaderInSection: indexPath.section)
    (header as? DashboardHeader)?.resize(size.width)
    return header
  }
}

extension SettingsViewController: SettingsScriptCellDelegate {
  
  func scriptCellChangedState(cell: SettingsScriptCell ,state: Bool) {
    guard let id = cell.id else { return }
    delegate?.cellCheckboxStateChange(id, state: state)
  }
}
