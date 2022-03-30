//
//  BuildFormFlow.swift
//  Monitor
//
//  Created by Fri on 2022/3/30.
//

import Foundation
import UIKit

enum BuildFormBranch: Branch, CaseIterable {
  case content
  case chapter0
  case chapter1
  case chapter2
  case chapter3
  case chapter4
  case chapter5
  case chapter6
  case chapter7
  
  static var allContents: [BuildFormBranch] {
    Array(BuildFormBranch.allCases[1...])
  }
}

final class BuildFormFlow: Flow {
  
  let rootViewController: UIViewController?
  private var navigationViewController: UINavigationController? {
    rootViewController as? UINavigationController
  }
  
  typealias BranchType = BuildFormBranch
  
  private var chapter2Driver: BuildFormChapter2.HotspotDriver?
  private var chapter3Driver: BuildFormChapter3.FormDriver?
  private var chapter4Driver: BuildFormChapter4.FormDriver<Hotspot>?
  private var chapter5Driver: BuildFormChapter5.FormDriver<Hotspot>?
  private var chapter6Driver: BuildFormChapter6.FormDriver<Hotspot>?
  private var chapter7Driver: BuildFormChapter7.FormDriver<Hotspot>?
  
  init(rootViewController: UIViewController) {//
    self.rootViewController = rootViewController
  }
  
  func direct(to branch: BuildFormBranch) {
    switch branch {
    case .content:
      navigationViewController?.pushViewController(BuildingFormContentViewController(flow: self), animated: true)

    case .chapter0:
      let vc = BuildFormChapter0.ViewController()
      navigationViewController?.pushViewController(vc, animated: true)
    case .chapter1:
      let vc = BuildFormChapter1.ViewController()//(router: unownedRouter)
      navigationViewController?.pushViewController(vc, animated: true)
    case .chapter2:
      chapter2Driver = BuildFormChapter2.HotspotDriver()
      navigationViewController?.pushViewController(chapter2Driver!.formViewController, animated: true)
    case .chapter3:
      chapter3Driver = BuildFormChapter3.FormDriver(initial: Hotspot(), build: BuildFormChapter3.hotspotForm)
      navigationViewController?.pushViewController(chapter3Driver!.formViewController, animated: true)
    case .chapter4:
      chapter4Driver = BuildFormChapter4.FormDriver(initial: Hotspot(), build: BuildFormChapter4.hotspotForm)
      navigationViewController?.pushViewController(chapter4Driver!.formViewController, animated: true)
    case .chapter5:
      chapter5Driver = BuildFormChapter5.FormDriver(initial: Hotspot(), build: BuildFormChapter5.hotspotForm)
      navigationViewController?.pushViewController(chapter5Driver!.formViewController, animated: true)
    case .chapter6:
      chapter6Driver = BuildFormChapter6.FormDriver(initial: Hotspot(), build: BuildFormChapter6.hotspotForm)
      navigationViewController?.pushViewController(chapter6Driver!.formViewController, animated: true)
    case .chapter7:
      chapter7Driver = BuildFormChapter7.FormDriver(initial: Hotspot(), build: BuildFormChapter7.hotspotForm)
      navigationViewController?.pushViewController(chapter7Driver!.formViewController, animated: true)

    }
  }
}
