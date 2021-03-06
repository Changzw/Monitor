//
//  BattleShip.swift
//  Monitor
//
//  Created by Fri on 2022/4/2.
//

import Foundation
import UIKit

// Chapt 2, BattleShip game
typealias Distance = Double

struct Position {
  var x: Double
  var y: Double
}

extension Position {
  // determine if is within circle firing range
  func inRange(range:Distance) -> Bool {
    sqrt(x*x + y*y) <= range
  }
  // Things can be made better with more granular extensions
  // These are vector calculations.
  func minus(_ p:Position) -> Position {
    Position(x:x-p.x , y:y-p.y)
  }
  // could be called 'distance'
  var length: Double {
    sqrt(x*x + y*y)
  }
}

enum RegionOperator {// This is cool - Regions are defined by whether or not a point lies within.
  // Region type is any function which takes a Position and returns a Bool. Very cool!
  typealias Region = (Position) -> Bool
  
  // Functions that return Regions.
  // Default position is at the origin
//  static func circle(radius: Distance) -> Region {
//    return { point in point.length <= radius }
//  }
  static func circle(radius: Distance, center: Position = .init(x: 0, y: 0)) -> Region {
    if center.x == 0 && center.y == 0 {
      return { point in point.length <= radius }
    }else {
      return { point in point.minus(center).length <= radius }
    }
  }
  
  // Move Regions around by adding offsets. (like CGOffset)
  static func shift(_ region: @escaping Region, by offset: Position) -> Region {
    // we wrap the original region function in another func
    // which offsets from the point. Neat!
    return { point in region(point.minus(offset)) }
  }
  
  // By wrapping functions, a whole bunch of great primitives can be created!
  static func invert(_ region: @escaping Region) -> Region {
    return { point in !region(point) }
  }
  
  static func intersect(_ region: @escaping Region, with other: @escaping Region) -> Region {
    return { point in region(point) && other(point) }
  }
  
  static func union(_ region: @escaping Region, with other: @escaping Region) -> Region {
    return { point in region(point) || other(point) }
  }
  
  // Function to create region that are in the first, but NOT in the second. NEAATOO
  static func subtract(_ region: @escaping Region, from original: @escaping Region) -> Region {
    return intersect(original, with: invert(region))
  }
}

struct Ship {
  var position: Position
  var firingRange: Distance
  
  // dont want to target ships that are too close
  var unsafeRange: Distance
}

extension Ship {
  // ?????????????????????
  func canEngageShip(target:Ship) -> Bool {
    let dx = target.position.x - position.x
    let dy = target.position.y - position.y
    let targetDistance = sqrt(dx*dx + dy*dy)
    return targetDistance <= firingRange
  }
  
  // ??????????????????????????????????????? take into account safe firing range
  func canSafelyEngageShip(target:Ship) -> Bool {
    let dx = target.position.x - position.x
    let dy = target.position.y - position.y
    let targetDistance = sqrt(dx*dx + dy*dy)
    return targetDistance <= firingRange && targetDistance > unsafeRange
  }
  
  // ???????????????????????????????????????
  func canSafelyEngageImproved(ship target: Ship, friendly: Ship) -> Bool {
    let targetDistance = target.position.minus(position).length
    let friendlyDistance = friendly.position.minus(target.position).length
    return targetDistance <= firingRange && targetDistance > unsafeRange && friendlyDistance > unsafeRange
  }
  
  // ???????????????????????????????????????
  // Then it gets complicated ... What about firing if a friendly ship is too close to an enemy?
  // This was previously a huge pain in the ass. Mixed bools and calculations.
  // With our new Region functions, this is much more declarative.
  func canSafeEngageFunctional(ship target: Ship, friendly: Ship) -> Bool {
    typealias R = RegionOperator
    // Fire within the firing range, but NOT the unsafeRange :D
    let rangeRegion = R.subtract(R.circle(radius: unsafeRange), from: R.circle(radius: firingRange))
    // firing region is our current range adjusted for Ship's position
    let firingRegion = R.shift(rangeRegion, by: position)
    // Also dont want to fire within unsafe range around friendly ship
    let friendlyRegion = R.shift(R.circle(radius: unsafeRange), by: friendly.position)
    // takes into account unsafe region, friendly ship unsafe region, adjusted for positions!!
    let resultRegion = R.subtract(friendlyRegion, from: firingRegion)
    return resultRegion(target.position)
  }
}


