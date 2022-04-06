//
//  Map,Filter,Reduce.swift
//  Monitor
//
//  Created by Fri on 2022/4/2.
//

import Foundation
import UIKit

enum Chapter4 {
  func increment(array: [Int]) -> [Int] {
    var result: [Int] = []
    for x in array {
      result.append(x + 1)
    }
    return result
  }
  
  func double(array: [Int]) -> [Int] {
    var result: [Int] = []
    for x in array {
//      result.append(x * 2)
      result.append(x << 1)
    }
    return result
  }
  
  func compute(array: [Int], transform: (Int) -> Int) -> [Int] {
    var result: [Int] = []
    for x in array {
      result.append(transform(x))
    }
    return result
  }
  
  func double2(array: [Int]) -> [Int] {
    return compute(array: array) { $0 * 2 }
  }
  
  func compute(array: [Int], transform: (Int) -> Bool) -> [Bool] {
    var result: [Bool] = []
    for x in array {
      result.append(transform(x))
    }
    return result
  }
  
  func isEven(array: [Int]) -> [Bool] {
    return compute(array: array) { $0%2 == 0 }
  }
  
  func genericCompute<T>(array: [Int], transform: (Int) -> T) -> [T] {
    var result: [T] = []
    for x in array {
      result.append(transform(x))
    }
    return result
  }
  
  func map<Element, T>(_ array: [Element], transform: (Element) -> T) -> [T] {
    var result: [T] = []
    for x in array {
      result.append(transform(x))
    }
    return result
  }
  
  func genericCompute2<T>(array: [Int], transform: (Int) -> T) -> [T] {
    return map(array, transform: transform)
  }
  
}

extension Sequence {
  //MARK: - Map - Functor, f(x) = y
  func map_<T>(_ transform: (Element) throws -> T) rethrows -> [T] {
    var result: [T] = []
    for x in self {
      result.append(try transform(x))
    }
    return result
  }
  
  func map__<T>(_ transform: (Element) throws -> T) rethrows -> [T] {
    var result = ContiguousArray<T>()
    result.reserveCapacity(underestimatedCount)
    
    var iter = makeIterator()
    
    while let e = iter.next() {
      result.append(try transform(e))
    }
    
    return Array(result)
  }
  
  func filter_(_ judegment: (Element) throws -> Bool) rethrows -> [Element] {
    var result = [Element]()
    for x in self where try judegment(x) {
      result.append(x)
    }
    return Array(result)
  }
  
  //[Self.Element] -> [SegmentOfResult.Element]
  func flatMap_<S: Sequence>(_ transform: (Element) throws -> S) rethrows -> [S.Element] {
    var result: [S.Element] = []
    for element in self {
      result.append(contentsOf: try transform(element))
    }
    return result
  }
  
  
  // [T] -> T
  @inlinable
  @inline(__always)
  func reduce_<R>(_ initialRes: R, nextPartialResult: (R, Element) throws -> R) rethrows -> R {
    var accumulator = initialRes
    for e in self {
      accumulator = try nextPartialResult(accumulator, e)
    }
    return accumulator
  }
  
  //[T]->[R]
  func mapUseReduce<R>(_ transform: (Element) throws -> R) rethrows -> [R] {
    try reduce_([]) { partialResult, nextElement in
      var res = partialResult
      res.append(try transform(nextElement))
      return res
    }
  }
  
  //[Self.Element] -> [SegmentOfResult.Element]
  func flatMapUseReduct<SegmentOfResult: Sequence>(_ transform: (Element) throws -> SegmentOfResult) rethrows -> [SegmentOfResult.Element] {
    try reduce_([], nextPartialResult: { partialResult, nextElem in
      partialResult + (try transform(nextElem))
    })
  }

  func filterUserReduce(_ isInclude: (Element)-> Bool) -> [Element] {
    reduce_([]) { partialResult, nextElem in
      if isInclude(nextElem) {
        return partialResult + [nextElem]
      }else {
        return partialResult
      }
    }
  }
  
  // 自己写写，挺好玩的
  func curry<A,B,C>(_ f: @escaping (A,B)->C) -> (A) -> (B) -> C {
    { a in { b in f(a, b) } }
//    return { a in
//      return { b in
//        return f(a, b)
//      }
//    }
  }
  typealias K = (@escaping (Int,Double)->String) -> (Int) -> (Double) -> String
  var k: K {
    {maker in { a in { b in maker(a, b) } } }
//    return { maker in
//      return { a in
//        return { b in
//          maker(a, b)
//        }
//      }
//    }
  }
  
  typealias ItemBuilder = (@escaping (UILabel) -> UILabel) -> (UILabel) -> (String) -> UILabel
  var labelBuilder: ItemBuilder {
    return { maker in
      return { l in
        return { str in
          let label = maker(l)
          label.text = str
          return label
        }
      }
    }
  }
}

enum Optional_<T> {
  case none
  case some(T)
  
  @inlinable
  func map<U>(_ transform: (T) throws ->U) rethrows -> U? {
    switch self {
    case .none:
      return .none// 真正的 Optional.none
    case .some(let t):
      return try transform(t)
    }
  }
  
  var unsafelyUnwrapped: T? {
    @inline(__always)
    get {
      if case .some(let x) = self {
        return x
      }
      return nil// ignore!
    }
  }
  
}
