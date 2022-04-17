//
//  FlipPageViewController.swift
//  Monitor
//
//  Created by Fri on 2022/4/17.
//

import UIKit

final class FlipPageViewController: UIViewController {
//  let firstView = UIView(frame: CGRect(x: 32, y: 32, width: 128, height: 128))
//  let secondView = UIView(frame: CGRect(x: 32, y: 32, width: 128, height: 128))

  let flipView = CALayer().then {
    $0.backgroundColor = UIColor.random.cgColor
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    view.layer.addSublayer(flipView)
//    view.addSubview(flipView)
    view.backgroundColor = .white
//    flipView.snp.makeConstraints{
//      $0.left.equalTo(view.snp.centerX)
//      $0.centerY.equalToSuperview()
//      $0.size.equalToSuperview().dividedBy(2)
//    }
    
//    firstView.backgroundColor = .random
//    secondView.backgroundColor = .random
//
//
//    view.addSubview(firstView)
//    view.addSubview(secondView)
//    firstView.snp.makeConstraints{
//      $0.center.equalToSuperview()
//      $0.width.height.equalTo(150)
//    }
//    secondView.snp.makeConstraints{
//      $0.edges.equalTo(firstView)
//    }
//    firstView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
//    secondView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    flipView.frame = CGRect(x: view.bounds.midX, y: view.bounds.midY/2, width: view.bounds.midX, height: 250)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    let flipLayer = flipView//.layer
    var initialTransform = flipLayer.transform
    initialTransform.m34 = 1.0/(-1000)
//    flipLayer.duration = 3
//    let animator = CABasicAnimation()
    UIView.beginAnimations("Scale", context: nil)
    UIView.setAnimationDuration(5)
    UIView.setAnimationCurve(.linear)
    flipLayer.transform = initialTransform
    
    
//    UIView.animate(withDuration: 10000, delay: 5, options: [.curveLinear]) {
//      flipLayer.transform = initialTransform
    flipLayer.anchorPoint = CGPoint(x: 0, y: 0.5)
    var rotationAndPerspectiveTransform3D = flipLayer.transform
    rotationAndPerspectiveTransform3D = CATransform3DRotate(rotationAndPerspectiveTransform3D, CGFloat.pi, 0, -flipLayer.bounds.size.height/2, 0)
    flipLayer.transform = rotationAndPerspectiveTransform3D
//    } completion: { finish in
//
//    }
    UIView.setAnimationDelegate(self)
    UIView.commitAnimations()
  }
}