// Chapter 3 , wrapping Core Image
//typealias Filter = (CIImage) -> CIImage
//
//
//// Functions take in necessary params, and then generate a 'Filter' type to use.
//func blur(radius:Double) -> Filter {
//  return { image in
//    let parameters = [ kCIInputRadiusKey: radius, kCIInputImageKey: image]
//    let filter  = CIFilter(name:"CIGaussianBlur", withInputParameters: parameters)!
//    return filter.outputImage!
//  }
//}
//
//// Generates a constant color. Doesn't apply anything to an image
//// Notice that the image arg is ignored.
//func colorGenerator(color: UIColor) -> Filter {
//  return { _ in
//    let parameters = [kCIInputColorKey: color]
//    let filter = CIFilter(name: "CIConstantColorGenerator",
//                          withInputParameters: parameters)!
//    return filter.outputImage!
//  }
//}
//
//// overlays another image on top of another
//func compositeSourceOver(overlay: CIImage) -> Filter {
//  return { image in
//    let parameters = [ kCIInputBackgroundImageKey: image, kCIInputImageKey: overlay]
//    let filter = CIFilter(name: "CISourceOverCompositing",withInputParameters: parameters)!
//
//    // crop to the size of the input image
//    let cropRect = image.extent
//    return filter.outputImage!.imageByCroppingToRect(cropRect)
//  }
//}
//
//// Combine these things to create a color-overlay filter
//func coloredOverlay(color:UIColor) -> Filter {
//  return { image in
//    // This applies the overlay filter to image to produce an image
//    let overlayImage = colorGenerator(color)(image)
//
//    // use overlay as argument to composite fitler. Return resulting image
//    return compositeSourceOver(overlayImage)(image)
//  }
//}
//
//// Blur a photo and put an overlay on top
//let url = NSURL(string: "http://tinyurl.com/m74sldb")
//let image = CIImage(contentsOfURL: url!)
//
//
//// Function to compose filters
//// g(f(x))
//func composeFilters(one:Filter , two:Filter) -> Filter {
//  return { image in two(one(image)) }
//}
//
//// create a custom operator to compose filters
//// inputs are read from left->right like UNIX pipes
//infix operator -|- { associativity left }
//
//func -|- (one:Filter, two:Filter) -> Filter {
//  return { image in two(one(image)) }
//}
//
//// WOW that's pretty cool!
//let blueOverlayFilter = coloredOverlay(UIColor.blueColor()) -|- compositeSourceOver(image!)
//
//// Chapter 4
//let x:Any = "hello"
//let g:String? = "hldlfd"
//
//let f = g ?? "nothing"
//
//// Chapter 5
//// Use enums and associated values to provide bounds of the 'type' of values a result can have.
//// Generic enums can provide flexible success, errors of any type. Death to magic strings!
////Use enums and associated values to provide bounds on the 'type' of values a result can have. Generic enums can provide flexible success, errors of any type. No more magic strings! Dummy values are not 'rich' types; they have no place in a functional programming world.
//enum Result<T> {
//  case Success(T)
//  case Failure(NSError)
//}
//
//// The 'void' generic type can be created via blah<()> which means no associated value for .Success
//let thing = Result.Success("HELLO")
//
//// Purely Functional Data Structures
//// By using 'indirect' this becomes a recursive datastructure.
//// Associated values are either nothing (leaf) or recurse into two separate trees
//// associated values can be accessed via swtich or 'if case ' statements
//indirect enum BinarySearchTree<Element:Comparable> {
//  case Leaf
//  case Node(BinarySearchTree<Element> , Element , BinarySearchTree<Element>)
//
//  init() {
//    self = .Leaf
//  }
//
//  init(value:Element) {
//    self = .Node(.Leaf , value , .Leaf)
//  }
//}
//
//// TIP - Element could be anything! Structs, whatever can conform to 'comparable'
//let leaf:BinarySearchTree<Int> = .Leaf
//let oneTree:BinarySearchTree<Int> = .Node(leaf , 5 , leaf)
//
//// As with tree data structures, many of the methods written on trees will be recursive.
//// Use a 'self' switch to check out the type of an enum. Neat!
//// recursively count the size of a search tree
//extension BinarySearchTree {
//  var count:Int {
//    switch self {
//    case .Leaf:
//      return 0
//    case let .Node(left , _ , right):
//      return 1 + left.count + right.count
//    }
//  }
//
//  var elements:[Element] {
//    switch self {
//    case .Leaf:
//      return []
//    case let .Node(left,x,right):
//      return left.elements + [x] + right.elements
//    }
//
//  }
//}
//
//// Pretty dope use of 'where' operator.
//extension SequenceType {
//
//  func all(predicate: (Generator.Element) -> Bool ) -> Bool {
//    for x in self where !predicate(x) {
//      return false
//    }
//    return true
//  }
//
//}
//
//
//// Determine is a tree meets requirements to be a binary search tree
//extension BinarySearchTree where Element:Comparable {
//  var isBST:Bool {
//
//    switch self {
//    case .Leaf:
//      return true
//
//    case let .Node(left, x, right):
//      return left.elements.all { y in y < x } &&
//      right.elements.all { z in z > x } &&
//      left.isBST &&
//      right.isBST
//    }
//  }
//}
//
//
//// Binary tree 'contains' using switch pattern matching :o
//extension BinarySearchTree {
//  func contains(elm:Element) -> Bool {
//
//    switch self {
//    case .Leaf:
//      return false
//
//    case let .Node(_,y,_) where elm == y:
//      return true
//
//    case let .Node(left,y,_) where elm < y:
//      return left.contains(elm)
//
//    case let .Node(_,y,right) where elm > y:
//      return right.contains(elm)
//    default:
//      fatalError("nope!")
//    }
//
//  }
//}
//
//
//// Insertion into the tree. Trick is to keep recursing down the tree.
//// Imagine simplist case, then recurse
//extension BinarySearchTree {
//  mutating func insert(elm:Element) {
//    switch self {
//    case .Leaf:
//      return self = BinarySearchTree(value: elm)
//    case .Node(var left , let y , var right):
//      if elm < y {
//        left.insert(elm)
//      }
//
//      else if elm > y {
//        right.insert(elm)
//      }
//
//      // equal return the original tree
//      else {
//        return self = .Node(left, elm , right)
//      }
//    }
//  }
//}
//
//
//// Why not use an enum ? Because tries can have N-many edges. Enums are for known quantities.
//// Functional Trie data structure
//// Tries can have mult edges from a single node
//struct Trie<Element:Hashable> {
//  var isElement:Bool // determines if it is a leaf.
//  var children:[Element:Trie<Element>]
//
//  init() {
//    isElement = false
//    children = [:]
//  }
//
//  init(isElement:Bool , children:[Element:Trie<Element>]) {
//    self.isElement = isElement
//    self.children = children
//  }
//}
//
//// This is like Lisp car,cdr
//extension Array {
//  var decompose:(Element, [Element])? {
//    if isEmpty { return .None }
//
//    return (self[startIndex] , Array(self.dropFirst()))
//  }
//}
//
//// Flattens a Trie into an array containing array of each edge
//extension Trie {
//  var elements: [[Element]] {
//    var result: [[Element]] = isElement ? [[]] : []
//    for (key, value) in children {
//      result += value.elements.map { [key] + $0 } }
//    return result
//  }
//}
//
//extension Trie where Element:Hashable {
//  init(list:[Element]) {
//    if let (head, tail) = list.decompose {
//      let children = [head:Trie(list:tail)]
//      self = Trie(isElement: false, children: children)
//    } else {
//      self = Trie(isElement:true, children:[:])
//    }
//  }
//}
//
//// check it out , 'sum' can be written without a loop recursively
//func sum(arr:[Int]) -> Int {
//  // tuple decomposition here, nice..
//  guard let (head,tail) = arr.decompose else { return 0 }
//  return head+sum(tail)
//}
//
//// We can use decompose to lookup items in the trie. We lookup an array of 'Elements'
//// such as array of characters as a string
//extension Trie {
//  func lookup(key:[Element]) -> Bool {
//    // isElement determines whether the branch is a stopping point. Such as as inserting
//    // cat and catch . The 't' and 'h' are elements.
//    guard let (head, tail) = key.decompose else { return isElement }
//
//    // go down into the next trie and try to find a match
//    guard let subtrie = children[head] else { return false }
//    return subtrie.lookup(tail)
//  }
//}
//
//// Returns the trie matching a specific prefix
//extension Trie {
//  func withPrefix(prefix:[Element]) -> Trie<Element>? {
//
//    // base case, reached the end
//    guard let (head, tail) = prefix.decompose else { return self }
//    guard let remainder = children[head] else {return .None}
//    // recurse down the tree. Very cool! Much more elegant that procedural version
//    return remainder.withPrefix(tail)
//  }
//
//  // To autocomplete, call withPrefix and return it's elements
//
//  // basically returns an array of Tries
//  func autocomplete(elms:[Element]) -> [[Element]] {
//    return self.withPrefix(elms)?.elements ?? []
//  }
//}

