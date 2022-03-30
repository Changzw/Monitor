//
//  Flow.swift
//  Monitor
//
//  Created by Fri on 2022/3/30.
//

import Foundation
import UIKit

protocol Branch {}
protocol Flow {
  associatedtype BranchType: Branch
  
  var rootViewController: UIViewController? { get }
  init(rootViewController: UIViewController) 
  func direct(to branch: BranchType)
}

