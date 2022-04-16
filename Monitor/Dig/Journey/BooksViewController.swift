//
//  JournalCollectionViewController.swift
//  Monitor
//
//  Created by Fri on 2022/4/14.
//
//https://www.raywenderlich.com/1719-how-to-create-an-ios-book-open-animation-part-1
import UIKit

final class BooksViewController: UICollectionViewController {
  var transition: BookOpeningTransition?
  
  var books: Array<Book>? {
    didSet {
      collectionView?.reloadData()
    }
  }
  
  let backBtn = UIButton()
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBack()
    collectionView.register(BookCoverCell.self, forCellWithReuseIdentifier: BookCoverCell.description())
    view.backgroundColor = .white
    books = BookStore.sharedInstance.loadBooks(plist: "Books")
  }
  
  private func setupBack() {
    backBtn.setTitleColor(.blue, for: .normal)
    backBtn.setTitle("back", for: .normal)
    backBtn.rx.tap
      .bind{[unowned self] in
        self.presentingViewController?.dismiss(animated: true, completion: nil)
      }
      .disposed(by: rx.disposeBag)
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
  }
  
  // MARK: Helpers
  func selectedCell() -> BookCoverCell? {
    if let indexPath = collectionView.indexPathForItem(at: CGPoint(x: collectionView.contentOffset.x + collectionView.bounds.width / 2, y: collectionView.bounds.height / 2)) {
      if let cell = collectionView.cellForItem(at: indexPath) as? BookCoverCell {
        return cell
      }
    }
    return nil
  }
  //
  func openBook(book: Book?) {
    let vc = BookViewController()
    vc.book = selectedCell()?.book
    DispatchQueue.main.async {
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
}

// MARK: UICollectionViewDelegate
extension BooksViewController{
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    openBook(book: books?[indexPath.row])
  }
}

extension BooksViewController{
  override func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    books?.count ?? 0
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView .dequeueReusableCell(withReuseIdentifier: BookCoverCell.description(), for: indexPath) as! BookCoverCell
    cell.book = books?[indexPath.row]
    return cell
  }
}

extension BooksViewController {
  func animationControllerForPresentController(_ vc: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    // 1
    let transition = BookOpeningTransition()
    // 2
    transition.isPush = true
    // 3
    self.transition = transition
    // 4
    return transition
  }
  func animationControllerForDismissController(_ vc: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let transition = BookOpeningTransition()
    transition.isPush = false
    self.transition = transition
    return transition
  }
}
