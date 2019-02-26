import Foundation

public struct Vertex<T>: Hashable where T: Hashable {
  
  public var data: T
  public let index: Int
  
}

extension Vertex: CustomStringConvertible {
  
  public var description: String {
    return "\(index): \(data)"
  }
  
}
