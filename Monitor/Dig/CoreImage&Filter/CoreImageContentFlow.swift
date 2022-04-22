//
//  CoreImageContentFlow.swift
//  Monitor
//
//  Created by Fri on 2022/4/22.
//

import UIKit

enum CoreImageContentBranch: Branch, CaseIterable {
  case content
  case subject
  case chapter1
  case chapter2
  case chapter3
  case chapter4
  case chapter5
  case chapter6
  case chapter7
  
  static var allContents: [CoreImageContentBranch] {
    Array(CoreImageContentBranch.allCases[1...])
  }
}

final class CoreImageContentFlow: Flow {
  
  let rootViewController: UIViewController?
  private var navigationViewController: UINavigationController? {
    rootViewController as? UINavigationController
  }
  
  typealias BranchType = CoreImageContentBranch

  init(rootViewController: UIViewController) {//
    self.rootViewController = rootViewController
  }
  
  func direct(to branch: CoreImageContentBranch) {
    switch branch {
    case .content:
      break
    case .subject:
      break
    case .chapter1:
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
