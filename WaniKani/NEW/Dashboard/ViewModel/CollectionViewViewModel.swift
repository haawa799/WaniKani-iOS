//
//  CollectionViewViewModel.swift
//  WaniKani
//
//  Created by Andriy K. on 3/21/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import Foundation

typealias CollectionViewCellDataItem = (viewModel: ViewModel, reuseIdentifier: String)
typealias CollectionViewSection = (header: CollectionViewCellDataItem?, items: [CollectionViewCellDataItem])

struct CollectionViewViewModel {
  
  private let sections: [CollectionViewSection]
  
  init(sections: [CollectionViewSection]) {
    self.sections = sections
  }
  
  func cellDataItemForIndexPath(indexPath: NSIndexPath) -> CollectionViewCellDataItem? {
    guard sections.count > indexPath.section else { return nil}
    let section = sections[indexPath.section]
    guard section.items.count > indexPath.item else { return nil }
    return section.items[indexPath.item]
  }
  
  func headerItem(section: Int) -> CollectionViewCellDataItem? {
    guard sections.count > section else { return nil}
    let section = sections[section]
    return section.header
  }
  
  func numberOfSections() -> Int {
    return sections.count
  }
  
  func numberOfItemsInSection(section: Int) -> Int? {
    guard sections.count > section else { return nil}
    let section = sections[section]
    return section.items.count
  }
}