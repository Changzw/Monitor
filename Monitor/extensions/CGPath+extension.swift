//
//  CGMutablePath+extension.swift
//  Monitor
//
//  Created by Fri on 2022/4/13.
//

import UIKit

extension CGPath {
  static func rounded(for rect: CGRect, radius: CGFloat) -> CGPath {
    let path = CGMutablePath()
    let midTopPoint = CGPoint(x: rect.midX, y: rect.minY)
    path.move(to: midTopPoint)
    
    let topRightPoint = CGPoint(x: rect.maxX, y: rect.minY)
    let bottomRightPoint = CGPoint(x: rect.maxX, y: rect.maxY)
    let bottomLeftPoint = CGPoint(x: rect.minX, y: rect.maxY)
    let topLeftPoint = CGPoint(x: rect.minX, y: rect.minY)
    
    path.addArc(tangent1End: topRightPoint, tangent2End: bottomRightPoint, radius: radius)
    path.addArc(tangent1End: bottomRightPoint, tangent2End: bottomLeftPoint, radius: radius)
    path.addArc(tangent1End: bottomLeftPoint, tangent2End: topLeftPoint, radius: radius)
    path.addArc(tangent1End: topLeftPoint, tangent2End: topRightPoint, radius: radius)
    path.closeSubpath()
    
    return path
  }
}
