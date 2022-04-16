//
//  JournalCollectionViewController.swift
//  Monitor
//
//  Created by Fri on 2022/4/14.
//

import UIKit
//https://www.raywenderlich.com/1719-how-to-create-an-ios-book-open-animation-part-1

final class BookLayout: UICollectionViewFlowLayout {
  static let PageWidth: CGFloat = 362 * 0.5
  static let PageHeight: CGFloat = 568 * 0.5

	var numberOfItems = 0
 
  override func prepare() {
    super.prepare()
    guard let cv = collectionView else { return }
    cv.decelerationRate = .fast
//    cv.contentInset = UIEdgeInsets(
//      top: 0,
//      left: cv.bounds.width / 2 - Self.PageWidth / 2,
//      bottom: 0,
//      right: cv.bounds.width / 2 - Self.PageWidth / 2
//    )
    numberOfItems = cv.numberOfItems(inSection: 0)
    cv.isPagingEnabled = true
	}
	
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    true
	}
	
  override var collectionViewContentSize: CGSize {
    guard let cv = collectionView else { return .zero }
		return CGSize(width: (CGFloat(numberOfItems / 2)) * cv.bounds.width,
                  height: Self.PageHeight/*cv.bounds.height*/)
	}
	
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    (0...max(0, numberOfItems - 1)).compactMap {
      layoutAttributesForItem(at: IndexPath(item: $0, section: 0))
    }
	}
	
	//MARK: attribute logic helpers
	func getRatio(collectionView: UICollectionView, indexPath: IndexPath) -> CGFloat {
		//this ensures that pages next to each other are sticked together.
    // to form a double sided page.
		let page = CGFloat(indexPath.item - indexPath.item % 2) * 0.5
		var ratio: CGFloat = -0.5 + page - (collectionView.contentOffset.x / collectionView.bounds.width)
		if ratio > 0.5 {
			ratio = 0.5 + 0.1 * (ratio - 0.5)
    } else if ratio < -0.5 {
			ratio = -0.5 + 0.1 * (ratio + 0.5)
		}
		return ratio
	}

	func getAngle(indexPath: IndexPath, ratio: CGFloat) -> CGFloat {
		// Set rotation
		var angle: CGFloat = 0
		//1
		if indexPath.item % 2 == 0 {
			//2
			// The book's spine is on the left of the page
			angle = (1-ratio) * (-.pi/2)
		} else if indexPath.item % 2 == 1 {
			//4
			// The book's spine is on the right of the page
			angle = (1 + ratio) * (.pi/2)
		}
		//5
		// Make sure the odd and even page don't have the exact same angle
		angle += CGFloat(indexPath.row % 2) / 1000
		//6
		return angle
	}
	
	func makePerspectiveTransform() -> CATransform3D {
		var transform = CATransform3DIdentity;
		transform.m34 = 1.0 / -2000;
		return transform;
	}
	
	func getRotation(indexPath: IndexPath, ratio: CGFloat) -> CATransform3D {
		//1
		var transform = CATransform3DIdentity// makePerspectiveTransform()
		//2
    let angle = getAngle(indexPath: indexPath, ratio: ratio)
		//3
		transform = CATransform3DRotate(transform, angle, 0, 1, 0)
		
		return transform
	}
	
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    guard let cv = collectionView else { return nil }
    let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
		
		// Set initial frame - align the page's edge to the spine
//    let frame = getFrame(collectionView: collectionView!)
    var f = cv.frame
    
    f.origin.x = (cv.bounds.width / 2) - (Self.PageWidth / 2) + cv.contentOffset.x
    f.origin.y = (collectionViewContentSize.height - Self.PageHeight) / 2
    f.size.width = Self.PageWidth
    f.size.height = Self.PageHeight
    
		layoutAttributes.frame = f
		
    let ratio = getRatio(collectionView: collectionView!, indexPath: indexPath)
		
		// Back-face culling - display only front-face pages.
		if ratio > 0 && indexPath.item % 2 == 1
			|| ratio < 0 && indexPath.item % 2 == 0 {
				// Make sure the cover is always visible
				if indexPath.row != 0 {
					return nil
				}
		}
		
		// Apply rotation transform
    let rotation = getRotation(indexPath: indexPath, ratio: min(max(ratio, -1), 1))
		layoutAttributes.transform3D = rotation
		
		// Make sure the cover is always above page 1 to avoid flickering when closing the book
		if indexPath.row == 0 {
			layoutAttributes.zIndex = Int.max
		}
		return layoutAttributes
	}
}
