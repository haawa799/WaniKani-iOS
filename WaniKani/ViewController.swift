//
//  ViewController.swift
//  WaniKani
//
//  Created by Andriy K. on 8/11/15.
//  Copyright (c) 2015 Andriy K. All rights reserved.
//

import UIKit
import WaniKit
import RealmSwift

class ViewController: UIViewController {

  let backgroundQueue = dispatch_queue_create("background", nil)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    WaniApiManager.sharedInstance.fetchUserInfo { (user) -> () in
//      println(user!)
      
      if let user = user {
        let realm = Realm()
        realm.beginWrite()
        realm.add(user, update: true)
        realm.commitWrite()
        
        
        let users = realm.objects(User)
        println(users)
      }
    }
  }
  
}

