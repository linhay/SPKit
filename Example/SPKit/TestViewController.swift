//
//  TestViewController.swift
//  SPKit_Example
//
//  Created by linhey on 2018/12/15.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import SPKit

class TestViewController: UIViewController {
  
  
  @IBOutlet weak var sp_test_description_views: UIView!
  @IBOutlet weak var sp_description: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    sp_description.text = sp_test_description_views.sp.description
  }
  
}
