//
//  JournalPageViewController.swift
//  Monitor
//
//  Created by Fri on 2022/4/14.
//

import UIKit
fileprivate final class ItemViewController: UIViewController {
  let t = UILabel().then {
    $0.textColor = .black
  }
  
  var index: Int = 0 {
    didSet {
      t.text = "\(index)"
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .random
    view.addSubview(t)
    t.snp.makeConstraints{
      $0.center.equalToSuperview()
    }
  }
}

final class JournalPageViewController: UIViewController {
  private let pageViewController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: [:])
  var currentIndex: Int = 0
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    pageViewController.delegate = self
    pageViewController.dataSource = self
    addChild(pageViewController)
    view.addSubview(pageViewController.view)
    pageViewController.view.snp.makeConstraints{
      $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 150, left: 50, bottom: 150, right: 50))
    }
    
    let vc = ItemViewController()
    vc.index = currentIndex
    pageViewController.setViewControllers([vc], direction: .forward, animated: true) { complete in
      
    }
    pageViewController.view.transform = CGAffineTransform(rotationAngle: CGFloat.pi/30)
  }
}

extension JournalPageViewController: UIPageViewControllerDelegate&UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    let vc = ItemViewController()
    if currentIndex == 0 {
      return nil
    }
    currentIndex -= 1
    vc.index = currentIndex
    return vc
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    let vc = ItemViewController()
    currentIndex += 1
    vc.index = currentIndex
    return vc
  }
}
