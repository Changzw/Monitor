//
//  BookOpeningTransition.swift
//  Monitor
//
//  Created by Fri on 2022/4/14.
//

import UIKit

final class BookOpeningTransition: NSObject, UIViewControllerAnimatedTransitioning {
  var transforms = [UICollectionViewCell: CATransform3D]() //2
  var toViewBackgroundColor: UIColor? //3
  var isPush = true //4
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    if isPush {
      return 5
    } else {
      return 1
    }
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    //1
    let container = transitionContext.containerView
    //2
    if isPush {
      //3
      guard let fromVC = transitionContext.viewController(forKey: .from) as? BooksViewController,
            let toVC = transitionContext.viewController(forKey: .to) as? BookViewController else {return}
      //4
      container.addSubview(toVC.view)
      // Perform transition
      //5
      self.setStartPositionForPush(fromVC: fromVC, toVC: toVC)
      UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7) {
        self.setStartPositionForPush(fromVC: fromVC, toVC: toVC)
      } completion: { finish in
        self.cleanupPush(fromVC: fromVC, toVC: toVC)
        transitionContext.completeTransition(finish)
      }
    } else {
      //POP
    }
  }
  
  // MARK: Helper Methods
  private func makePerspectiveTransform() -> CATransform3D {
    var transform = CATransform3DIdentity
    transform.m34 = 1.0 / -2000
    return transform
  }
  
  private func closePage(cell : BookPageCell) {
    // 1
    var transform = self.makePerspectiveTransform()
    // 2
    if cell.layer.anchorPoint.x == 0 {
      // 3
      transform = CATransform3DRotate(transform, 0, 0, 1, 0)
      // 4
      transform = CATransform3DTranslate(transform, -0.7 * cell.layer.bounds.width / 2, 0, 0)
      // 5
      transform = CATransform3DScale(transform, 0.7, 0.7, 1)
    } else {
      // 7
      transform = CATransform3DRotate(transform, -CGFloat.pi, 0, 1, 0)
      // 8
      transform = CATransform3DTranslate(transform, 0.7 * cell.layer.bounds.width / 2, 0, 0)
      // 9
      transform = CATransform3DScale(transform, 0.7, 0.7, 1)
    }
    
    //10
    cell.layer.transform = transform
  }
  
  private func setStartPositionForPush(fromVC: BooksViewController, toVC: BookViewController) {
    // 1
    toViewBackgroundColor = fromVC.collectionView?.backgroundColor
    toVC.collectionView.backgroundColor = nil

    //2
    fromVC.selectedCell()?.alpha = 0

    //3
    for cell in toVC.collectionView.visibleCells as! [BookPageCell] {
      //4
      transforms[cell] = cell.layer.transform
      //5
      closePage(cell: cell)
      cell.updateShadowLayer()
      //6
      if let indexPath = toVC.collectionView.indexPath(for: cell) {
        if indexPath.row == 0 {
          cell.shadowLayer.opacity = 0
        }
      }
    }
  }
  
  
  private func cleanupPush(fromVC: BooksViewController, toVC: BookViewController) {
    // Add background back to pushed view controller
    toVC.collectionView.backgroundColor = toViewBackgroundColor
  }
  
}
