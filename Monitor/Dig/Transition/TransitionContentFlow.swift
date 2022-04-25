//
//  TransitionContentFlow.swift
//  Monitor
//
//  Created by Fri on 2022/4/24.
//

import UIKit

enum TransitionContentBranch: Branch, CaseIterable {
  case content
  case changeSize
  case ApplyRect
  case chapter2
  case chapter3
  case chapter4
  case chapter5
  case chapter6
  case chapter7
  
  static var allContents: [TransitionContentBranch] {
    Array(TransitionContentBranch.allCases[1...])
  }
}

final class TransitionContentFlow: Flow {
  
  let rootViewController: UIViewController?
  private var navigationViewController: UINavigationController? {
    rootViewController as? UINavigationController
  }
  
  typealias BranchType = TransitionContentBranch

  init(rootViewController: UIViewController) {//
    self.rootViewController = rootViewController
  }
  
  func direct(to branch: TransitionContentBranch) {
    switch branch {
    case .content:
      break
    case .changeSize:
      
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
