//
//  LevelData.swift
//  WaniKani
//
//  Created by Andriy K. on 1/14/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit
import RealmSwift

class LevelData: Object {
  
  dynamic var kanjiList: [Kanji]?
  
}

class Kanji: Object {
  
}
