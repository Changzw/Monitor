//
//  AppTweaks.swift
//  Monitor
//
//  Created by Fri on 2022/4/14.
//

import Foundation
import SwiftTweaks
import WebKit
#if canImport(FLEX)
import FLEX
#endif

struct AppTweaks: TweakLibraryType {
  private static let globalCollection = "全局"
  private static let networkGroup = "网络"
  private static let ui = "UI"
  
  private static let debugCollection = "Debug"
  private static let debugToolsGroup = "Tools"
  private static let debugLookin = "Lookin"
  private static let debugClearUserDefaultGroup = "清除客户端配置本地缓存"
  
  static let debugSandboxUploaderStart = Tweak<Bool>(debugCollection, debugToolsGroup, "Sanbox Uploader", false)

  private static var debugShowFLEX: Tweak<TweakAction> = {
    let action = Tweak<TweakAction>(debugCollection, debugToolsGroup, "FLEX Explorer")
    action.addClosure {
      #if canImport(FLEX)
      FLEXManager.shared.showExplorer()
      #endif
    }
    return action
  }()
  private static var lookin: Tweak<TweakAction> = {
      let action = Tweak<TweakAction>(debugCollection, debugLookin, "Lookin视图选项")
      action.addClosure {
//          UIViewController.topMost?.dismiss(animated: true, completion: {
              let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
              sheet.addAction(.init(title: "导出当前UI结构", style: .default, handler: { _ in
                  NotificationCenter.default.post(name: .init("Lookin_Export"), object: nil)
              }))
              sheet.addAction(.init(title: "审查元素", style: .default, handler: { _ in
                  NotificationCenter.default.post(name: .init("Lookin_2D"), object: nil)
              }))
              sheet.addAction(.init(title: "3D视图", style: .default, handler: { _ in
                  NotificationCenter.default.post(name: .init("Lookin_3D"), object: nil)
              }))
              sheet.addAction(.init(title: "取消", style: .cancel, handler: nil))
//              UIViewController.topMost?.present(sheet, animated: true, completion: nil)
//          })
      }
      return action
  }()
  private static var clearWebViewCache: Tweak<TweakAction> = {
      let action = Tweak<TweakAction>(debugCollection, debugClearUserDefaultGroup, "清除webView缓存")
      action.addClosure {
          WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: Date.init(timeIntervalSince1970: 0)) {
              
          }
      }
      return action
  }()

  static var defaultStore: TweakStore = {
    return TweakStore(tweaks: [
      debugShowFLEX,
      debugSandboxUploaderStart,
      lookin,
    ], enabled: true)
  } ()
  
}

extension Tweak {
  var value: T {
    AppTweaks.assign(self)
  }

  func bind<Object>(to obj: Object, binding: @escaping (_ value: T) -> Void) -> Void where Object: NSObject {
    let id = AppTweaks.bind(self) { (t) in
      binding(t)
    }
    obj.deallocBox.blocks.append {
      AppTweaks.unbind(identifier: id)
    }
  }
}

extension Array where Element: TweakType {
  func bind<Object>(to obj: Object, binding: @escaping (_ tweaks: [Element]) -> Void) -> Void where Object: NSObject {
    let id = AppTweaks.bindMultiple(self) {
      binding(self)
    }

    obj.deallocBox.blocks.append {
      AppTweaks.unbindMultiple(identifier: id)
    }
  }
}

private final class _NSObjectDeallocBox {
  var blocks: [() -> ()] = []
  deinit {
    blocks.forEach {
      $0()
    }
  }
}

private var deallocBoxKey: Int8 = 0
extension NSObject {
  fileprivate var deallocBox: _NSObjectDeallocBox {
    if let box = objc_getAssociatedObject(self, &deallocBoxKey) as? _NSObjectDeallocBox {
      return box
    } else {
      let box = _NSObjectDeallocBox()
      objc_setAssociatedObject(self, &deallocBoxKey, box, .OBJC_ASSOCIATION_RETAIN)
      return box
    }
  }
}

/* 用法
 let vc = ZPAppTweaks.changeEnvViewController()
 self.present(vc, animated: true, completion: nil)
 */
//public class ZPAppTweaks: NSObject, TweaksViewControllerDelegate {
//
//    private static var shared: ZPAppTweaks?
//
//    /// 改变环境的UIViewController
//    public static func changeEnvViewController() -> UIViewController {
//        var delegate: TweaksViewControllerDelegate
//        if let shared = shared {
//            delegate = shared
//        } else {
//            let objc = ZPAppTweaks()
//            delegate = objc
//            ZPAppTweaks.shared = objc
//        }
//        return TweaksViewController(tweakStore: AppTweaks.defaultStore, delegate: delegate)
//    }
//
//    public func tweaksViewControllerRequestsDismiss(_ tweaksViewController: TweaksViewController, completion: (() -> ())?) {
//        tweaksViewController.dismiss(animated: true, completion: nil)
//    }
//}
