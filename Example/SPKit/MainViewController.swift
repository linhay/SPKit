//
//  MainViewController.swift
//  SPKit_Example
//
//  Created by linhey on 2018/12/15.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      contentView.removeFromSuperview()
      tableView.snp.remakeConstraints { (make) in
        make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(8)
        make.bottom.equalTo(self.bottomLayoutGuide.snp.top).offset(-8)
        make.left.equalToSuperview().offset(8)
        make.right.equalToSuperview().offset(-8)
      }
      
      items.append(TableElement(title: "UIView", subtitle: "") {

      })
      
      items.append(TableElement(title: "UIImageView", subtitle: "") {
        let vc = TestImageViewController()
        self.navigationController?.pushViewController(vc, animated: true)
      })
      
      items.append(TableElement(title: "UIImage", subtitle: "") {
        let vc = TestImageController()
        self.navigationController?.pushViewController(vc, animated: true)
      })
      
      items.append(TableElement(title: "UIImage-UIColor", subtitle: "") {
        let vc = TestImageColorController()
        self.navigationController?.pushViewController(vc, animated: true)
      })
      
      items.append(TableElement(title: "UIButton", subtitle: "") {
        let vc = TestButtonViewController()
        self.navigationController?.pushViewController(vc, animated: true)
      })
    }

}
