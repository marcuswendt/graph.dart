part of graph;


/**
 * An undirected graph implementation
 * 
 */
class Graph<V extends Vertex>
{
  static const String DEFAULT_GROUP = "default";
  
  Map<String, Group<V>> groups = new Map();
  Group<V> vertices;
  List<Edge> edges = [];
  
  mirrors.ClassMirror clazz;
  
  Graph() {
    clazz = mirrors.reflectClass(V);
    vertices = group(DEFAULT_GROUP, true);
  }
  
  /** adds a Vertex to this Graph */
  V create([List arguments, String name="Vertex", List<Group<V>> vertexGroups_]) {
    // create new vertex
    if(arguments == null) arguments = [];
    V vertex = clazz.newInstance(new Symbol(""), arguments).reflectee;
    vertex.attach(this, name);
    
    // make sure vertex always gets added to the default group
    if(vertexGroups_ == null) { 
      vertexGroups_ = [ vertices ];
      
    } else {
      if(!vertexGroups_.contains(vertices))
        vertexGroups_.add(vertices);
    }
    
    // add vertex to groups    
    for(Group<V> g in vertexGroups_) {
//      print("adding ${vertex.name} to ${g.name}");
      g.add(vertex);
    }
  
    return vertex;
  }
  
  /** returns the group with the given name, optionally creates it if it doesnt exist yet */
  Group group(String name, [bool create=true]) {
    var g = groups[name];
    if(g == null && create) {
      g = new Group(this, name);
      groups[name] = g;
    }
    return g;
  }
  
  operator [](String name) => group(name);
  
  /** returns a list of all groups matching the given pattern */
  List<Group<V>> matchGroup(String pattern) {
    var result = [];
    for(Group g in groups.values)
      if(g.name.startsWith(pattern))
        result.add(g);
    return result;
  }
  
  /** returns a list of all vertices matching the given pattern */
  List<V> matchVertices(String pattern) {
    var result = [];
    for(Group g in matchGroup(pattern))
      result.addAll(g);
    return result;
  }
  
  /** creates a new Edge connection between Vertex A-B */
  link(dynamic a, dynamic b) {
    // allow arguments to be either vertex indices (ints) or vertices
    var a_ = (a is int) ? vertices[a] : a;
    var b_ = (b is int) ? vertices[b] : b;

    // check if edge already exists
    Edge duplicate = null;
    for(var edge in edges) {
      if( (edge.a == a_ || edge.a == b_) && 
          (edge.b == a_ || edge.b == b_)) {
        duplicate = edge;
      }
    }
    
    if(duplicate != null) return duplicate;
    
    // otherwise create a new edge
    var edge = new Edge(a_, b_);
    edges.add(edge);
    return edge;
  }
  
  /** lists all vertices connected to the given input vertex */
  List<V> neighbours(V vertex)
  {
    List<V> result = [];
    for(Edge e in edges) {
      if(e.a == vertex)
        result.add(e.b);
      if(e.b == vertex)
        result.add(e.a);
    }
    return result;
  }
  
  /** recursively follows the connections from the given root vertex */
  recurse(V root, Function action) 
  {
    List<V> visits = [];
    
    var _recurse;
    _recurse = (V vertex, int depth) {
      // make sure we dont apply an action twice (circular dependencies)
      if(visits.contains(vertex)) return;
      visits.add(vertex);
      
      // execute action on vertex
      action(vertex, depth);
      
      // iterate over all neighbours
      depth++;
      for(V neighbour in neighbours(vertex))
        _recurse(neighbour, depth);     
    };
    
    _recurse(root, 0);    
  }
  
  merge(Graph<V> other) 
  {
    groups.addAll(other.groups);
    vertices.addAll(other.vertices);
    edges.addAll(other.edges);
    return this;  
  }
  
  String toStringAsTree(V root)
  {
    var s = "";
    recurse(root, (vertex, depth) {
      var l = "";
      for(int i=0; i<depth; i++)
        l += "-- ";
      l += " $vertex\n";
      s += l;
    });
    return s;
  }
}


/**
 * A directed graph
 */
class DirectedGraph<V extends Vertex> extends Graph<V>
{
   List<V> neighbours(V vertex)
   {
     List<V> result = [];
     for(Edge e in edges) {
       if(e.a == vertex)
         result.add(e.b);
     }
     return result;
   }
}
