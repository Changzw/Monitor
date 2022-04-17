//
//  CoreGraphicCircle.swift
//  Monitor
//
//  Created by Fri on 2022/4/18.
//

import UIKit
class CoreGraphicCircleView: UIView {
  lazy var l = UILabel().then{
    $0.textColor = .white
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(l)
    l.snp.makeConstraints{
      $0.center.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

final class CoreGraphicCircle1: CoreGraphicCircleView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    l.text = "1"
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func draw(_ rect: CGRect) {
    let p = UIBezierPath(ovalIn: rect) //rectUIBezierPath(ovalIn: CGRect(0,0,100,100))
    UIColor.random.setFill()
    p.fill()
  }
}

final class CoreGraphicCircle2: CoreGraphicCircleView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    l.text = "2"
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func draw(_ rect: CGRect) {
    let con = UIGraphicsGetCurrentContext()!
    con.addEllipse(in:rect)
    con.setFillColor(UIColor.random.cgColor)
    con.fillPath()
  }
}

final class CoreGraphicCircle3: CoreGraphicCircleView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    l.text = "3"
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func draw(_ rect: CGRect) {}// 要想下面的方法被调用必须显示重写该方法
  override func draw(_ layer: CALayer, in ctx: CGContext) {
    UIGraphicsPushContext(ctx)
    let p = UIBezierPath(ovalIn: bounds)
    UIColor.random.setFill()
    p.fill()
    UIGraphicsPopContext()
  }
}

final class CoreGraphicCircle4: CoreGraphicCircleView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    l.text = "4"
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func draw(_ rect: CGRect) {}
  override func draw(_ layer: CALayer, in ctx: CGContext) {
    ctx.addEllipse(in:bounds)
    ctx.setFillColor(UIColor.random.cgColor)
    ctx.fillPath()
  }
}
