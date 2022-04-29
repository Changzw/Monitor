//
//  CustomPresentable.swift
//  Monitor
//
//  Created by Fri on 2022/4/30.
//

import UIKit

protocol CustomPresentable: UIViewController {
  var transitionManager: UIViewControllerTransitioningDelegate? { get set }
  
}
