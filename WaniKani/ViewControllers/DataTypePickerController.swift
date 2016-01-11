//
//  DataTypePickerController.swift
//  WaniKani
//
//  Created by Andriy K. on 1/11/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import UIKit

class DataTypePickerController: UIViewController {
  
  override func viewWillAppear(animated: Bool) {
    navigationController?.navigationBarHidden = true
    super.viewWillAppear(animated)
  }
  
  
  override func viewWillDisappear(animated: Bool) {
    if (navigationController?.topViewController != self) {
      navigationController?.navigationBarHidden = false
    }
    super.viewWillDisappear(animated)
  }
  
}
