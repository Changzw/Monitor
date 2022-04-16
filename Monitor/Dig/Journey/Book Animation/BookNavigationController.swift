//
//  BookNavigationController.swift
//  Monitor
//
//  Created by Fri on 2022/4/14.
//

import UIKit

final class BookNavigationController: UINavigationController {
  override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
  }
}

extension BookNavigationController: UINavigationControllerDelegate {
  func navigationController(
    _ navigationController: UINavigationController,
    animationControllerFor operation: UINavigationController.Operation,
    from fromVC: UIViewController,
    to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      switch operation {
      case .pop:
        if let vc = toVC as? BooksViewController {
          return vc.animationControllerForDismissController(vc)
        }
        return nil
      case .push:
        if let vc = fromVC as? BooksViewController {
          return vc.animationControllerForPresentController(toVC)
        }
      default:
        return nil
      }
      return nil
    }
}
