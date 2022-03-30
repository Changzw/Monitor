//
//  AppCoordinator.swift
//  Monitor
//
//  Created by Fri on 2022/3/29.
//

import Foundation
import XCoordinator

enum AppRoute: Route, CaseIterable {
  case content
  case declarative
  
  static var allContents: [BuildingFormLibraryRoute] {
    Array(BuildingFormLibraryRoute.allCases[1...])
  }
}

