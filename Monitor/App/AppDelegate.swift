//
//  AppDelegate.swift
//  Monitor
//
//  Created by Fri on 2022/3/29.
//

import UIKit
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  private lazy var mainWindow = UIWindow()
  private let mainFlow = MainContentFlow(rootViewController: UINavigationController())
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    mainWindow.frame = UIScreen.main.bounds
    mainWindow.rootViewController = mainFlow.rootViewController
    mainWindow.makeKeyAndVisible()
    mainFlow.direct(to: .content)
    
    Observable<Int>.just(10)
      .bind(to: { o in
        return { x in
          return 10
        }
      }, curriedArgument: 100)
    
//    FFF()
//      .bind(to: itembbb(cellIdentifier: "jjj", cellType: 100), curriedArgument:<#(Int, String, String) -> Void#>)
    
    return true
  }
}

