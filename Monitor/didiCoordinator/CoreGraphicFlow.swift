//
//  CoreGraphicFlow.swift
//  Monitor
//
//  Created by Fri on 2022/3/30.
//

import Foundation
import UIKit

enum CoreGraphicBranch: Branch, CaseIterable {
  case content
  case glossyButton
  case borderGradientButton
  
  static var allContents: [CoreGraphicBranch] {
    Array(CoreGraphicBranch.allCases[1...])
  }
}

final class CoreGraphicFlow: Flow {
  typealias BranchType = CoreGraphicBranch
  
  let rootViewController: UIViewController?
  private var navigationViewController: UINavigationController? {
    rootViewController as? UINavigationController
  }

  init(rootViewController: UIViewController) {
    self.rootViewController = rootViewController
  }

  func direct(to branch: CoreGraphicBranch) {
    switch branch {
    case .content:
//      navigationViewController?.pushViewController(CoreGraphicContentViewController(flow: self), animated: true)
      break
    case .glossyButton:
      navigationViewController?.pushViewController(GlossyButtonViewController(), animated: true)
    case .borderGradientButton:
      navigationViewController?.pushViewController(BorderGradientButtonViewController(), animated: true)
    }
  }
}
