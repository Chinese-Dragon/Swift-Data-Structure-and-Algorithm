import Foundation

/**
 Recursive thinking:
 1: Break the problem I am trying to solve down into a problem that is one step simpler
 2: Assume that my function will work to solve the simpler problem — really believe it beyond any doubt
 3: Ask myself: Since I know I can solve the simpler problem, how would I solve the more complex problem?
 */
func printElementsFrom(_ arr: [Int]) -> String {
  // base case
  if arr.isEmpty {
    return ""
  }
  
  return "\(arr.first!)" + printElementsFrom(Array(arr[1...]))
}

print(printElementsFrom([1,2,3,4]))

func isPalindrome(_ str: String) -> Bool {
  if str.count < 2 {
    return true
  }
  
  if str.count == 2 {
    return str.first! == str.last!
  }
  
  return str.first! == str.last! && isPalindrome(String(str.dropFirst().dropLast()))
}

public class BinarySearchTree<T: Comparable> {
  private(set) public var value: T
  private(set) public weak var parent: BinarySearchTree?
  private(set) public var left: BinarySearchTree?
  private(set) public var right: BinarySearchTree?
  
  public init(value: T) {
    self.value = value
  }
  
  public var isRoot: Bool {
    return parent == nil
  }
  
  public var isLeaf: Bool {
    return left == nil && right == nil
  }
  
  public var isRightChild: Bool {
    return parent?.right === self
  }
  
  public var isLeftChild: Bool {
    return parent?.left === self
  }
  
  public var hasLeftChild: Bool {
    return left != nil
  }
  
  public var hasRightChild: Bool {
    return right != nil
  }
  
  public var hasAnyChild: Bool {
    return hasLeftChild || hasRightChild
  }
  
  public var hasBothChildren: Bool {
    return hasLeftChild && hasRightChild
  }
  
  public var count: Int {
    return (left?.count ?? 0) + 1 + (right?.count ?? 0)
  }
  
  /** you should insert the numbers in a random order. If you insert them in a sorted order, the tree will not have the right shape.
  e.g
      1
       \
        2
         \
          3
           \
            4
  */
  public func insert(value: T) {
    if value < self.value {
      if let left = left {
        left.insert(value: value)
      } else {
        left = BinarySearchTree(value: value)
        left?.parent = self
      }
    } else {
      if let right = right {
        right.insert(value: value)
      } else {
        right = BinarySearchTree(value: value)
        right?.parent = self
      }
    }
  }
  
  /**
   In Swift, that is conveniently done with optional chaining; when you write left?.search(value) it automatically returns nil if left is nil. There is no need to explicitly check for this with an if statement.
   Time: O(h)
   Average: O(logn)
   Wosrt: O(n)
   */
  public func search(value: T) -> BinarySearchTree? {
    if value < self.value {
      return left?.search(value: value)
    } else if value > self.value {
      return right?.search(value: value)
    } else {
      return self
    }
  }
  
  public func minimum() -> BinarySearchTree {
    var node = self
    
    while let next = node.left {
      node = next
    }
    
    return node
  }
  
  public func maximum() -> BinarySearchTree {
    var node = self
    
    while let next = node.right {
      node = next
    }
    
    return node
  }
 
  // remove the current node and return the replacement
  @discardableResult public func remove() -> BinarySearchTree? {
    var replacement: BinarySearchTree?
    
    // check the max on the left or the smallest on the right
    if let left = left {
      replacement = left.maximum()
    } else if let right = right {
      replacement = right.minimum()
    } else {
      replacement = nil
    }
    
    replacement?.remove()
    
    // changes the pointers of the replacement
    replacement?.right = right
    replacement?.left = left
    right?.parent = replacement
    left?.parent = replacement
    reconnectParentTo(node: replacement)
    
    // remove the current node
    parent = nil
    left = nil
    right = nil
    
    return replacement
  }
  
  private func reconnectParentTo(node: BinarySearchTree?) {
    if let parent = parent {
      if isLeftChild {
        parent.left = node
      } else {
        parent.right = node
      }
    }
    node?.parent = parent
  }
}

