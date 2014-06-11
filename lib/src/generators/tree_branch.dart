part of graph;


abstract class TreeBranchGenerator<V extends TreeVertex>
{
  /**
   * function to create vertex branches of various types
   * controlling the randomness and behaviour of branching is quite subtle but has a strong 
   * influence on the resulting form of the graph.
   * e.g. amount of expansion with depth
   */
  Group generateBranch(DirectedGraph<V> graph, V root, BranchParameters parms)
  {
    var group = graph.group(parms.name, true);
    var j=0;
    
    var recurse;
    recurse = (V parent, int depth) {
      
      // stop branching
      if(depth > 1)
        if(!rand.flipCoin(parms.branchChance)) return;
      
      // calculate number of sub branches (= children)
      var rangeMin = parms.branchRange.min_;
      var rangeMax = parms.branchRange.max_ + (parms.branchDepthScalar * depth).toInt();
      var nbranches = rand.i(rangeMin, rangeMax);
      nbranches = math.min(nbranches, parms.branchMax);
      
      // calculate initial angle
      var alphaStep = ((math.PI * 2.0) / nbranches.toDouble()) * parms.thetaRange * parms.thetaDirection;
      
      // depth expansion/ contraction
      var normDepth = depth / parms.generations.toDouble();
      alphaStep = lerp(alphaStep, alphaStep * parms.thetaDepthScalar, normDepth);
      
      var alphaOffset = nbranches * alphaStep * -.5;
      
      for(int i=0; i<nbranches; i++) {
        var child = graph.create([parent], "${parms.name}.$j", [ group ]);
        child.theta = parent.theta + alphaOffset + alphaStep * i; 
        child.length = rand.d(parms.length.min_, parms.length.max_);
        
        j++;
        graph.link(parent, child);
        if(depth < parms.generations)
          recurse(child, depth + 1);
      }
    };
    recurse(root, root.depth());
    
    return group;
  }
}