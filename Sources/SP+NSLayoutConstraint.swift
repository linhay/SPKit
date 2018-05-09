//
//  BLKit.h
//  Pods
//
//  Created by BigL on 2017/9/16.
//

import UIKit

public extension BLExtension where Base: NSLayoutConstraint {
  /// 改变Constant 增加或者减少
  /// - Parameter offSet: 变化量
  public func change(constant: CGFloat) {
    let nowConstant = base.constant
    base.constant = nowConstant + constant
  }

  /// 修改倍率
  ///
  /// - Parameter multiplier: 新倍率
  /// - Returns: Constraint
  func change(multiplier: CGFloat) -> NSLayoutConstraint {
    NSLayoutConstraint.deactivate([base])

    let newConstraint = NSLayoutConstraint(
      item: base.firstItem as Any,
      attribute: base.firstAttribute,
      relatedBy: base.relation,
      toItem: base.secondItem,
      attribute: base.secondAttribute,
      multiplier: multiplier,
      constant: base.constant)

    newConstraint.priority = base.priority
    newConstraint.shouldBeArchived = base.shouldBeArchived
    newConstraint.identifier = base.identifier

    NSLayoutConstraint.activate([newConstraint])
    return newConstraint
  }

}
