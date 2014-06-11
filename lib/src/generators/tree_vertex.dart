part of graph;


/**
 * Custom vertex type used in tree graph animations
 */
class TreeVertex<V extends TreeVertex> extends Vertex<V>
{
  V parent;
  
  static const int SUB = 0;
  static const int BRANCH = 1;
  static const int POLE = 2;
  static const int ROOT = 3;
  
  int type = SUB;
  bool isActive = false;  
  
  double length = 1.0; // scalar applied to all spring lengths
  double theta = 0.0;
  double size = 1.0; // point size
  
  TreeVertex(V parent) { this.parent = parent; }
  
  int depth() => (parent == null) ? 0 : parent.depth() + 1;
  
  String toString() => "$name (weight: $weight)";
}

