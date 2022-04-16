//
//  JournalCollectionViewController.swift
//  Monitor
//
//  Created by Fri on 2022/4/14.
//
//https://www.raywenderlich.com/1719-how-to-create-an-ios-book-open-animation-part-1
import UIKit

private let PageWidth: CGFloat = 362
private let PageHeight: CGFloat = 568

final class BooksLayout: UICollectionViewFlowLayout {
  override init() {
    super.init()
    scrollDirection = .horizontal
    itemSize = CGSize(width: PageWidth, height: PageHeight)
    minimumInteritemSpacing = 10
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
	override func prepare() {
		super.prepare()
		
		//The rate at which we scroll the collection view.
		//1. Sets how fast the collection view will stop scrolling after a user lifts their finger. By setting it to UIScrollViewDecelerationRateFast the scroll view will decelerate much faster. Try playing around with Normal vs Fast to see the difference!
    collectionView?.decelerationRate = UIScrollView.DecelerationRate.fast
		
		//2. Sets the content inset of the collection view so that the first book cover will always be centered.
		collectionView?.contentInset = UIEdgeInsets(
			top: 0,
			left: collectionView!.bounds.width / 2 - PageWidth / 2,
			bottom: 0,
			right: collectionView!.bounds.width / 2 - PageWidth / 2
		)
	}
	
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		//1
    guard let cv = collectionView, let array = super.layoutAttributesForElements(in: rect) else {return[]}
		
		//2
		for attributes in array {
			//3
      let frame = attributes.frame
			//4. Calculate the distance between the book cover — that is, the cell — and the center of the screen.
			let distance = abs(cv.contentOffset.x + cv.contentInset.left - frame.origin.x)
			//5
			let scale = 0.7 * min(max(1 - distance / (cv.bounds.width), 0.75), 1)
			//6
      attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
		}
		
		return array
	}
	
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		true
	}
	
  override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    guard let cv = collectionView else { return .zero }
		// Snap cells to centre
		//1
		var newOffset = CGPoint()
		//2
//    let layout = self// collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
		//3
    let width = itemSize.width + minimumLineSpacing
		//4
		var offset = proposedContentOffset.x + cv.contentInset.left
		
		//5
		if velocity.x > 0 {
			//ceil returns next biggest number
			offset = width * ceil(offset / width)
		} else
		//6
		if velocity.x == 0 {
			//rounds the argument
			offset = width * round(offset / width)
		} else
		//7
		if velocity.x < 0 {
			//removes decimal part of argument
			offset = width * floor(offset / width)
		}
		//8
		newOffset.x = offset - cv.contentInset.left
		newOffset.y = proposedContentOffset.y //y will always be the same...
		return newOffset
	}
}
