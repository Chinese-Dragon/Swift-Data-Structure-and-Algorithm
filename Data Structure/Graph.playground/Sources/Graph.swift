import Foundation

public class AbstractGraph<T>: CustomStringConvertible where T: Hashable {
  
  public required init() {}
  
  public required init(fromGraph graph: AbstractGraph<T>) {
    for edge in graph.edges {
      let from = createVertex(edge.from.data)
      let to = createVertex(edge.to.data)
      
      addDirectedEdge(from, to: to, withWeight: edge.weight)
    }
  }
  
  public var description: String {
    fatalError("abstract property accessed")
  }
  
  public var vertices: [Vertex<T>] {
    fatalError("abstract property accessed")
  }
  
  public var edges: [Edge<T>] {
    fatalError("abstract property accessed")
  }
  
  // Adds a new vertex to the matrix.
  // Performance: possibly O(n^2) because of the resizing of the matrix.
  public func createVertex(_ data: T) -> Vertex<T> {
    fatalError("abstract function called")
  }
  
  public func addDirectedEdge(_ from: Vertex<T>, to: Vertex<T>, withWeight weight: Double?) {
    fatalError("abstract function called")
  }
  
  public func addUndirectedEdge(_ vertices: (Vertex<T>, Vertex<T>), withWeight weight: Double?) {
    fatalError("abstract function called")
  }
  
  public func weightFrom(_ sourceVertex: Vertex<T>, to destinationVertex: Vertex<T>) -> Double? {
    fatalError("abstract function called")
  }
  
  public func edgesFrom(_ sourceVertex: Vertex<T>) -> [Edge<T>] {
    fatalError("abstract function called")
  }
}
