//
//  Toast.swift
//  Monitor
//
//  Created by Fri on 2022/4/14.
//

import Foundation
import Toast_Swift

extension ToastStyle {
  
  /// 默认toast样式
  static var `default`: ToastStyle {
    var t = ToastStyle()
    t.cornerRadius = 10
    t.messageFont = .systemFont(ofSize: 15)
    t.messageAlignment = .center
    t.verticalPadding = 12
    t.horizontalPadding = 16
    t.maxWidthPercentage = 260.0 / UIScreen.main.bounds.width
    t.backgroundColor = .black.withAlphaComponent(0.3)
    t.fadeDuration = 0.12
    return t
  }
}

