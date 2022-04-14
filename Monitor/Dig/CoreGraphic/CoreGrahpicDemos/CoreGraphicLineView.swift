//
//  CoreGraphicLineView.swift
//  Monitor
//
//  Created by Fri on 2022/4/13.
//

import UIKit

final class CoreGraphicLineView: UIView {

  override func draw(_ rect: CGRect) {
    guard let ctx = UIGraphicsGetCurrentContext() else {return}
    ctx.drawInStore {
      ctx.setStrokeColor(UIColor.blue.cgColor)
      ctx.setLineWidth(4)
      ctx.setShadow(offset: CGSize(width: 10, height: 10), blur: 10, color: UIColor.yellow.cgColor)
      ctx.setLineCap(.round)
      ctx.move(to: CGPoint(x: 20, y: 10))
      ctx.addLine(to: CGPoint(x: 20, y: 40))
      ctx.addLine(to: CGPoint(x: 200, y: 40))
      ctx.closePath()
      ctx.strokePath()
    }
  }
}
