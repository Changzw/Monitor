//
//  WaveViewController.swift
//  Monitor
//
//  Created by Fri on 2022/4/17.
//

import UIKit

final class WaveViewController: UIViewController {
  
  private lazy var waveView = WaveView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(waveView)
    
    waveView.snp.makeConstraints{
      $0.center.equalToSuperview()
      $0.width.equalTo(300)
      $0.height.equalTo(200)
    }
  }
}

fileprivate final class WaveView: UIView {
  var waterColor: UIColor = .random
  var waterLineY: CGFloat = 20.0
  var waveAmplitude: CGFloat = 3.0
  var waveCycle: CGFloat = 1.0
  var isIncrease: Bool = true
  
  private var displayLink: CADisplayLink?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    displayLink = CADisplayLink(target: self, selector: #selector(updateWave))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc
  private func updateWave() {
    if isIncrease {
      waveAmplitude += 0.03
    } else {
      waveAmplitude -= 0.03
    }
    
    if waveAmplitude <= 1 {
      isIncrease = true
    }
    
    if waveAmplitude >= 1.5 {
      isIncrease = false
    }
    waveCycle += 0.02
    setNeedsDisplay()
  }
  
  override func draw(_ rect: CGRect) {
    guard let ctx = UIGraphicsGetCurrentContext() else { return }
    ctx.drawInStore {
//      let frontPath = CGPath()
//      let backPath = CGPath()
      
    }
  }
}
