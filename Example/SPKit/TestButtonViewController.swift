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
  
  
  let button: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(color: UIColor.red, size: CGSize(width: 15, height: 15)), for: UIControl.State.normal)
    button.setTitle("文字文字文", for: UIControl.State.normal)
    return button
  }()


  @IBOutlet weak var tableView: StaticTableView!{
    didSet{
      tableView.separatorStyle = .none
      tableView.dataSourceAuxiliary.numberOfSections = 1
      tableView.dataSourceAuxiliary.numberOfRowsInSections = [2]

      let cell1 = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
      cell1.textLabel?.text = "UIButton().sp.verticalCenterImageAndTitle(spacing: CGFloat)"
      let cell2 = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
      cell2.textLabel?.text = "UIButton().sp.horizontalCenterTitleAndImage(spacing: CGFloat)"
      tableView.delegateAuxiliary.selectedEvents[0]?[0] = { 
        self.contentView.sp.removeSubviews()
        self.button.sp.verticalCenterImageAndTitle(spacing: 5)
        self.contentView.addSubview(self.button)
      }
      tableView.delegateAuxiliary.selectedEvents[0]?[1] = {
        self.contentView.sp.removeSubviews()
        self.button.sp.horizontalCenterTitleAndImage(spacing: 5)
        self.contentView.addSubview(self.button)
      }
      tableView.dataSourceAuxiliary.cells = [[cell1,cell2]]
    }
  }
  
  @IBOutlet weak var contentView: UIView!{
    didSet{
      self.button.width  = self.contentView.width * 0.5
      self.button.height = self.contentView.height * 0.5
      self.button.midX = self.contentView.width * 0.5
      self.button.midY = self.contentView.height * 0.5
    }
  }
  
  


}
