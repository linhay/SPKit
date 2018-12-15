//
//  StaricTableView.swift
//  SPKit_Example
//
//  Created by linhey on 2018/12/15.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit


class UITableViewDelegateAuxiliary: NSObject, UITableViewDelegate {
  
  var selectedEvents = [Int: [Int: () -> Void]]()
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedEvents[indexPath.section]?[indexPath.item]?()
  }
  
}


class UITableViewDataSourceAuxiliary: NSObject, UITableViewDataSource {
  
  weak var delegateAuxiliary: UITableViewDelegateAuxiliary?
  
  var numberOfRowsInSections = [Int]()
  var numberOfSections = 0{
    didSet{
      (0...numberOfSections - 1).forEach { delegateAuxiliary?.selectedEvents[$0] = [Int: () -> Void]() }
    }
  }
  var cells = [[UITableViewCell]]()
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return numberOfSections
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numberOfRowsInSections[section]
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return cells[indexPath.section][indexPath.item]
  }
  
}

class StaticTableView: UITableView {

  let dataSourceAuxiliary = UITableViewDataSourceAuxiliary()
  let delegateAuxiliary = UITableViewDelegateAuxiliary()

  init() {
    super.init(frame: CGRect.zero, style: UITableView.Style.plain)
    self.delegate = delegateAuxiliary
    self.dataSource = dataSourceAuxiliary
    dataSourceAuxiliary.delegateAuxiliary = delegateAuxiliary
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.delegate = delegateAuxiliary
    self.dataSource = dataSourceAuxiliary
    dataSourceAuxiliary.delegateAuxiliary = delegateAuxiliary

  }
  
}
