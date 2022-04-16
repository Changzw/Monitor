//
//  JournalCollectionViewController.swift
//  Monitor
//
//  Created by Fri on 2022/4/14.
//


import UIKit

class BookPageCell: UICollectionViewCell {
	
  let textLabel = UILabel().then{
    $0.textColor = .white
  }
	let imageView = UIImageView()
	
	var book: Book?
	var isRightPage: Bool = false
	var shadowLayer: CAGradientLayer = CAGradientLayer()
	
	override var bounds: CGRect {
		didSet {
			shadowLayer.frame = bounds
		}
	}
	
	var image: UIImage? {
		didSet {
			let corners: UIRectCorner = isRightPage ? [.topRight, .bottomRight] : [.topLeft, .bottomLeft]
      imageView.image = image!.imageByScalingAndCroppingForSize(targetSize: bounds.size).imageWithRoundedCornersSize(cornerRadius: 20, corners: corners)
		}
	}
	
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(imageView)
    contentView.addSubview(textLabel)
    contentView.clipsToBounds = false
    clipsToBounds = false
    imageView.snp.makeConstraints{
      $0.edges.equalToSuperview()
    }
    textLabel.snp.makeConstraints{
      $0.centerX.bottom.equalToSuperview()
      $0.height.equalTo(60)
    }
    setupAntialiasing()
    initShadowLayer()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
	func setupAntialiasing() {
		layer.allowsEdgeAntialiasing = true
		imageView.layer.allowsEdgeAntialiasing = true
	}
	
	func initShadowLayer() {
		let shadowLayer = CAGradientLayer()
		
		shadowLayer.frame = bounds
    shadowLayer.startPoint = CGPoint(x: 0, y: 0.5)
    shadowLayer.endPoint = CGPoint(x: 1, y: 0.5)
		
		self.imageView.layer.addSublayer(shadowLayer)
		self.shadowLayer = shadowLayer
	}
	
	func getRatioFromTransform() -> CGFloat {
		var ratio: CGFloat = 0
		
    guard let rotationY = layer.value(forKey: "transform.rotation.y") as? CGFloat else {return ratio}
		if !isRightPage {
      let progress = -(1 - rotationY / (.pi/2))
			ratio = progress
		}
			
		else {
			let progress = 1 - rotationY / (-.pi/2)
			ratio = progress
		}
		
		return ratio
	}
	
	func updateShadowLayer(animated: Bool = false) {
    let ratio: CGFloat = 0
		
		// Get ratio from transform. Check BookCollectionViewLayout for more details
    let inverseRatio = 1 - abs(getRatioFromTransform())
		
		if !animated {
			CATransaction.begin()
			CATransaction.setDisableActions(!animated)
		}
		
		if isRightPage {
			// Right page
      shadowLayer.colors = [
        UIColor.darkGray.withAlphaComponent(inverseRatio * 0.45),
        UIColor.darkGray.withAlphaComponent(inverseRatio * 0.40),
        UIColor.darkGray.withAlphaComponent(inverseRatio * 0.55),
      ].map(\.cgColor)
   
      shadowLayer.locations = [0, 0.02, 1.0]
		} else {
			// Left page
      shadowLayer.colors = [
        UIColor.darkGray.withAlphaComponent(inverseRatio * 0.45),
        UIColor.darkGray.withAlphaComponent(inverseRatio * 0.40),
        UIColor.darkGray.withAlphaComponent(inverseRatio * 0.55),
      ].map(\.cgColor)
      shadowLayer.locations = [0, 0.5, 0.98, 1.0]
		}
		
		if !animated {
			CATransaction.commit()
		}
	}
	
  override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    super.apply(layoutAttributes)
    if layoutAttributes.indexPath.item % 2 == 0 {
      // The book's spine is on the left of the page
      layer.anchorPoint = CGPoint(x: 0, y: 0.5)
      isRightPage = true
    } else {
      // The book's spine is on the right of the page
      layer.anchorPoint = CGPoint(x: 1, y: 0.5)
      isRightPage = false
    }
    
    self.updateShadowLayer()
  }
}
