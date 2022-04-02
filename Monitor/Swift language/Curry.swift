//
//  Curry.swift
//  Monitor
//
//  Created by Fri on 2022/4/1.
//

import Foundation


protocol KKK {
  associatedtype Element
  var elem: Element { get }
}

enum Curry {
 
  static
  func curry()
  -> (Int, Int)
  -> (Int, Int)
  -> (Int, Int)
  -> Int {
    return { x0, y0 in
      return { x1, y1 in //(String(x), String(y))
        return { x2, y2 in
          return x0 + x1 + x2 + y1 + y2 + y0
        }
      }
    }
  }

  static let c = curry()(1,2)(1,2)(1,2)

  static func itembbb//<Sequence: Swift.Sequence, Cell: KKK, Source: KKK>
  (cellIdentifier: String, cellType: Int)
  -> (_ source: Int)
  -> (_ configureCell: @escaping (Int, String, String) -> Void)
  -> Int {
    return { source in
      return { configureCell in
        configureCell(15, "aaa", "KKK")
        return 10
        //           return self.items(dataSource: dataSource)(source)
      }
    }
  }

  class FFF {
    public func bind<R1, R2>(to binder: (FFF) -> (R1) -> R2, curriedArgument: R1) -> R2 {
      binder(self)(curriedArgument)
    }
  }

}
