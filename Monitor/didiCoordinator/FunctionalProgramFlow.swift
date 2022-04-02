//
//  FunctionalProgramFlow.swift
//  Monitor
//
//  Created by Fri on 2022/4/2.
//

import Foundation
import UIKit

enum FunctionProgramContentBranch: Branch, CaseIterable {
  case content
  
  case battleShip
  
  static var allContents: [FunctionProgramContentBranch] {
    Array(FunctionProgramContentBranch.allCases[1...])
  }
}

final class FunctionProgramContentFlow: Flow {
  typealias BranchType = FunctionProgramContentBranch
  
  private var navigationViewController: UINavigationController? {
    rootViewController as? UINavigationController
  }
  
  private let buildFormFlow: BuildFormFlow
  private let coreGraphicFlow: CoreGraphicFlow
  let rootViewController: UIViewController?
  
  init(rootViewController: UIViewController) {
    self.rootViewController = rootViewController
    buildFormFlow = BuildFormFlow(rootViewController: rootViewController)
    coreGraphicFlow = CoreGraphicFlow(rootViewController: rootViewController)
  }
  
  func direct(to branch: FunctionProgramContentBranch) {
    switch branch {
    case .content:
      navigationViewController?.setViewControllers([FunctionalProgramContentViewController(flow: self)], animated: false)
    case .battleShip:
      
      break
      
    }
  }
}
