//
//  BLKit.h
//  Pods
//
//  Created by BigL on 2017/9/16.
//

import UIKit
// MARK: - open
public extension UIApplication {
  public class func open(urlStr: String) {
    guard let str = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else{ return }
    guard let url = URL(string: str) else { return }
    if UIApplication.shared.canOpenURL(url) {
      if #available(iOS 10.0, *) {
        UIApplication.shared.open(url, completionHandler: nil)
      } else {
        UIApplication.shared.openURL(url)
      }
    }
  }

  public func open(urlStr: String) {
    UIApplication.open(urlStr: urlStr)
  }
}

// MARK: - swizzling
extension UIApplication {
  override open var next: UIResponder? {
    UIControl.swizzling()
    UILabel.swizzling()
    return super.next
  }

}
