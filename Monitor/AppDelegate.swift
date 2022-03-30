//
//  AppDelegate.swift
//  Monitor
//
//  Created by Fri on 2022/3/29.
//

import UIKit
//import XCoordinator

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  private lazy var mainWindow = UIWindow()
//  private let router = BuildFormCoordinator().strongRouter
  private let mainFlow = MainContentFlow(rootViewController: UINavigationController())
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    mainWindow.frame = UIScreen.main.bounds
//    router.setRoot(for: mainWindow)
    mainWindow.rootViewController = mainFlow.rootViewController
    mainWindow.makeKeyAndVisible()
    mainFlow.direct(to: .content)
    return true
  }
}