extension BinarySearchTree {
  public convenience init(array: [T]) {
    precondition(array.count > 0)
    self.init(value: array.first!)
    for v in array.dropFirst() {
      insert(value: v)
    }
  }
}

extension BinarySearchTree: CustomStringConvertible {
  public var description: String {
    var s = ""
    if let left = left {
      s += "(\(left.description)) <- "
    }
    s += "\(value)"
    if let right = right {
      s += " -> (\(right.description))"
    }
    return s
  }
}

extension BinarySearchTree {
  public func traverseInOrder(process: (T) -> Void) {
    left?.traverseInOrder(process: process)
    process(value)
    right?.traverseInOrder(process: process)
  }
  
  public func traversePreOrder(process: (T) -> Void) {
    process(value)
    left?.traversePreOrder(process: process)
    right?.traversePreOrder(process: process)
  }
  
  public func traversePostOrder(process: (T) -> Void) {
    left?.traversePostOrder(process: process)
    right?.traversePostOrder(process: process)
    process(value)
  }
}

extension BinarySearchTree {
  public func map(formula: (T) -> T) -> [T] {
    var a = [T]()
    
    if let left = left {
      a.append(contentsOf: left.map(formula: formula))
    }
    
    a.append(formula(value))
    
    if let right = right {
      a.append(contentsOf: right.map(formula: formula))
    }
    
    return a
  }
  
  public func toSortedArray() -> [T] {
    return self.map { $0 }
  }
}

extension BinarySearchTree {
  /**
   E.g
        7
       /  \
      2    10
     / \   /
    1   5 9
   
   Height: 2
  */
  public func height() -> Int {
    if isLeaf {
      return 0
    }
    
    return 1 + max(left?.height() ?? 0, right?.height() ?? 0)
  }
  
  public func depth() -> Int {
    if isRoot {
      return 0
    }
    
    return 1 + parent!.depth()
  }
}

extension BinarySearchTree {
  public func predecessor() -> BinarySearchTree<T>? {
    if let left = left {
      return left.maximum()
    } else {
      var node = self
      while let parent = node.parent {
        if parent.value < value { return parent }
        node = parent
      }
      return nil
    }
  }
  
  public func successor() -> BinarySearchTree<T>? {
    if let right = right {
      return right.minimum()
    } else {
      var node = self
      while let parent = node.parent {
        if parent.value > value { return parent }
        node = parent
      }
      return nil
    }
  }
}

extension BinarySearchTree {
  /**
    Not only we need all the subtree to be BST but we also need to make sure that the
    value <= max && value >= min and this min and max are propagated from root.
  */
  public func isBST(min: T, max: T) -> Bool {
    if value < min || value > max { return false }
    let leftBST = left?.isBST(min: min, max: value) ?? true
    let rightBST = right?.isBST(min: value, max: max) ?? true
    return leftBST && rightBST
  }
}

let tree = BinarySearchTree(value: 7)
tree.insert(value: 2)
tree.insert(value: 5)
tree.insert(value: 10)
tree.insert(value: 9)
tree.insert(value: 1)

print(tree)
print(tree.search(value: 10) == nil ? "Not Found" : "Found")

tree.traverseInOrder { print($0) }

print("--------------------")
tree.traversePostOrder { print($0) }

print("--------------------")
tree.traversePreOrder { print($0) }

print("--------------------")
print(tree.map { $0 })

print("--------------------")
print(tree.toSortedArray())

print("--------------------")
print("Max: \(tree.maximum().value) Min: \(tree.minimum().value)")

//print("--------------------")
//let replacementNode = tree.remove()
//print(replacementNode == nil ? "Removed leaf node" : "Replaced with: \(replacementNode!.value)")
//
//print(replacementNode?.toSortedArray())


print("--------------------")
print(tree.height())

print("--------------------")
if let node9 = tree.search(value: 9) {
  print(node9.depth())
}

if let node1 = tree.search(value: 1) {
  tree.isBST(min: Int.min, max: Int.max)  // true
  node1.insert(value: 100)                                 // EVIL!!!
  tree.search(value: 100)                                  // nil
  tree.isBST(min: Int.min, max: Int.max)  // false
}
