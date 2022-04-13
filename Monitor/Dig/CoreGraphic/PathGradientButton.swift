//
//  CPRelationButton.swift
//  Monitor
//
//  Created by Fri on 2022/4/13.
//

import UIKit

struct CPRelationButtonStyle {
  let isFillGradient: Bool// = false
  let outterBorderWidth: CGFloat = 1
  let innerBorderWidth: CGFloat = 1
  let innerBorderColor: UIColor// = UIColor.random
  let bordersGap: CGFloat = 2
  
  let outterBorderGradientColors: [UIColor]// = [UIColor.random, UIColor.random]
  let contentBgGradientColors: [UIColor]// = [UIColor.random, UIColor.random]
  
  let titleColor: UIColor// = .random
}

extension CPRelationButtonStyle{
  static let disable = CPRelationButtonStyle(
    isFillGradient: true,
    innerBorderColor: .clear,
    outterBorderGradientColors: [UIColor("#EEEEEE"), UIColor("#DDD9E4")],
    contentBgGradientColors: [UIColor("#EAE7F0"), UIColor("#D8D4DF")],
    titleColor: UIColor("#A6AEC0")
  )
  static let enableFilled = CPRelationButtonStyle(
    isFillGradient: true,
    innerBorderColor: .clear,
    outterBorderGradientColors: [UIColor("#E0C8FF"), UIColor("#EFE2FF")],
    contentBgGradientColors: [UIColor("#C38FFF"), UIColor("#666FFF")],
    titleColor: .white
  )
  static let enableHollow = CPRelationButtonStyle(
    isFillGradient: false,
    innerBorderColor: UIColor("#7872F9"),
    outterBorderGradientColors: [UIColor("#E0C8FF"), UIColor("#EFE2FF")],
    contentBgGradientColors: [],
    titleColor: UIColor("#7872F9")
  )
}

fileprivate extension CPRelationButtonStyle {
  var innerInset: CGFloat {
    outterBorderWidth+innerBorderWidth*0.5+bordersGap
  }
}

final class CPRelationButton: UIButton {
  var style: CPRelationButtonStyle = .enableHollow {
    didSet {
      setTitleColor(style.titleColor, for: .normal)
      setNeedsDisplay()
    }
  }
  
  override func draw(_ rect: CGRect) {
    guard let ctx = UIGraphicsGetCurrentContext() else { return }
    
    let outterOffset = style.outterBorderWidth/2
    let outterPath = CGPath.rounded(for: rect.insetBy(dx: outterOffset, dy: outterOffset), radius: rect.midY-outterOffset)
    ctx.drawInStore {
      ctx.addPath(outterPath)
      ctx.setLineWidth(style.outterBorderWidth)
      ctx.replacePathWithStrokedPath()
      ctx.clip()
      guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                      colors: style.outterBorderGradientColors.map(\.cgColor) as CFArray,
                                      locations: [0.0 ,1.0]) else { return }
      ctx.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: rect.maxY), options: [])
    }
    
    let innerInset = style.innerInset
    let innerPath = CGPath.rounded(for: rect.insetBy(dx: innerInset, dy: innerInset), radius: rect.midY - innerInset)
    if style.isFillGradient {
      ctx.drawInStore {
        ctx.addPath(innerPath)
        ctx.clip()
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: style.contentBgGradientColors.map(\.cgColor) as CFArray,
                                        locations: [0.0 ,1.0]) else { return }
        ctx.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: rect.height), options: [])
      }
    }else {
      ctx.drawInStore {
        ctx.addPath(innerPath)
        ctx.setLineWidth(style.innerBorderWidth)
        ctx.setStrokeColor(style.innerBorderColor.cgColor)
        ctx.strokePath()
      }
    }
  }
}


final class PathGradientButton: UIButton {
  var style: CPRelationButtonStyle = .enableHollow {
    didSet {
      setTitleColor(style.titleColor, for: .normal)
      setNeedsDisplay()
    }
  }
  
  //  override init(frame: CGRect) {
  //    super.init(frame: frame)
  ////    layer.borderColor = UIColor.blue.cgColor
  ////    layer.borderWidth = 1
  //  }
  //
  //  required init?(coder: NSCoder) {
  //    fatalError("init(coder:) has not been implemented")
  //  }
  
  override func draw(_ rect: CGRect) {
    guard let ctx = UIGraphicsGetCurrentContext() else { return }
    
    let outterOffset = style.outterBorderWidth/2
    let outterPath = UIBezierPath(roundedRect: rect.insetBy(dx: outterOffset, dy: outterOffset), cornerRadius: rect.midY-style.outterBorderWidth).cgPath// CGPath.rounded(for: bounds.insetBy(dx: outterOffset, dy: outterOffset), radius: bounds.height/2-outterOffset)
    ctx.drawInStore {
      ctx.setLineWidth(style.outterBorderWidth)
      ctx.addPath(outterPath)
      ctx.replacePathWithStrokedPath()
      ctx.clip()
      guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                      colors: style.outterBorderGradientColors.map(\.cgColor) as CFArray,
                                      locations: [0.0 ,1.0]) else { return }
      ctx.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: rect.maxY), options: [])
    }
    
    let innerInset = style.innerInset
    let innerPath = CGPath.rounded(for: bounds.insetBy(dx: innerInset, dy: innerInset), radius: bounds.height/2 - innerInset)
    if style.isFillGradient {
      ctx.drawInStore {
        ctx.addPath(innerPath)
        ctx.clip()
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: style.contentBgGradientColors.map(\.cgColor) as CFArray,
                                        locations: [0.0 ,1.0]) else { return }
        ctx.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: bounds.height), options: [])
      }
    }else {
      ctx.drawInStore {
        ctx.setLineWidth(style.innerBorderWidth)
        ctx.addPath(innerPath)
        //      ctx.replacePathWithStrokedPath()
        ctx.setStrokeColor(style.innerBorderColor.cgColor)
        ctx.strokePath()
        //      ctx.clip()
      }
    }
  }
}
