//
//  ModalPresentationController.swift
//  Monitor
//
//  Created by Fri on 2022/4/30.
//

import UIKit


final class ModalPresentationController: UIPresentationController {
  
  lazy var fadeView: UIView = UIView().then {
    $0.backgroundColor = UIColor.black.withAlphaComponent(0.3)
  }
  
  override func presentationTransitionWillBegin() {
    guard let containerView = containerView else { return }
    
    containerView.insertSubview(fadeView, at: 0)
    fadeView.snp.makeConstraints{
      $0.edges.equalToSuperview()
    }
    guard let coordinator = presentedViewController.transitionCoordinator else {
      fadeView.alpha = 1.0
      return
    }
    coordinator.animate(alongsideTransition: { _ in
      self.fadeView.alpha = 1.0
    })
  }
  
  override func dismissalTransitionWillBegin() {
    guard let coordinator = presentedViewController.transitionCoordinator else {
      fadeView.alpha = 0.0
      return
    }
    
    if !coordinator.isInteractive {
      coordinator.animate(alongsideTransition: { _ in
        self.fadeView.alpha = 0.0
      })
    }
  }
  
  override func containerViewWillLayoutSubviews() {
    presentedView?.frame = frameOfPresentedViewInContainerView
    
  }
  
  override var frameOfPresentedViewInContainerView: CGRect {
    guard let containerView = containerView, let presentedView = presentedView else { return .zero }
    
    let inset: CGFloat = 16
    let safeAreaFrame = containerView.bounds.inset(by: containerView.safeAreaInsets)
    
    let targetWidth = safeAreaFrame.width - 2 * inset
    let fittingSize = CGSize(
      width: targetWidth,
      height: UIView.layoutFittingCompressedSize.height
    )
    
    let targetHeight = presentedView.systemLayoutSizeFitting(
      fittingSize,
      withHorizontalFittingPriority: .required,
      verticalFittingPriority: .defaultLow
    ).height
    
    var frame = safeAreaFrame
    frame.origin.x += inset
    frame.origin.y += 8.0
    frame.size.width = targetWidth
    frame.size.height = targetHeight
    
    return frame
  }
}
