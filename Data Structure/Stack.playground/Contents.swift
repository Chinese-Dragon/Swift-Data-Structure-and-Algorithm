import Foundation

func address(o: UnsafeRawPointer) -> Int {
  return Int(bitPattern: o)
}

func addressHeap<T: AnyObject>(o: T) -> Int {
  return unsafeBitCast(o, to: Int.self)
}

/*
 Protocal with generic type:
 https://blog.bobthedeveloper.io/generic-protocols-with-associated-type-7e2b6e079ee2
**/

/*
 Swift Protocols: Properties distinction:
 https://medium.com/@chetan15aga/swift-protocols-properties-distinction-get-get-set-32a34a7f16e9
**/
protocol Stack {
  associatedtype anyType
  var items: [anyType] { get }
  var isEmpty: Bool { get }
  var count: Int { get }
  var top: anyType? { get }
  mutating func push(_ item: anyType)
  mutating func pop() -> anyType?
}


/*
 The default memberwise initializer for a structure type is considered private if any of the structure’s stored properties are private. Likewise, if any of the structure’s stored properties are file private, the initializer is file private. Otherwise, the initializer has an access level of internal.
 ---------------------------------------------------
 e.g
 struct Stk {
 private var array: [String] = []
 var name: String
 }
 There is no default initializer because not all stored property have default values. Memeberwise initializer is only accessable from inside because var array is private
 -------------------------------------------------------
 
 NOETS: That's why if items is private, the memberwise initializer will not be accessable using from outside (defeat the purpose of having initializer LOL)
 **/

struct StackArrayImp<T>: Stack {
  /*
   we can not have property as private in protocol. If we want the property to be private in implemetation, we can only define as private set but
   internal get
  **/
  private(set) var items: [T]
  
  init() {
    self.items = []
  }
  
  var isEmpty: Bool {
    return items.isEmpty
  }
  
  var count: Int {
    return items.count
  }
  
  var top: T? {
    return items.last
  }
  
  mutating func push(_ item: T) {
    items.append(item)
  }
  
  mutating func pop() -> T? {
    return items.removeLast()
  }
}

extension StackArrayImp: CustomStringConvertible {
  var description: String {
    let topDivider = "---Stack---\n"
    let bottomDivider = "\n-----------\n"
    
    let stackElements = items.map { "\($0)" }.reversed().joined(separator: "\n")
    return topDivider + stackElements + bottomDivider
  }
}

var stack = StackArrayImp<Any>()

stack.push("haha")
stack.push(1)
stack.push(0.99)
stack.push([1,2,3,4])

print(stack.description)


