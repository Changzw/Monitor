//
//  ModalTransitionManager.swift
//  Monitor
//
//  Created by Fri on 2022/4/30.
//

import UIKit

protocol InteractionControlling: UIViewControllerInteractiveTransitioning {
  var interactionInProgress: Bool { get }
}

final class ModalTransitionManager: NSObject {
  
  private var interactionController: InteractionControlling?
  
  init(interactionController: InteractionControlling?) {
    self.interactionController = interactionController
  }
}

extension ModalTransitionManager: UIViewControllerTransitioningDelegate {
  
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    return ModalPresentationController(presentedViewController: presented, presenting: presenting)
  }
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return ModalTransitionAnimator(presenting: true)
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return ModalTransitionAnimator(presenting: false)
  }
  
//  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//    guard let interactionController = interactionController, interactionController.interactionInProgress else {
//      return nil
//    }
//    return interactionController
//  }
}
