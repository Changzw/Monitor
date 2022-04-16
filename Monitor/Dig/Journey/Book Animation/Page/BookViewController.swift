//
//  JournalCollectionViewController.swift
//  Monitor
//
//  Created by Fri on 2022/4/14.
//

import UIKit

class BookViewController: UIViewController {
  var book: Book? {
    didSet {
      collectionView.reloadData()
    }
  }
  lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: BookLayout()).then {
    $0.register(BookPageCell.self, forCellWithReuseIdentifier: BookPageCell.description())
    $0.delegate = self
    $0.dataSource = self
    $0.clipsToBounds = false
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .random
    view.backgroundColor = .white
    view.addSubview(collectionView)
    collectionView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
    collectionView.snp.makeConstraints{
      $0.center.equalToSuperview()
      $0.width.equalToSuperview()//(BookLayout.PageWidth*2 + 20)
      $0.height.equalTo(BookLayout.PageHeight + 40)
    }
  }
}

extension BookViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let book = book {
      return book.numberOfPages() + 1
    }
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookPageCell.description(), for: indexPath) as! BookPageCell
    
    if indexPath.row == 0 {
      // Cover page
      cell.textLabel.text = nil
      cell.image = book?.coverImage()
    } else {
      // Page with index: indexPath.row - 1
      cell.textLabel.text = "\(indexPath.row)"
      cell.image = book?.pageImage(index: indexPath.row - 1)
    }
    
    return cell
  }
}
