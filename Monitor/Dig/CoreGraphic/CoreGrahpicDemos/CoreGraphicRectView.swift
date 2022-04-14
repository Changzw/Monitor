//
//  CoreGraphicRectView.swift
//  Monitor
//
//  Created by Fri on 2022/4/13.
//

import UIKit

final class CoreGraphicRectView: UIView {

  override func draw(_ rect: CGRect) {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    //设置上下文使用的颜色
//    CGContextSetLineWidth(context, 6.0);
//    CGContextSetShadowWithColor(context, CGSizeMake(10.0f, 10.0f), 20.0f, [UIColor yellowColor].CGColor);
//    CGContextSetLineCap(context, kCGLineCapRound);
//    CGRect strokeRect = CGRectMake(50.0, 100.0, 250.0, 300.0);
//    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
//    //开始绘制
//    CGContextStrokeRect(context, strokeRect);
    guard let ctx = UIGraphicsGetCurrentContext() else {return}
    ctx.drawInStore {
      ctx.setLineWidth(4)
      ctx.setShadow(offset: CGSize(width: 10, height: 10), blur: 10, color: UIColor.yellow.cgColor)
      ctx.setLineCap(.round)
      UIColor.orange.set()
      ctx.stroke(rect.insetBy(dx: 20, dy: 25))
    }

  }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
