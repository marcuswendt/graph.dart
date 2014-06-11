part of graph;


/**
 * 
 */
class Vertex<V extends Vertex> 
{
  Graph<V> graph;
  String name;
  
  /** keep this simple, so overriding classes dont require extensive constructors */
  Vertex();
  
  /** called when this vertex is added to the graph */
  attach(Graph<V> graph, String name) {
    this.graph = graph;
    this.name = name;
  }
  
  String toString() => "$name($weight)";
  
  List<V> neighbours() => graph.neighbours(this);
  
  /** returns the number of neightbours */
  int get width => neighbours().length;
  
  /** returns the total number of vertices connected to this one */
  int get weight {
    var w = 0;
    graph.recurse(this, (vertex, depth) => w++);
    return w;
  }
}



