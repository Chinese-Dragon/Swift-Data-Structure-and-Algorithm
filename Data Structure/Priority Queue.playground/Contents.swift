import Foundation

// associated type: https://blog.bobthedeveloper.io/generic-protocols-with-associated-type-7e2b6e079ee2

/**
 There are different ways to implement priority queues:
 
 As a sorted array. The most important item is at the end of the array. Downside: inserting new items is slow because they must be inserted in sorted order.
 
 As a balanced binary search tree. This is great for making a double-ended priority queue because it implements both "find minimum" and "find maximum" efficiently.
 
 As a heap. The heap is a natural data structure for a priority queue. In fact, the two terms are often used as synonyms. A heap is more efficient than a sorted array because a heap only has to be partially sorted. All heap operations are O(log n).
 */
protocol PriorityQueue {
  associatedtype anyType
  var isEmpty: Bool { get }
  var count: Int { get }
  func peek() -> anyType?
  mutating func enqueue(element: anyType)
  mutating func dequeue() -> anyType?
  mutating func changePriority(index i: Int, value: anyType)
}

struct PriorityQueueHeapImp<T>: PriorityQueue {
  private var heap: Heap<T>
  
  public init(sort: @escaping (T, T) -> Bool) {
    self.heap = Heap(sort: sort)
  }
  
  var isEmpty: Bool {
    return heap.isEmpty
  }
  var count: Int {
    return heap.count
  }
  
  func peek() -> T? {
    return heap.peek()
  }
  
  mutating func enqueue(element: T) {
    heap.insert(element)
  }
  
  mutating func dequeue() -> T? {
    return heap.remove()
  }
  
  mutating func changePriority(index i: Int, value: T) {
    heap.replace(index: i, value: value)
  }
}

// when we provide a comparator, we MUST define the type to allow swift infer the generic type
var pq = PriorityQueueHeapImp<Int>(sort: <)
pq.enqueue(element: 1)
pq.enqueue(element: 2)
pq.enqueue(element: 99)
pq.enqueue(element: 10101)
pq.enqueue(element: -34)

print(pq.peek() ?? -999)
