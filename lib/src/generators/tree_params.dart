part of graph;


class BranchParameters
{
  // general tree parameters
  String name = "branch";
  int generations = 3;
  
  // branch number parameters
  double branchChance = 0.75; // chance of creating a new branch
  Range2i branchRange = new Range2i().set(1, 3);
  double branchDepthScalar = 1.0;
  int branchMax = 10;
  
  // branch angle (theta) parameters
  int thetaDirection = rand.flipCoin() ? -1 : 1;
  double thetaRange = 1.0; 
  Range2d thetaRand = new Range2d().set(0.0, 1.0);
  double thetaDepthScalar = 1.0; // < 1 become narrower with depth, > 1 become wider with depth
  
  // branch length parameters
  Range2d length = new Range2d().set(1.0, 1.0);
}


/** bundles all option sets for this film together */
class TreeGeneratorParameters
{
  double genscale = 1.0;

  Range2i get poleRange => new Range2i().set(3, 7).scale(genscale);
  
  double thetaVariance = 0.1; // the smaller the more evenly spaced the branches are
  
  TreeGeneratorParameters();
  
  BranchParameters mainBranch(int i) {
    var p = new BranchParameters();
    p.name = "branch $i";
    p.generations = rand.i(3, (5 * genscale).toInt());
    p.branchChance = .75;
    p.branchRange.set(1, 3);
    p.branchDepthScalar = 0.1;
    p.thetaRange = .1;
    p.length.set(1.25, 2.0);
    return p;
  }
  
  BranchParameters subBranch(int i) {
    var p = new BranchParameters();
    p.name = "sub $i";
    p.generations = rand.i(2, (5 * genscale).toInt());
    p.branchChance = .85;
    p.branchRange.set(1, 2);
    p.branchDepthScalar = rand.d(1.0, 2.0);
    p.thetaRange = .25;
    p.thetaDepthScalar = 0.9;
    p.length.set(0.75, 3.0);
    return p;
  }
}

