//
//  TestButtonViewController.swift
//  SPKit_Example
//
//  Created by linhey on 2018/12/15.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import SPKit

class TestButtonViewController: UIViewController {

  @IBOutlet weak var tableView: StaticTableView!{
    didSet{
      tableView.separatorStyle = .none
      tableView.dataSourceAuxiliary.numberOfSections = 1
      tableView.dataSourceAuxiliary.numberOfRowsInSections = [1]
      let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
      cell.textLabel?.text = "UIButton().sp.centerTextAndImage(spacing: CGFloat)"
      tableView.delegateAuxiliary.selectedEvents[0]?[0] = { 
        self.contentView.sp.removeSubviews()
        let button = UIButton()
        button.width  = self.contentView.width * 0.5
        button.height = self.contentView.height * 0.5
        button.midX = self.contentView.width * 0.5
        button.midY = self.contentView.height * 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(UIImage(color: UIColor.red, size: CGSize(width: 15, height: 15)), for: UIControl.State.normal)
        button.setTitle("文字文字文", for: UIControl.State.normal)
        
        button.sp.verticalCenterImageAndTitle(spacing: 5)
        self.contentView.addSubview(button)
      }
      tableView.dataSourceAuxiliary.cells = [[cell]]
    }
  }
  @IBOutlet weak var contentView: UIView!
  
  


}
