import Foundation

/**
 Why Hashable inherit from equalable?
 
 if a == b, then a.hashValue == b.hashValue, but if a.hashValue == b.hashValue, then a may or may not equal b
 */
public struct Edge<T>: Hashable where T: Hashable {
  
  public let from: Vertex<T>
  public let to: Vertex<T>
  
  public let weight: Double?
  
}

extension Edge: CustomStringConvertible {
  
  public var description: String {
    guard let unwrappedWeight = weight else {
      return "\(from.description) -> \(to.description)"
    }
    return "\(from.description) -(\(unwrappedWeight))-> \(to.description)"
  }
  
}
