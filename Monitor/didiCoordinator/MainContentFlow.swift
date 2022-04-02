//
//  MainContentFlow.swift
//  Monitor
//
//  Created by Fri on 2022/3/30.
//

import Foundation
import UIKit

struct A: CaseIterable {
  static var allCases: [A] = []
}

enum MainContentBranch: Branch, CaseIterable {
  case content
  case buildForm
  case coreGraphic
  case functional
  
  static var allContents: [MainContentBranch] {
    Array(MainContentBranch.allCases[1...])
  }
}

final class MainContentFlow: Flow {
  typealias BranchType = MainContentBranch
  
  let rootViewController: UIViewController?
  private var navigationViewController: UINavigationController? {
    rootViewController as? UINavigationController
  }
  
  private let buildFormFlow: BuildFormFlow
  private let coreGraphicFlow: CoreGraphicFlow
  private let functionalProgramFlow: FunctionProgramContentFlow
  
  init(rootViewController: UIViewController) {
    self.rootViewController = rootViewController
    buildFormFlow = BuildFormFlow(rootViewController: rootViewController)
    coreGraphicFlow = CoreGraphicFlow(rootViewController: rootViewController)
    functionalProgramFlow = FunctionProgramContentFlow(rootViewController: rootViewController)
  }
  
  func direct(to branch: MainContentBranch) {
    switch branch {
    case .content:
      navigationViewController?.setViewControllers([MainContentViewController(flow: self)], animated: false)
    case .buildForm:
      navigationViewController?.pushViewController(BuildingFormContentViewController(flow: buildFormFlow), animated: true)
    case .coreGraphic:
      navigationViewController?.pushViewController(CoreGraphicContentViewController(flow: coreGraphicFlow), animated: true)
    case .functional:
      navigationViewController?.pushViewController(FunctionalProgramContentViewController(flow: functionalProgramFlow), animated: true)
    }
  }
}
