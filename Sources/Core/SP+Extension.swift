//
//  BLKit.h
//  Pods
//
//  Created by BigL on 2017/9/16.
//

import UIKit

class Extensions { }

public struct BLExtension<Base> {
  public let base: Base
  public init(_ base: Base) {
    self.base = base
  }
}

public protocol ExtensionCompatible {
  associatedtype CompatibleType
  var sp: CompatibleType { get }
}

public extension ExtensionCompatible {
  public var sp: BLExtension<Self> {
    get { return BLExtension(self) }
  }
}

extension UIImage: ExtensionCompatible { }
extension UIView: ExtensionCompatible { }
extension UIViewController: ExtensionCompatible { }




