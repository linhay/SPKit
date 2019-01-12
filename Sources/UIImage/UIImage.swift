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

#if canImport(UIKit)
import CoreMedia

public extension UIImage{
  /// from CMSampleBuffer
  ///
  /// must import CoreMedia
  /// from: https://stackoverflow.com/questions/15726761/make-an-uiimage-from-a-cmsamplebuffer
  ///
  /// - Parameter sampleBuffer: CMSampleBuffer
  public convenience init?(sampleBuffer: CMSampleBuffer) {
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, .readOnly)
    // Get the number of bytes per row for the pixel buffer
    let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
    // Get the number of bytes per row for the pixel buffer
    let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
    // Get the pixel buffer width and height
    let width = CVPixelBufferGetWidth(imageBuffer)
    let height = CVPixelBufferGetHeight(imageBuffer)
    // Create a device-dependent RGB color space
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    // Create a bitmap graphics context with the sample buffer data
    var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
    bitmapInfo |= CGImageAlphaInfo.premultipliedFirst.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
    
    //let bitmapInfo: UInt32 = CGBitmapInfo.alphaInfoMask.rawValue
    // Create a Quartz image from the pixel data in the bitmap graphics context
    guard let context = CGContext(data: baseAddress,
                                  width: width,
                                  height: height,
                                  bitsPerComponent: 8,
                                  bytesPerRow: bytesPerRow,
                                  space: colorSpace,
                                  bitmapInfo: bitmapInfo),
      let quartzImage = context.makeImage() else { return nil }
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly)
    // Create an image object from the Quartz image
    self.init(cgImage: quartzImage)
  }
  
}

#endif

// MARK: - 初始化
public extension UIImage{
  
  /// 获取指定颜色的图片
  ///
  /// - Parameters:
  ///   - color: UIColor
  ///   - size: 图片大小
  public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
    if size.width <= 0 || size.height <= 0 { return nil }
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
    guard let context = UIGraphicsGetCurrentContext() else { return nil }
    context.setFillColor(color.cgColor)
    context.fill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    guard let cgImg = image?.cgImage else { return nil }
    self.init(cgImage: cgImg)
  }
  
}


// MARK: - UIImage
public extension SPExtension where Base: UIImage{
  
  /// 图片尺寸: Bytes
  public var sizeAsBytes: Int
  { return base.jpegData(compressionQuality: 1)?.count ?? 0 }
  
  /// 图片尺寸: KB
  public var sizeAsKB: Int {
    let sizeAsBytes = self.sizeAsBytes
    return sizeAsBytes != 0 ? sizeAsBytes / 1024: 0 }
  
  /// 图片尺寸: MB
  public var sizeAsMB: Int {
    let sizeAsKB = self.sizeAsKB
    return sizeAsBytes != 0 ? sizeAsKB / 1024: 0 }
  
}

// MARK: - UIImage
public extension SPExtension where Base: UIImage{
  /// 返回一张没有被渲染图片
  public var original: UIImage { return base.withRenderingMode(.alwaysOriginal) }
  /// 返回一张可被渲染图片
  public var template: UIImage { return base.withRenderingMode(.alwaysTemplate) }
}

public extension SPExtension where Base: UIImage{

  /// 修改单色系图片颜色
  ///
  /// - Parameter color: 颜色
  /// - Returns: 新图
  public func setTint(color: UIColor) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(base.size, false, 1)
    defer { UIGraphicsEndImageContext() }
    color.setFill()
    let bounds = CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height)
    UIRectFill(bounds)
    base.draw(in: bounds, blendMode: CGBlendMode.overlay, alpha: 1)
    base.draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1)
    return UIGraphicsGetImageFromCurrentImageContext() ?? base
  }
  
}

// MARK: - UIImage 图片处理
public extension SPExtension where Base: UIImage{
  
  /// 裁剪对应区域
  ///
  /// - Parameter bound: 裁剪区域
  /// - Returns: 新图
  public func crop(bound: CGRect) -> UIImage {
    let scaledBounds = CGRect(x: bound.origin.x * base.scale,
                              y: bound.origin.y * base.scale,
                              width: bound.size.width * base.scale,
                              height: bound.size.height * base.scale)
    guard let cgImage = base.cgImage?.cropping(to: scaledBounds) else { return base }
    return UIImage(cgImage: cgImage, scale: base.scale, orientation: .up)
  }
  
