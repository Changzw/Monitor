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
    $0.text = "bordersGap"
  }
  let labelSat = UILabel().then {
    $0.text = "outterBorderWidth"
  }
  let labelBri = UILabel().then {
    $0.text = "innerBorderWidth"
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
      $0.height.equalTo(80)
      $0.centerX.equalToSuperview()
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
    }
    buttonBezier.snp.makeConstraints{
      $0.width.equalTo(200)
      $0.height.equalTo(80)
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
    .spacing(14)
    .alignment(.fill)
    .insetAll(20)
    
    view.addSubview(content)
    content.snp.makeConstraints{
      $0.top.equalTo(buttonBezier.snp.bottom).offset(20)
      $0.left.right.equalToSuperview()
    }
    
    sliderHue.rx.value
      .map{ $0 * 10 }// 0~5
      .bind{ [unowned self] in
        self.button.style.bordersGap = CGFloat($0)
      }
      .disposed(by: rx.disposeBag)

    sliderSat.rx.value
      .map{ $0 * 10 }// 0~5
      .bind{ [unowned self] in
        self.button.style.outterBorderWidth = CGFloat($0)
      }
      .disposed(by: rx.disposeBag)
    
    sliderBri.rx.value
      .map{ $0 * 10 }// 0~5
      .bind{ [unowned self] in
        self.button.style.innerBorderWidth = CGFloat($0)
      }
      .disposed(by: rx.disposeBag)
  }
  
}
