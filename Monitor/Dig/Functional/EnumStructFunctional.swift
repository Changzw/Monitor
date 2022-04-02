//
//  EnumStructFunctional.swift
//  Monitor
//
//  Created by Fri on 2022/4/2.
//

import Foundation

enum Chapter9 {
  struct MySet<Element: Equatable> {
    var storage: [Element] = []
    
    var isEmpty: Bool { storage.isEmpty }
    
    func contains(_ element: Element) -> Bool {
      storage.contains(element)
    }
    
    func inserting(_ x: Element) -> MySet {
      contains(x) ? self : MySet(storage: storage + [x])
    }
  }
  
}

//MARK: - BinarySearchTree
indirect enum BinarySearchTree<Elem: Comparable> {
  case leaf
  case node(left: Self, value: Elem, right: Self)
}

extension BinarySearchTree {
  var isEmpty: Bool {
    if case .leaf = self {
      return true
    }
    return false
  }
  
  var count: Int {
    switch self {
    case .leaf:
      return 0
    case let .node(left: l, value: _, right: r):
      return 1 + l.count + r.count
    }
  }
  var elements: [Elem] {
    switch self {
    case .leaf:
      return []
    case let .node(left: l, value: v, right: r):
      return l.elements + [v] + r.elements
    }
  }

  init() {
    self = .leaf
  }
  init(_ value: Elem) {
    self = .node(left: .leaf, value: value, right: .leaf)
  }
}

extension BinarySearchTree {
  var connt_: Int {
    reduce(0) { 1 + $0 + $2 }
  }
  
  var elements_: [Elem] {
    reduce([]) { $0 + [$1] + $2 }
  }
  
  func reduce<R>(_ initialResult: R, partialResult: (R, Elem, R)-> R) -> R {
    switch self {
    case .leaf:
      return initialResult
    case let .node(left: l, value: v, right: r):
      return partialResult(
        l.reduce(initialResult, partialResult: partialResult),
        v,
        r.reduce(initialResult, partialResult: partialResult)
      )
    }
  }
  
  //  func reduce<A>(leaf leafF: A, node nodeF: (A, Elem, A) -> A) -> A {
  //    switch self {
  //    case .leaf:
  //      return leafF
  //    case let .node(left, x, right):
  //      return nodeF(
  //        left.reduce(leaf: leafF, node: nodeF),
  //        x,
  //        right.reduce(leaf: leafF, node: nodeF))
  //    }
  //  }
  
}

// BST
extension BinarySearchTree {
  var isBST: Bool {//(低效率)
    switch self {
    case .leaf:
      return true
    case let .node(left, x, right):
      return left.elements.allSatisfy { y in y < x }
      && right.elements.allSatisfy { y in y > x }
      && left.isBST && right.isBST
    }
  }
  
  func contains(_ x: Elem) -> Bool {
    switch self {
    case .leaf:
      return false
    case let .node(_, y, _) where x == y:
      return true
    case let .node(left, y, _) where x < y:
      return left.contains(x)
    case let .node(_, y, right) where x > y:
      return right.contains(x)
    default:
      fatalError("The impossible occurred") }
  }
  
  mutating func insert(_ x: Elem) {
    switch self {
    case .leaf:
      self = BinarySearchTree(x)
    case .node(var l, let y, var r):
      if x < y { l.insert(x) }
      if x > y { r.insert(x) }
      self = .node(left: l, value: y, right: r) }
  }
}

//MARK: - Trie
struct Trie {
  let children: [Character: Trie]
}
