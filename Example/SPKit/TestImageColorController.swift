//
//  TestImageColorController.swift
//  SPKit_Example
//
//  Created by linhey on 2019/1/12.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class TestImageColorController: BaseViewController {

  
    let image = UIImage(named: "torch")!
    let imageView = UIImageView(image: UIImage(named: "torch")).then { (item) in
      item.contentMode = UIView.ContentMode.center
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()
      contentView.addSubview(imageView)
      
      imageView.do { (item) in
        item.snp.makeConstraints({ (make) in
          make.top.left.equalToSuperview().offset(8)
          make.bottom.right.equalToSuperview().offset(-8)
        })
      }
      
      items.append(TableElement(title: "复原", subtitle: "") {
        self.imageView.image = self.image
      })
      
      items.append(TableElement(title: "red", subtitle: "") {
        self.imageView.image = self.image.sp.setTint(color: UIColor.red)
      })
      
    }
    
}
