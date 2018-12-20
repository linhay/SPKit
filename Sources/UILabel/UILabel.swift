//
//  SPKit
//
//  Copyright (c) 2017 linhay - https://  github.com/linhay
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

import UIKit




// MARK: - UILabel 属性扩展
extension UILabel {
  
  /// 调整文字绘制区域
  public var textInset: UIEdgeInsets {
    get{
      if let eventInterval = objc_getAssociatedObject(self, UILabel.SwzzlingKeys.textInset!) as? UIEdgeInsets {
        return eventInterval
      }
      return UIEdgeInsets.zero
    }
    set {
      UILabel.swizzig()
      objc_setAssociatedObject(self,
                               UILabel.SwzzlingKeys.textInset!,
                               newValue as UIEdgeInsets,
                               .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      drawText(in: bounds)
    }
  }
  
  @objc fileprivate func sp_drawText(in rect: CGRect) {
    let rect = CGRect(x: bounds.origin.x + textInset.left,
                      y: bounds.origin.y + textInset.top,
                      width: bounds.size.width - textInset.left - textInset.right,
                      height: bounds.size.height - textInset.top - textInset.bottom)
    sp_drawText(in: rect)
  }
  
}

// MARK: - UILabel 函数扩展
public extension SPExtension where Base: UILabel {
  
  /// 改变字体大小 增加或者减少
  public func change(font offSet: CGFloat) {
    base.font = UIFont(name: base.font.fontName, size: base.font.pointSize + offSet)
  }
  
}

// MARK: - runtime and swizzling
fileprivate extension UILabel {
  fileprivate static var once: Bool = false
  fileprivate class func swizzig() {
    if once == false {
      once = true
      
      let select1 = #selector(UILabel.drawText(in:))
      let select2 = #selector(UILabel.sp_drawText(in:))
      let classType = UILabel.self
      let select1Method = class_getInstanceMethod(classType, select1)
      let select2Method = class_getInstanceMethod(classType, select2)
      let didAddMethod  = class_addMethod(classType,
                                          select1,
                                          method_getImplementation(select2Method!),
                                          method_getTypeEncoding(select2Method!))
      if didAddMethod {
        class_replaceMethod(classType,
                            select2,
                            method_getImplementation(select1Method!),
                            method_getTypeEncoding(select1Method!))
      }else {
        method_exchangeImplementations(select1Method!, select2Method!)
      }
    }
  }
  
  fileprivate struct SwzzlingKeys {
    static var textInset = UnsafeRawPointer(bitPattern: "label_textInset".hashValue)
  }
}
