import Foundation

func address(o: UnsafeRawPointer) -> Int {
    return Int(bitPattern: o)
}

func addressHeap<T: AnyObject>(o: T) -> Int {
    return unsafeBitCast(o, to: Int.self)
}

// MARK: Array autoresizing when adding and deleting

var arr: [Int] = []

print("\n")
print("---------------- Empty Array -----------")
print(NSString(format: "%p", address(o: &arr)))

print("---------------- adding 1 -----------")
arr.append(1)
print(NSString(format: "%p", address(o: &arr)))

print("---------------- adding 2 -----------")
arr.append(2)
print(NSString(format: "%p", address(o: &arr)))

print("---------------- adding 3 -----------")
arr.append(3)
print(NSString(format: "%p", address(o: &arr)))

print("---------------- adding 4 -----------")
arr.append(4)
print(NSString(format: "%p", address(o: &arr)))


print("---------------- adding 5 -> 9 -----------")
arr.append(contentsOf: [5,6,7,8,9])
print(NSString(format: "%p", address(o: &arr)))

print("---------------- Remove All -----------")
arr.removeAll()
print(NSString(format: "%p", address(o: &arr)))
print("\n")

// Mark: - Copy On Write
// Copy-on write is supported for String and all collection types - Array, Dictionary and Set. Besides that, compiler is free to optimize any struct access and effectively give you copy-on-write semantics, but it is not guaranteed.

/**
 Array:
 At a basic level, Array is just a structure that holds a reference to a heap-allocated buffer containing the elements – therefore multiple Array instances can reference the same buffer. When you come to mutate a given array instance, the implementation will check if the buffer is uniquely referenced, and if so, mutate it directly. Otherwise, the array will perform a copy of the underlying buffer in order to preserve value semantics.https://stackoverflow.com/questions/43486408/does-swift-copy-on-write-for-all-structs
*/
var original = [1,2,3,4]
var copyCat = original

print("\n")
print("---------------- Original array memory address -----------")
print(NSString(format: "%p", address(o: &original)))

print("---------------- Copycat array memory address -----------")
print(NSString(format: "%p", address(o: &copyCat)))

print("---------------- Modifying CopyCat: Add 5 -----------")
copyCat.append(5)
print(NSString(format: "%p", address(o: &copyCat)))
print("\n")


/**
 Struct:
 struct does not support copy on write natively
  https://marcosantadev.com/copy-write-swift-value-types/
 */
struct Dog {
  var name: String
  var age: Int
}

var dog = Dog(name: "Doudou", age: 8)
var copyDog = dog

print("\n")
print("---------------- Original struct memory address -----------")
print(NSString(format: "%p", address(o: &dog)))

print("---------------- Copydog struct address -----------")
print(NSString(format: "%p", address(o: &copyDog)))

print("---------------- Modifying CopyDog: Change name to \"Marko\" -----------")
copyDog.name = "Marko"
print(NSString(format: "%p", address(o: &copyDog)))