  /// 返回圆形图片
  public func rounded() -> UIImage {
    return base.sp.rounded(radius: base.size.height * 0.5,
                           corners: .allCorners,
                           borderWidth: 0,
                           borderColor: nil,
                           borderLineJoin: .miter)
  }
  
  /// 图像处理: 裁圆
  /// - Parameters:
  /// - radius: 圆角大小
  /// - corners: 圆角区域
  /// - borderWidth: 描边大小
  /// - borderColor: 描边颜色
  /// - borderLineJoin: 描边类型
  /// - Returns: 新图
  public func rounded(radius: CGFloat,
                      corners: UIRectCorner = .allCorners,
                      borderWidth: CGFloat = 0,
                      borderColor: UIColor? = nil,
                      borderLineJoin: CGLineJoin = .miter) -> UIImage {
    var corners = corners
    if corners != UIRectCorner.allCorners {
      var rawValue: UInt = 0
      if (corners.rawValue & UIRectCorner.topLeft.rawValue) != 0
      { rawValue = rawValue | UIRectCorner.bottomLeft.rawValue }
      if (corners.rawValue & UIRectCorner.topRight.rawValue) != 0
      { rawValue = rawValue | UIRectCorner.bottomRight.rawValue }
      if (corners.rawValue & UIRectCorner.bottomLeft.rawValue) != 0
      { rawValue = rawValue | UIRectCorner.topLeft.rawValue }
      if (corners.rawValue & UIRectCorner.bottomRight.rawValue) != 0
      { rawValue = rawValue | UIRectCorner.topRight.rawValue }
      corners = UIRectCorner(rawValue: rawValue)
    }
    UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
    defer { UIGraphicsEndImageContext() }
    
    guard let context = UIGraphicsGetCurrentContext() else { return base }
    let rect = CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height)
    context.scaleBy(x: 1, y: -1)
    context.translateBy(x: 0, y: -rect.height)
    let minSize = min(base.size.width, base.size.height)
    
    if borderWidth < minSize * 0.5{
      let path = UIBezierPath(roundedRect: rect.insetBy(dx: borderWidth, dy: borderWidth),
                              byRoundingCorners: corners,
                              cornerRadii: CGSize(width: radius, height: borderWidth))
      
      path.close()
      context.saveGState()
      path.addClip()
      guard let cgImage = base.cgImage else { return base }
      context.draw(cgImage, in: rect)
      context.restoreGState()
    }
    
    if (borderColor != nil && borderWidth < minSize / 2 && borderWidth > 0) {
      let strokeInset = (floor(borderWidth * base.scale) + 0.5) / base.scale
      let strokeRect = rect.insetBy(dx: strokeInset, dy: strokeInset)
      let strokeRadius = radius > base.scale / 2 ? CGFloat(radius - base.scale / 2): 0
      let path = UIBezierPath(roundedRect: strokeRect, byRoundingCorners: corners, cornerRadii: CGSize(width: strokeRadius, height: borderWidth))
      path.close()
      path.lineWidth = borderWidth
      path.lineJoinStyle = borderLineJoin
      borderColor?.setStroke()
      path.stroke()
    }
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    return image ?? base
  }
  
  
  /// 缩放至指定高度
  ///
  /// - Parameters:
  ///   - toWidth: 高度
  ///   - opaque: 透明开关，如果图形完全不用透明，设置为YES以优化位图的存储
  /// - Returns: 新的图片
  public func scaled(toHeight: CGFloat, opaque: Bool = false) -> UIImage? {
    let scale = toHeight / base.size.height
    let newWidth = base.size.width * scale
    UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: toHeight), opaque, 0)
    base.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }
  
  
  /// 缩放至指定宽度
  ///
  /// - Parameters:
  ///   - toWidth: 宽度
  ///   - opaque: 透明开关，如果图形完全不用透明，设置为YES以优化位图的存储
  /// - Returns: 新的图片
  public func scaled(toWidth: CGFloat, opaque: Bool = false) -> UIImage? {
    let scale = toWidth / base.size.width
    let newHeight = base.size.height * scale
    UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: newHeight), opaque, 0)
    base.draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }
  
}
