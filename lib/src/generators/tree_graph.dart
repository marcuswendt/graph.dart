part of graph;


class TreeGenerator<V extends TreeVertex> = Object with TreeGraphGenerator<V>, TreeBranchGenerator<V>;



/**
 * A graph whose vertices keep a reference to their parent vertex
 */
class TreeGraph<V extends Vertex> extends DirectedGraph<V>
{
  V get root => this["root"].first;
  
  TreeGraph();
  
  createRoot() {
    var groot = group("root", true);
    create([null], "root", [ groot ]);
  }
}

/**
 * Graph Generator
 */
abstract class TreeGraphGenerator<V extends TreeVertex>
{
  Graph generateGraph(TreeGeneratorParameters parms)
  {
    var graph = new TreeGraph<V>();
    
    var npoles = rand.i(parms.poleRange.min_, parms.poleRange.max_);
    var groot = graph.group("root", true);
    var gpoles = graph.group("poles", true);
        
    // create root
    log("generating graph...");
    var root = graph.create([null], "root", [groot, gpoles]);
    
    // create poles
    log("1. poles $npoles");
    for(int i=0; i<npoles; i++) {
      var pole = graph.create([null], "pole $i", [ gpoles ]);
  //      graph.link(root, pole);
    }
    
    // create main branches between root and poles
    var i=0;
    var branchGroups = [];
    log("2. branches ${gpoles.length}");
    for(V pole in gpoles)
    {
      if(pole == root) continue;
      
      // create a branchy node structure of n vertices length starting from root and ending at pole      
      var boptions = parms.mainBranch(i);
      var increment = (i / (gpoles.length - 1.0));
      var theta = (math.PI * 2.0) * (increment + rand.d(-parms.thetaVariance, parms.thetaVariance) * increment);
      root.theta = theta;
  
      log(" - ${boptions.name}");
      var group = generateBranch(graph, root, boptions);
      branchGroups.add(group);
      
      // connect pole with the vertex at the end of this group
      var vertex = group.last;
      pole.parent = vertex;
      pole.theta = pole.parent.theta + rand.d(-parms.thetaVariance, parms.thetaVariance) * math.PI;
      graph.link(vertex, pole);
      
      // make sure pole is part of this group
      group.add(pole);
  
      // might want to set some kind of attribute or group to mark this as main branch
      i++;
    }
    
    // -- SUB BRANCHES --
    // follow each poles branch and create sub branches from here
    i = 0;
    log("3. sub branches ${gpoles.length}");
    for(Group group in branchGroups)
    {       
      // walk along branch and create sub-branches from here
      for(V vertex in group) {
        var soptions = parms.subBranch(i);
        generateBranch(graph, vertex, soptions);
      }
      
      i++;
    }
    
    // apply colors to graph
    graph.matchVertices("sub").forEach((v) {
      v.type = TreeVertex.SUB;
      v.size = 1.0;
      v.color.setGrey(0.45);
    });
    graph.matchVertices("branch").forEach((v) {
      v.type = TreeVertex.BRANCH;
      v.size = 3.0;
      v.color.setGrey(1.0);
    });
    graph.matchVertices("pole").forEach((v) {
      v.type = TreeVertex.POLE;
      v.size = 6.0;
      v.color.setRGB(1.0, 1.0, 0.0);
    });
    graph.matchVertices("root").forEach((v) {
      v.type = TreeVertex.ROOT;
      v.size = 5.0;
      v.color.setRGB(1.0, 0.0, 0.0);
    });
    
    return graph;
  }
  
  generateBranch(graph, root, boptions);
  
  log(String s) => print(s);
}
