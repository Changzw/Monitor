//
//  JournalCollectionViewController.swift
//  Monitor
//
//  Created by Fri on 2022/4/14.
//

import UIKit

class BookCoverCell: UICollectionViewCell {
  
  let imageView = UIImageView()
  
  var book: Book? {
    didSet {
      image = book?.coverImage()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(imageView)
    imageView.snp.makeConstraints{
      $0.edges.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var image: UIImage? {
    didSet {
      let corners: UIRectCorner = [.topRight , .bottomRight]
      imageView.image = image!.imageByScalingAndCroppingForSize(targetSize: bounds.size).imageWithRoundedCornersSize(cornerRadius: 20, corners: corners)
    }
  }
}
