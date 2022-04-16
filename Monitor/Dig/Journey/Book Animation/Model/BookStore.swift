//
//  JournalCollectionViewController.swift
//  Monitor
//
//  Created by Fri on 2022/4/14.
//


import UIKit

class BookStore {

    static let sharedInstance = BookStore()
    func loadBooks(plist: String) -> [Book] {
        var books: [Book] = []
        
      if let path = Bundle.main.path(forResource: plist, ofType: "plist") {//(plist, ofType: "plist") {
            if let array = NSArray(contentsOfFile: path) {
                for dict in array as! [NSDictionary] {
                    let book = Book(dict: dict)
                    books += [book]
                }
            }
        }
        
        return books
    }
    
}
