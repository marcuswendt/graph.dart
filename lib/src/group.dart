part of graph;

class Group<V extends Vertex> extends collection.ListBase<V> 
{
  String name;
  Graph<V> graph;
  List<V> data = [];
  
  Group(this.graph, this.name);
    
  operator [](int i) => data[i];
  operator []=(int i, V vertex) => data[i] = vertex;
  
  int get length => data.length;
  void set length(int length) { data.length = length; }
}
