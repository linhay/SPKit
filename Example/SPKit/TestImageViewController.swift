//
//  TestImageViewController.swift
//  SPKit_Example
//
//  Created by linhey on 2018/12/15.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class TestImageViewController: UIViewController {

  @IBOutlet weak var imageView: UIImageView!
  
  
  @IBAction func clear(_ sender: Any) {
    imageView.sp.removeSubviews()
  }
  
  @IBAction func blurEvent(_ sender: UIButton) {
    imageView.sp.blur()
  }
  
  @IBAction func downloadEvent(_ sender: UIButton) {
    let url = URL(string: "https://raw.githubusercontent.com/linhay/SPKit/master/Screenshot/logo.jpg")!
    imageView.sp.download(from: url,
                          placeholder: UIImage.init(named: "loading"),
                          completionHandler: nil)
  }
  
}
