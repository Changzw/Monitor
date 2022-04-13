//
//  CGContext+extensions.swift
//  Monitor
//
//  Created by Fri on 2022/4/13.
//

import UIKit

extension CGContext {
  func drawInStore(_ block: ()->()) {
    saveGState()
    block()
    restoreGState()
  }
}
