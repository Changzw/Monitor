//
//  BorderGradientButtonViewController.swift
//  Monitor
//
//  Created by Fri on 2022/4/13.
//

import UIKit

final class BorderGradientButtonViewController: UIViewController {
  let button = CPRelationButton()
  let buttonBezier = PathGradientButton()
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
    view.backgroundColor = .white
    button.setTitle("jjjjj", for: .normal)
    button.setTitleColor(.random, for: .normal)
    buttonBezier.setTitle("kkkkk", for: .normal)
    buttonBezier.setTitleColor(.random, for: .normal)
    view.backgroundColor = .white
    view.addSubview(button)
    view.addSubview(buttonBezier)
    button.snp.makeConstraints{
      $0.width.equalTo(200)
      $0.height.equalTo(100)
      $0.centerX.equalToSuperview()
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
    }
    buttonBezier.snp.makeConstraints{
      $0.width.equalTo(200)
      $0.height.equalTo(100)
      $0.centerX.equalToSuperview()
      $0.top.equalTo(button.snp.bottom).offset(20)
    }
    
    let content = VStack {
      labelHue
      sliderHue
      labelSat
      sliderSat
      labelBri
      sliderBri
    }
    .spacing(30)
    .alignment(.fill)
    .insetAll(20)
    
    view.addSubview(content)
    content.snp.makeConstraints{
      $0.top.equalTo(buttonBezier.snp.bottom).offset(20)
      $0.left.right.equalToSuperview()
    }
    
//    sliderHue.rx.value
//      .bind{ [unowned self] in
////        self.button.hue = CGFloat($0)
//      }
//      .disposed(by: rx.disposeBag)
//    sliderSat.rx.value
//      .bind{ [unowned self] in
////        self.button.saturation = CGFloat($0)
//      }
//      .disposed(by: rx.disposeBag)
//    sliderBri.rx.value
//      .bind{ [unowned self] in
//        self.button.brightness = CGFloat($0)
//      }
//      .disposed(by: rx.disposeBag)
  }
  
}
