//
//  BaseViewController.swift
//  SPKit_Example
//
//  Created by linhey on 2018/12/15.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit
import Then
import SPKit

struct TableElement {
  var title = ""
  var subtitle = ""
  var event: (() -> Void)?
}

class BaseViewController: UIViewController {
  
  var tableView = UITableView(frame: .zero, style: .plain)
  var contentView = UIView()
  var items = [TableElement](){
    didSet{
      tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = UIColor.white
    self.view.sp.addSubviews(tableView,contentView)
    
    contentView.do { (item) in
      
      item.backgroundColor = UIColor.yellow
      
      item.snp.makeConstraints({ (make) in
        make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(8)
        make.left.equalToSuperview().offset(8)
        make.right.equalToSuperview().offset(-8)
        make.height.equalTo(item.snp.width).multipliedBy(9.0 / 16.0)
      })
    }
    
    tableView.do { (item) in
      
      tableView.delegate = self
      tableView.dataSource = self
      tableView.separatorStyle = .none
      tableView.rowHeight = 60
      
      item.snp.makeConstraints({ (make) in
        make.top.equalTo(self.contentView.snp.bottom).offset(8)
        make.left.equalToSuperview().offset(8)
        make.right.bottom.equalToSuperview().offset(-8)
      })
    }
    
    
    
  }
  
}
extension BaseViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
    cell.textLabel?.text = items[indexPath.item].title
    cell.detailTextLabel?.text = items[indexPath.item].subtitle
    cell.textLabel?.numberOfLines = 0
    return cell
  }
  

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
}

extension BaseViewController: UITableViewDelegate {
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    items[indexPath.item].event?()
  }
  
}
