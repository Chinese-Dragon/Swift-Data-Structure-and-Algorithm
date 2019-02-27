import UIKit

/**
 Let V be the number of vertices in the graph, and E the number of edges. Then we have:
 
  Operation         Adjacency List      Adjacency Matrix
  Storage Space     O(V + E)            O(V^2)
  Add Vertex        O(1)                O(V^2)
  Add Edge          O(1)                O(1)
  Check Adjacency   O(V)                O(1)
 
 "Checking adjacency" means that we try to determine that a given vertex is an immediate neighbor of another vertex. The time to check adjacency for an adjacency list is O(V), because in the worst case a vertex is connected to every other vertex.
 e.g

 ajacency list: A -> [B -> C -> D -> E -> F -> G]
 
 if we want to check if G is A's immediate neighbor, we have to traverse A's adjacent list to see if G is in the list O(V)
 
*/

// Example of a simple graph: https://github.com/raywenderlich/swift-algorithm-club/blob/master/Graph/Images/Demo1.png

let graph = AdjacencyListGraph<Int>()

let v1 = graph.createVertex(1)
let v2 = graph.createVertex(2)
let v3 = graph.createVertex(3)
let v4 = graph.createVertex(4)
let v5 = graph.createVertex(5)

graph.addDirectedEdge(v1, to: v2, withWeight: 1.0)
graph.addDirectedEdge(v2, to: v5, withWeight: 3.2)
graph.addDirectedEdge(v2, to: v3, withWeight: 1.0)
graph.addDirectedEdge(v3, to: v4, withWeight: 4.5)
graph.addDirectedEdge(v4, to: v1, withWeight: 2.8)

print(graph.description)

