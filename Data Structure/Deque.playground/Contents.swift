import Foundation

protocol Deque {
  associatedtype anyType
  var isEmpty: Bool { get }
  var count: Int { get }
  var front: anyType? { get }
  var back: anyType? { get }
  mutating func enqueue(_ item: anyType)
  mutating func enqueueFront(_ item: anyType)
  mutating func dequeue() -> anyType?
  mutating func dequeueBack() -> anyType?
}

/**
    https://github.com/raywenderlich/swift-algorithm-club/tree/master/Deque

    Deque: Double ended queue which supports enqueue dequeue from front and back. When dequeue or enqueue from front, to prevent array auto shifting and keep average O(1), we need to implement efficient resizing logic to the front same as swift internal implement for the back.
 */
struct DequeArrayImp<T>: Deque {
  typealias anyType = T

  private var items: [T?]
  private var head: Int
  private var emptySpaceCapacity: Int
  private var originalCapacity: Int

  init(_ emptySpaceCapacity: Int = 10) {
    self.emptySpaceCapacity = max(emptySpaceCapacity, 1)  // make sure we have minial capacity 1 empty space
    self.originalCapacity = self.emptySpaceCapacity
    self.items = [T?](repeating: nil, count: emptySpaceCapacity)
    self.head = emptySpaceCapacity // [ x, x, x, x, x, x, x, x, x, x ] head
  }

  var isEmpty: Bool {
    return count == 0
  }

  var count: Int {
    return items.count - head
  }

  var front: T? {
    return isEmpty ? nil : items[head]
  }

  var back: T? {
    return isEmpty ? nil : items.last!
  }

  mutating func enqueue(_ item: T) {
    items.append(item)
  }

  /**
     If you enqueue a lot of objects at the front, you're going to run out of
   empty spots at the front at some point. When this happens at the back of the array,
   Swift automatically resizes it. But at the front of the array we have to handle
   this situation ourselves.
  */
  mutating func enqueueFront(_ item: T) {
    if head == 0 {
      // 1: double empty space capacity
      emptySpaceCapacity *= 2
      
      // 2: make empty spaces
      let emptySpaces = [T?](repeating: nil, count: emptySpaceCapacity)
      
      // 3: add these empty spaces to the front of out array (will trigger shifting under the hood)
      items.insert(contentsOf: emptySpaces, at: 0)
      
      // 4: reposition head to the first item
      head = emptySpaceCapacity
    }
    
    // normal enqueue
    head -= 1
    items[head] = item
  }

  /**
    If you mostly enqueue a lot of elements at the back and mostly dequeue from the front, then you may end up with an array that looks as follows:
   
      [ x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, 1, 2, 3 ]
                                   |                             |  |
                                  ESC                        2*ESC head
   
    when head is > 2*ESC, we reduce spaces to about 25%
   */
  mutating func dequeue() -> T? {
    guard head < items.count, let item = items[head] else {
      return nil
    }
    
    items[head] = nil
    head += 1
    
    // trim empty space if needed after performing the normal dequeue operation
    if emptySpaceCapacity > originalCapacity && head > emptySpaceCapacity*2 {
      // 1: calculate the amount of empty space to remove
      let amountToRemove = emptySpaceCapacity + emptySpaceCapacity/2
      
      // 2: reduce empty spacecs
      items.removeFirst(amountToRemove)
      
      // 3: shrink esc
      emptySpaceCapacity /= 2
      
      // 4: reposition head
      head -= amountToRemove
    }
    
    return item
  }

  mutating func dequeueBack() -> T? {
    return isEmpty ? nil : items.removeLast()
  }
}

var dq = DequeArrayImp<Any>()

dq.enqueue(1)
dq.enqueue("Appppple")
dq.enqueueFront("lemon")

print(dq.front)

_ = dq.dequeue()
_ = dq.dequeueBack()

print(dq.back)
