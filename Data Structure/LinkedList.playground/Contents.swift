import Foundation

public class LinkedListNode<T> {
  var value: T
  var next: LinkedListNode?
  weak var previous: LinkedListNode?
  
  public init(value: T) {
    self.value = value
  }
}

// https://github.com/raywenderlich/swift-algorithm-club/tree/master/Linked%20List
/**
 Performance of linked lists:
 
 Most operations on a linked list have O(n) time, so linked lists are generally slower than arrays. However, they are also much more flexible -- rather than having to copy large chunks of memory around as with an array, many operations on a linked list just require you to change a few pointers.
 
 The reason for the O(n) time is that you can't simply write list[2] to access node 2 from the list. If you don't have a reference to that node already, you have to start at the head and work your way down to that node by following the next pointers (or start at the tail and work your way back using the previous pointers).
 
 But once you have a reference to a node, operations like insertion and deletion are really quick. It's just that finding the node is slow.
 
 This means that when you're dealing with a linked list, you should insert new items at the front whenever possible. That is an O(1) operation. Likewise for inserting at the back if you're keeping track of the tail pointer.
 */

/**
 Singly vs doubly linked lists:
 
 A singly linked list uses a little less memory than a doubly linked list because it doesn't need to store all those previous pointers.
 
 But if you have a node and you need to find its previous node, you're screwed. You have to start at the head of the list and iterate through the entire list until you get to the right node.
 
 For many tasks, a doubly linked list makes things easier.
 */

/**
 Why use a linked list?
 
 A typical example of where to use a linked list is when you need a queue. With an array, removing elements from the front of the queue is slow because it needs to shift down all the other elements in memory. But with a linked list it's just a matter of changing head to point to the second element. Much faster.
 
 But to be honest, you hardly ever need to write your own linked list these days. Still, it's useful to understand how they work; the principle of linking objects together is also used with trees and graphs.
 */

public class LinkedList<T> {
  public typealias Node = LinkedListNode<T>
  
  private var head: Node?
  
  public var isEmpty: Bool {
    return head == nil
  }
  
  public var first: Node? {
    return head
  }
  
  public var last: Node? {
    guard var node = head else {
      return nil
    }
    
    // Niiiiiiice!!!
    while let next = node.next {
      node = next
    }
    
    return node
  }
  
  public var count: Int {
    guard var node = head else {
      return 0
    }
    
    var count = 1
    while let next = node.next {
      node = next
      count += 1
    }
    
    return count
  }
  
  public func append(value: T) {
    let newNode = Node(value: value)
    if let lastNode = last {
      lastNode.next = newNode
      newNode.previous = lastNode
    } else {
      head = newNode
    }
  }
  
  public func insert(_ node: Node, atIndex index: Int) {
    let newNode = node
    
    // insert at head
    if index == 0 {
      newNode.next = head
      head?.previous = newNode
      head = newNode
    } else {
      // insert between prev and next
      let prev = self.node(atIndex: index - 1)
      let next = prev?.next
      
      newNode.previous = prev
      newNode.next = next
      prev?.next = newNode
      next?.previous = newNode
    }
  }
  
  public func node(atIndex index: Int) -> Node? {
    guard var node = head else {
      return nil
    }
    
    if index == 0 {
      return node
    }
    
    var count = 1
    while count < (index + 1), let next = node.next {
      node = next
      count += 1
    }
    
    if count == index + 1 {
      return node
    }
    
    return nil
  }
  
  /// Subscript function to return the node at a specific index
  ///
  /// - Parameter index: Integer value of the requested value's index
  public subscript(index: Int) -> T? {
    let node = self.node(atIndex: index)
    return node?.value
  }

  public func removeAll() {
    head = nil
  }
  
  public func remove(node: Node) -> T {
    let prev = node.previous
    let next = node.next
    
    if let prev = prev {
      prev.next = next
    } else {
      head = next
    }
    next?.previous = prev
    
    node.previous = nil
    node.next = nil
    return node.value
  }
}

var llst = LinkedList<Int>()

llst.append(value: 1)
llst.append(value: 2)
llst.append(value: 3)
llst.append(value: 4)

print(llst.node(atIndex: llst.count - 1)?.value)
