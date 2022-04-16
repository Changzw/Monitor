//
//  JournalFlow.swift
//  Monitor
//
//  Created by Fri on 2022/4/14.
//

import UIKit

enum JournalBranch: Branch, CaseIterable {
  case content
  case collection
  case pageViewController
  case catransition
  
  static var allContents: [JournalBranch] {
    Array(JournalBranch.allCases[1...])
  }
}

final class JournalContentFlow: Flow {
  typealias BranchType = JournalBranch
  
  private var navigationViewController: UINavigationController? {
    rootViewController as? UINavigationController
  }
  
  let rootViewController: UIViewController?
  
  init(rootViewController: UIViewController) {
    self.rootViewController = rootViewController
  }
  
  func direct(to branch: JournalBranch) {
    switch branch {
    case .content:
      navigationViewController?.setViewControllers([JournalContentViewController(flow: self)], animated: false)
    case .collection:
//      let nav = BookNavigationController(rootViewController: BooksViewController(collectionViewLayout: BooksLayout()))
//      nav.modalPresentationStyle = .fullScreen
      let vc = BookViewController()
      vc.book = BookStore.sharedInstance.loadBooks(plist: "Books").first
      navigationViewController?.pushViewController(vc, animated: true)
    case .pageViewController:
      navigationViewController?.pushViewController(JournalPageViewController(), animated: true)
    case .catransition:
      navigationViewController?.pushViewController(CATransitionViewController(), animated: true)
    }
  }
}
