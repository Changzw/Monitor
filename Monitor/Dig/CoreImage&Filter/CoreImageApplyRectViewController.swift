//
//  CoreImageApplyRectViewController.swift
//  Monitor
//
//  Created by Fri on 2022/4/22.
//

import UIKit

class CoreImageApplyRectViewController: UIViewController {
  
  let iconView = UIImageView()
  let iconFilterView = UIImageView()
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    let content = VStack {
      iconView
      iconFilterView
    }
      .spacing(10)
      .distribution(.fillEqually)
      .alignment(.fill)
    
    view.addSubview(content)
    content.snp.makeConstraints{
      $0.width.equalTo(350)
      $0.height.equalTo(600)
      $0.center.equalToSuperview()
    }
    guard let img = UIImage(named: "flower"),
          let cgImage = CIImage(image: img) else { return }
    iconView.image = img
    
    var f = cgImage.extent
    f.origin.y = f.midY
    iconFilterView.image = img.applyBlurInRect(rect: CGRect(x: 10, y: 10, width: 100, height: 100), withRadius: 10)
  }
}

extension UIImage {
  func getImageFrom(rect: CGRect) -> UIImage? {
    if let cg = self.cgImage,
       let mySubimage = cg.cropping(to: rect) {
      return UIImage(cgImage: mySubimage)
    }
    return nil
  }
  
  func blurImage(withRadius radius: Double) -> UIImage? {
    let inputImage = CIImage(cgImage: cgImage!)
    if let filter = CIFilter(name: "CIGaussianBlur") {
      filter.setValue(inputImage, forKey: kCIInputImageKey)
      filter.setValue((radius), forKey: kCIInputRadiusKey)
      if let blurred = filter.outputImage {
        return UIImage(ciImage: blurred)
      }
    }
    return nil
  }
  
  func drawImageInRect(_ inputImage: UIImage, inRect imageRect: CGRect) -> UIImage {
    UIGraphicsBeginImageContext(self.size)
    draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    inputImage.draw(in: imageRect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
  }
  
  func applyBlurInRect(rect: CGRect, withRadius radius: Double) -> UIImage? {
    if let subImage = self.getImageFrom(rect: rect),
       let blurredZone = subImage.blurImage(withRadius: radius) {
      return self.drawImageInRect(blurredZone, inRect: rect)
    }
    return nil
  }
}
