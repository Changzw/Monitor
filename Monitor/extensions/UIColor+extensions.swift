//
//  UIColor+extensions.swift
//  Monitor
//
//  Created by Fri on 2022/4/13.
//

import UIKit

extension UIColor {
  static var random: UIColor {
    .init(red: CGFloat.random(in: 0..<256)/255.0, green: CGFloat.random(in: 0..<256)/255.0, blue: CGFloat.random(in: 0..<256)/255.0, alpha: 1)
  }
  static var randomAlpha: UIColor {
    .init(red: CGFloat.random(in: 0..<256)/255.0, green: CGFloat.random(in: 0..<256)/255.0, blue: CGFloat.random(in: 0..<256)/255.0, alpha: CGFloat.random(in: 0..<256)/255.0)
  }
}


extension UIColor {
  convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
    self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
  }
  
  /// 初始化,颜色合成
  /// 两个颜色叠加之后的最终色（注意区分前景色后景色的顺序）
  /// - Parameters:
  ///   - backendColor: 后景色
  ///   - frontColor: 前景色
//  convenience init(backendColor:UIColor, frontColor:UIColor) {
//    let bgChannel = backendColor.zp.channel
//    let bgAlpha = bgChannel.alpha
//    let bgRed = bgChannel.red
//    let bgGreen = bgChannel.green
//    let bgBlue = bgChannel.blue
//
//    let frChannel = frontColor.zp.channel
//    let frAlpha = frChannel.alpha
//    let frRed = frChannel.red
//    let frGreen = frChannel.green
//    let frBlue = frChannel.blue
//
//    let resultAlpha = frAlpha + bgAlpha * (1 - frAlpha)
//    let resultRed = (frRed * frAlpha + bgRed * bgAlpha * (1 - frAlpha))/resultAlpha
//    let resultGreen = (frGreen * frAlpha + bgGreen * bgAlpha * (1 - frAlpha))/resultAlpha
//    let resultBlue = (frBlue * frAlpha + bgBlue * bgAlpha * (1 - frAlpha))/resultAlpha
//    self.init(red: resultRed, green: resultGreen, blue: resultBlue, alpha: resultAlpha)
//  }
  
  /// 色值生成颜色 ("Use UIColor.zp.makeHex..." ⚠️)
  /// @available(iOS, introduced: 7.0, deprecated: 8.0, message: "Use UIColor.zp.makeHex...")
  convenience init(_ hex: String, alpha: CGFloat = 1.0) {
    var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    if (cString.hasPrefix("#")) {
      cString.remove(at: cString.startIndex)
    }
    
    if cString.count == 6 {
      var rgbValue: UInt64 = 0
      Scanner(string: cString).scanHexInt64(&rgbValue)
      self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16)/255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8)/255.0, blue: CGFloat(rgbValue & 0x0000FF)/255.0, alpha: alpha)
    } else {
#if DEBUG
      assert(cString.count == 6, "HexString not correct.")
#endif
      self.init(white: 1, alpha: 1)
    }
    
  }
  
  /// 用十六进制颜色创建UIColor
  
  /// 使用HEX命名方式的颜色字符串生成一个UIColor对象
  ///
  /// - Parameter hexColor:HEX字符串
  /// #RGB        例如#f0f，等同于#ffff00ff，RGBA(255, 0, 255, 1)
  /// #ARGB       例如#0f0f，等同于#00ff00ff，RGBA(255, 0, 255, 0)
  /// #RRGGBB     例如#ff00ff，等同于#ffff00ff，RGBA(255, 0, 255, 1)
  /// #AARRGGBB   例如#00ff00ff，等同于RGBA(255, 0, 255, 0)
  convenience init(hexColor: String) {
    /// 去掉首尾空格及"#"并且转大写
    let colorString = hexColor.trimmingCharacters(in: .whitespacesAndNewlines)
      .replacingOccurrences(of: "#", with: "")
      .uppercased()
    ///获取颜色值的方法
    func colorComponent(_ formColorStr: String, start: Int, length: Int) -> CGFloat {
      var num: UInt32 = 0
      
      let str = String(formColorStr[formColorStr.index(formColorStr.startIndex, offsetBy: start)..<formColorStr.index(formColorStr.startIndex, offsetBy: start + length)])
      Scanner(string: str).scanHexInt32(&num)
      return CGFloat(num) / 255.0
    }
    
    var alpha: CGFloat = 0.0
    var red: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var green: CGFloat = 0.0
    switch colorString.count {
    case 3:
      alpha = 1.0
      red = colorComponent(colorString, start: 0, length: 1)
      green = colorComponent(colorString, start: 1, length: 1)
      blue = colorComponent(colorString, start: 2, length: 1)
    case 4:
      alpha = colorComponent(colorString, start: 0, length: 1)
      red = colorComponent(colorString, start: 1, length: 1)
      green = colorComponent(colorString, start: 2, length: 1)
      blue = colorComponent(colorString, start: 3, length: 1)
    case 6:
      alpha = 1.0
      red = colorComponent(colorString, start: 0, length: 2)
      green = colorComponent(colorString, start: 2, length: 2)
      blue = colorComponent(colorString, start: 4, length: 2)
    case 8:
      alpha = colorComponent(colorString, start: 0, length: 2)
      red = colorComponent(colorString, start: 2, length: 2)
      green = colorComponent(colorString, start: 4, length: 2)
      blue = colorComponent(colorString, start: 6, length: 2)
      
    default:
      debugPrint("颜色值->",hexColor,"错误","HexStr应该为 #RBG, #ARGB, #RRGGBB, #AARRGGBB")
    }
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}
