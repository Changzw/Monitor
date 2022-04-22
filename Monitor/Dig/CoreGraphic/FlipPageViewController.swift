//
//  FlipPageViewController.swift
//  Monitor
//
//  Created by Fri on 2022/4/17.
//

import UIKit

final class FlipPageViewController: UIViewController {

  let flipView = CALayer().then {
    $0.backgroundColor = UIColor.random.cgColor
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    view.layer.addSublayer(flipView)
    view.backgroundColor = .white
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    flipView.frame = CGRect(x: view.bounds.midX, y: view.bounds.midY/2, width: view.bounds.midX, height: 250)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    let flipLayer = flipView//.layer
    var initialTransform = flipLayer.transform
    initialTransform.m34 = 1.0/(-1000)
    
    UIView.animate(withDuration: 10000, delay: 5, options: [.curveLinear]) {
      flipLayer.transform = initialTransform
      flipLayer.anchorPoint = CGPoint(x: 0, y: 0.5)
      var rotationAndPerspectiveTransform3D = flipLayer.transform
      rotationAndPerspectiveTransform3D = CATransform3DRotate(rotationAndPerspectiveTransform3D, CGFloat.pi, 0, -flipLayer.bounds.size.height/2, 0)
      flipLayer.transform = rotationAndPerspectiveTransform3D
    } completion: { finish in
      
    }
  }
}

