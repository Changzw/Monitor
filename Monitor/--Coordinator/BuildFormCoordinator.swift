//
//  BuildFormCoordinator.swift
//  Monitor
//
//  Created by Fri on 2022/3/29.
//

import Foundation
import XCoordinator

enum BuildingFormLibraryRoute: Route, CaseIterable {
  case content
  case chapter0
  case chapter1
  case chapter2
  case chapter3
  case chapter4
  case chapter5
  case chapter6
  case chapter7
  
  static var allContents: [BuildingFormLibraryRoute] {
    Array(BuildingFormLibraryRoute.allCases[1...])
  }
}

final class BuildFormCoordinator: NavigationCoordinator<BuildingFormLibraryRoute> {
  
  private var chapter2Driver: BuildFormChapter2.HotspotDriver?
  private var chapter3Driver: BuildFormChapter3.FormDriver?
  private var chapter4Driver: BuildFormChapter4.FormDriver<Hotspot>?
  private var chapter5Driver: BuildFormChapter5.FormDriver<Hotspot>?
  private var chapter6Driver: BuildFormChapter6.FormDriver<Hotspot>?
  private var chapter7Driver: BuildFormChapter7.FormDriver<Hotspot>?
  
  // MARK: Initialization
  init() {
    super.init(initialRoute: .content)
  }
  
  // MARK: Overrides
  override func prepareTransition(for route: BuildingFormLibraryRoute) -> NavigationTransition {
    switch route {
    case .content:
//      let vc = BuildingFormContentViewController(router: unownedRouter)
//      return .push(vc)
      
    case .chapter0:
      let vc = BuildFormChapter0.ViewController()
      return .push(vc)
    case .chapter1:
      let vc = BuildFormChapter1.ViewController()//(router: unownedRouter)
      return .push(vc)
      
    case .chapter2:
      chapter2Driver = BuildFormChapter2.HotspotDriver()
      return .push(chapter2Driver!.formViewController)
      
    case .chapter3:
      chapter3Driver = BuildFormChapter3.FormDriver(initial: Hotspot(), build: BuildFormChapter3.hotspotForm)
      return .push(chapter3Driver!.formViewController)
      
    case .chapter4:
      chapter4Driver = BuildFormChapter4.FormDriver(initial: Hotspot(), build: BuildFormChapter4.hotspotForm)
      return .push(chapter4Driver!.formViewController)
      
    case .chapter5:
      chapter5Driver = BuildFormChapter5.FormDriver(initial: Hotspot(), build: BuildFormChapter5.hotspotForm)
      return .push(chapter5Driver!.formViewController)
    case .chapter6:
      chapter6Driver = BuildFormChapter6.FormDriver(initial: Hotspot(), build: BuildFormChapter6.hotspotForm)
      return .push(chapter6Driver!.formViewController)
    case .chapter7:
      chapter7Driver = BuildFormChapter7.FormDriver(initial: Hotspot(), build: BuildFormChapter7.hotspotForm)
      return .push(chapter7Driver!.formViewController)
    default:
      return .none()
    }
  }
}
