//
//  ViewContentFlow.swift
//  Monitor
//
//  Created by Fri on 2022/4/23.
//

import UIKit

enum ViewContentBranch: Branch, CaseIterable {
  case content
  case first
  case ApplyRect
  case chapter2
  case chapter3
  case chapter4
  case chapter5
  case chapter6
  case chapter7
  
  static var allContents: [ViewContentBranch] {
    Array(ViewContentBranch.allCases[1...])
  }
}

final class ViewContentFlow: Flow {
  
  let rootViewController: UIViewController?
  private var navigationViewController: UINavigationController? {
    rootViewController as? UINavigationController
  }
  
  typealias BranchType = ViewContentBranch

  init(rootViewController: UIViewController) {//
    self.rootViewController = rootViewController
  }
  
  func direct(to branch: ViewContentBranch) {
    switch branch {
    case .content:
      break
    case .first:
      break
    case .ApplyRect:
      break
    case .chapter2:
      break
    case .chapter3:
      break
    case .chapter4:
      break
    case .chapter5:
      break
    case .chapter6:
      break
    case .chapter7:
      break
    }
  }
}
