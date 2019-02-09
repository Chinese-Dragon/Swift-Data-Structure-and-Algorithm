import Foundation

protocol Queue {
  associatedtype anyType
  var items: [anyType?] { get }
  var isEmpty: Bool { get }
  var count: Int { get }
  var front: anyType? { get }
  mutating func enqueue(_ item: anyType)
  mutating func dequeue() -> anyType?
}

// https://github.com/raywenderlich/swift-algorithm-club/tree/master/Queue
struct QueueArrayImp<T>: Queue {
  private var head = 0
  private(set) var items: [T?] = []
  
  var count: Int {
    return items.count - head
  }
  
  var isEmpty: Bool {
    return count == 0
  }
  
  var front: T? {
    return isEmpty ? nil : items[head]
  }
  
  mutating func enqueue(_ item: T) {
    items.append(item)
  }
  
  /*
   Simplistic: takes O(n) because of require shift everytime we dequeue from front of the inner array
   Better: takes O(1) on average and only shift when necessary
  **/
  mutating func dequeue() -> T? {
    guard head < items.count, let front = items[head] else {
      return nil
    }
    
    // mark front as nil
    items[head] = nil
    
    // increment head to point to the new front
    head += 1
    
    // remove waste spaces at front if the inner array is big enough and have 25% empty space at front: operation takes O(n) because it requires shifting
    let percentage = Double(head)/Double(items.count)
    if items.count > 50 && percentage > 0.25 {
      items.removeFirst(head)
      head = 0
    }
    
    return front
  }
}

var q = QueueArrayImp<Any>()

q.enqueue(1)
q.enqueue(2)
q.enqueue(3)

print(q.dequeue() ?? -999)
