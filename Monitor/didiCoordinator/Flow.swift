//
//  Flow.swift
//  Monitor
//
//  Created by Fri on 2022/3/30.
//

import Foundation
import UIKit

protocol Branch {
  associatedtype T: Branch
  static var allContents: [T] { get }
}

protocol Flow {
  associatedtype BranchType: Branch
  
  var rootViewController: UIViewController? { get }
  init(rootViewController: UIViewController) 
  func direct(to branch: BranchType)
}

//class AnyFlow {
//
//  let rootViewController: UIViewController?
//
//  init<F: Flow>(inner: F) {
//    rootViewController = inner.rootViewController
//
//  }
//
//  func direct(to branch: Branch) {
//
//  }
//
//}
