//
//  GlossyButtonViewController.swift
//  testdemo
//
//  Created by 常仲伟 on 2022/2/24.
//  Copyright © 2022 常仲伟. All rights reserved.
//

import UIKit
import RxSwift
import Then
import SnapKit
import RxCocoa
import NSObject_Rx


func drawLinearGradient(context: CGContext, rect: CGRect, startColor: CGColor, endColor: CGColor) {
  // 1
  let colorSpace = CGColorSpaceCreateDeviceRGB()
  
  // 2
  let colorLocations: [CGFloat] = [0.0, 1.0]
  
  // 3
  let colors: CFArray = [startColor, endColor] as CFArray
  
  // 4
  let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: colorLocations)!
  
  // 5
  let startPoint = CGPoint(x: rect.midX, y: rect.minY)
  let endPoint = CGPoint(x: rect.midX, y: rect.maxY)
  
  context.saveGState()
  // 6
  context.addRect(rect)
  // 7
  context.clip()
  // 8
  context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
  context.restoreGState()

  // More to come...
}

func drawGlossAndGradient(context: CGContext, rect: CGRect, startColor: CGColor, endColor: CGColor) {
  // 1
  drawLinearGradient(context: context, rect: rect, startColor: startColor, endColor: endColor)
  let glossColor1 = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.35)
  let glossColor2 = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1)
  let topHalf = CGRect(origin: rect.origin, size: CGSize(width: rect.width, height: rect.height/2))
  
  drawLinearGradient(context: context,
                     rect: topHalf,
                     startColor: glossColor1.cgColor,
                     endColor: glossColor2.cgColor)
}


final class GlossyButtonViewController: UIViewController {
  
  let button = CoolButton(type: .custom)
  let labelHue = UILabel().then {
    $0.text = "Hue"
  }
  let labelSat = UILabel().then {
    $0.text = "Sat"
  }
  let labelBri = UILabel().then {
    $0.text = "Bri"
  }
  let sliderHue = UISlider()
  let sliderSat = UISlider()
  let sliderBri = UISlider()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    button.setTitle("jjjjj", for: .normal)
    view.backgroundColor = .white
    view.addSubview(button)
    button.snp.makeConstraints{
      $0.width.equalTo(200)
      $0.height.equalTo(100)
      $0.centerX.equalToSuperview()
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
    }
    
    let content = VStack {
      labelHue
      sliderHue
      labelSat
      sliderSat
      labelBri
      sliderBri
    }
    .spacing(40)
    .alignment(.fill)
    .insetAll(20)
    
    view.addSubview(content)
    content.snp.makeConstraints{
      $0.top.equalTo(button.snp.bottom).offset(20)
      $0.left.right.equalToSuperview()
    }
    
    sliderHue.rx.value
      .bind{ [unowned self] in
        self.button.hue = CGFloat($0)
      }
      .disposed(by: rx.disposeBag)
    sliderSat.rx.value
      .bind{ [unowned self] in
        self.button.saturation = CGFloat($0)
      }
      .disposed(by: rx.disposeBag)
    sliderBri.rx.value
      .bind{ [unowned self] in
        self.button.brightness = CGFloat($0)
      }
      .disposed(by: rx.disposeBag)
  }
}
