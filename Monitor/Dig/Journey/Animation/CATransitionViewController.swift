//
//  TransitionViewController.swift
//  Monitor
//
//  Created by Fri on 2022/4/14.
//

import UIKit

class CATransitionViewController: UIViewController {
  var myLayer: CALayer?
  var photoView: UIImageView?
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    
    photoView = UIImageView.init(frame: CGRect(x: 50, y: 200, width: 250, height: 140))
    photoView?.image = UIImage.init(named: "car.jpg")
    photoView?.backgroundColor = .red
    self.view.addSubview(photoView!)
    
    myLayer = photoView?.layer
    
    let toplabel = UILabel.init(frame: CGRect(x: 25, y: 420, width: 360, height: 20))
    toplabel.text = "可安全使用的效果，其他的很多已经被淡入淡出替代而无效了"
    self.view.addSubview(toplabel)
    
    for i in 0..<13 {
      let btn = UIButton.init(type: .system)
      self.view.addSubview(btn)
      if i > 11 {
        btn.frame = CGRect(x: 25*(i-12) + 80*(i-12), y: 450+30*3, width: 100, height: 30)
      } else if i > 7 {
        btn.frame = CGRect(x: 25*(i-8) + 80*(i-8), y: 450+30*2, width: 100, height: 30)
      } else if i > 3 {
        btn.frame = CGRect(x: 25*(i-4) + 80*(i-4), y: 450+30, width: 100, height: 30)
      } else {
        btn.frame = CGRect(x: 25*i + 80*i, y: 450, width: 100, height: 30)
      }
      btn.addTarget(self, action: #selector(clickBtn(btn:)), for: .touchUpInside)
      btn.setTitle(["pusht推出","fade渐变","moveIn移进去","reveal显示","rippleEffect水波抖动","cube立方体翻转效果","suckEffect三角","pageCurl上翻页","pageUnCurl下翻页","oglFlip翻转","cameraIrisHollowOpen镜头快门开","cameraIrisHollowClose镜头快门关","rotate旋转"][i], for: .normal)
      btn.tag = 100+i
    }
    
    let pushBtn = UIButton(type: .system)
    pushBtn.frame = CGRect(x: 80, y: 570, width: 120, height: 20)
    pushBtn.setTitle("点击跳转VC", for: .normal)
    self.view.addSubview(pushBtn)
    pushBtn.tag = 200
    pushBtn.addTarget(self, action: #selector(clickBtn(btn:)), for: .touchUpInside)
    
  }
  
  @objc func clickBtn(btn: UIButton) {
    switch btn.tag {
    case 100,101,102,103,104,105,106,107,108,109,110,111,112:
      let transitionAnimation = CATransition()
      transitionAnimation.type = [CATransitionType.push, CATransitionType.fade, CATransitionType.moveIn, CATransitionType.reveal, .init(rawValue: "rippleEffect"),.init(rawValue: "cube"),.init(rawValue: "suckEffect"),.init(rawValue: "pageCurl"),.init(rawValue: "pageUnCurl"),.init(rawValue: "oglFlip"),.init(rawValue: "cameraIrisHollowOpen"),.init(rawValue: "cameraIrisHollowClose"), .init(rawValue: "rotate")][btn.tag - 100]
      transitionAnimation.subtype = .fromTop
      //            transitionAnimation.subtype = .init(rawValue: "180ccw")//90cw,90ccw,180cw,180ccw:  逆时针/顺时针 -- 90度/180度
      transitionAnimation.duration = 1.5
      //            transitionAnimation.repeatCount = 3
      //            transitionAnimation.autoreverses = true
      //            transitionAnimation.fillMode = .forwards
      //            transitionAnimation.isRemovedOnCompletion = false
      myLayer?.add(transitionAnimation, forKey: "transition")
      //            photoView?.backgroundColor = photoView?.backgroundColor == .red ? .yellow : .red
      photoView?.image = photoView?.image == UIImage.init(named: "car.jpg") ? UIImage.init(named: "town.jpg") : UIImage.init(named: "car.jpg")
    case 200:
      let transitionAnimation = CATransition()
      transitionAnimation.type = .init(rawValue: "oglFlip")
      transitionAnimation.duration = 0.5
      transitionAnimation.subtype = .fromRight
      self.navigationController?.view.layer.add(transitionAnimation, forKey: "navigationVC")
      self.navigationController?.pushViewController(NextViewController(), animated: false)
    default:
      break
    }
  }
}

//NextViewController
class NextViewController: UIViewController, CAAnimationDelegate {
  var button: UIButton?
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    let label = UILabel()
    label.frame = CGRect(x: 0, y: 120, width: UIScreen.main.bounds.size.width, height: 20)
    label.textAlignment = .center
    label.text = "这是跳转的 nextVC 界面"
    self.view.addSubview(label)
    
    button = UIButton(type: .system)
    self.view.addSubview(button!)
    button?.setTitle("pop返回", for: .normal)
    button?.frame = CGRect(x: 100, y: 200, width: 120, height: 30)
    button?.addTarget(self, action: #selector(clickTap(btn:)), for: .touchUpInside)
  }
  
  @objc func clickTap(btn: UIButton) {
    let transtionAnimation = CATransition()
    transtionAnimation.duration = 1.2
    transtionAnimation.type = .init(rawValue: "oglFlip")
    transtionAnimation.delegate = self
    //        transtionAnimation.type = .fade
    transtionAnimation.subtype = .fromLeft
    //        self.navigationController?.view.layer.add(transtionAnimation, forKey: "navigationVC")
    //        self.navigationController?.popViewController(animated: false)
    button?.layer.add(transtionAnimation, forKey: "button")
    button?.setTitle("动画变化后的文字", for: .normal)
  }
  
  //CAAnimationDelegate
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    print("finish")
  }
  
}
