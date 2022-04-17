//
//  CoreGraphicDemosViewController.swift
//  Monitor
//
//  Created by Fri on 2022/4/13.
//

import UIKit

final class CoreGraphicDemosViewController: UIViewController {
  
  let scrollView = UIScrollView()
  let textView = CoreGraphicTextView()
  let lineView = CoreGraphicLineView()
  let rectView = CoreGraphicRectView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(scrollView)
    scrollView.snp.makeConstraints{
      $0.edges.equalToSuperview()
    }
    
    let stack = VStack {
      HStack {
        textView
        lineView.height(.point(70))
      }
      .distribution(.fillEqually)
      .alignment(.fill)
      rectView.height(.point(100))
      
      VStack {
        HStack {
          CoreGraphicCircle1().square(.point(100))
          CoreGraphicCircle2().square(.point(100))
        }
        .distribution(.equalSpacing)
        HStack {
          CoreGraphicCircle3().square(.point(100))
          CoreGraphicCircle4().square(.point(100))
        }
        .distribution(.equalCentering)
      }
      .distribution(.fillEqually)
    }
      .spacing(5)
      .alignment(.fill)
      .insetAll(5)
    
    scrollView.addSubview(stack)
    stack.snp.makeConstraints{
      $0.width.equalToSuperview()
      $0.left.right.equalToSuperview()
    }
  }
}
