//
//  CoreGraphicTextView.swift
//  Monitor
//
//  Created by Fri on 2022/4/13.
//

import UIKit

final class CoreGraphicTextView: UIView {

  var textColor: UIColor = .random {
    didSet {
      setNeedsDisplay()
    }
  }
  var font: UIFont? = UIFont(name: "DINCondensed-Bold", size: 20) {
    didSet {
      setNeedsDisplay()
    }
  }
  
  override func draw(_ rect: CGRect) {
    let str = "CoreGraphic基本使用" as NSString

    str.draw(in: rect.insetBy(dx: 20, dy: 20), withAttributes: [
      NSAttributedString.Key.foregroundColor: textColor,
      NSAttributedString.Key.font: font
    ])
  }
}
