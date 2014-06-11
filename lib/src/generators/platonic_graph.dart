part of graph;


class MeshVertex extends Vertex
{
  Vector3 position;
  int copy;
  MeshVertex(this.position, this.copy);
}

class MeshDescription {
  int nvertices;
  int nfaces;

  List<int> indices;
  List<List<int>> polygons;
  List<List<num>> positions;
}

class PlatonicParameters
{
  MeshDescription type = PlatonicGenerator.TYPE_TETRA; // needs setting!
  Vector3 size = new Vector3.all(1.0);
  bool flip = false;
  
  int copies = 1;
  Vector3 translation = new Vector3.all(1.0);
  Vector3 rotation = new Vector3.all(0.0);
  Vector3 scale = new Vector3.all(0.0);
}


/**
 * Creates a complex mesh from multiple transformed platonic solids 
 */
class PlatonicGenerator {
  // tetrahedron, cube (or hexahedron), octahedron, dodecahedron and icosahedron.
  // faces: tetra=4, hexa=6, octa=8, dodeca=12 and icosa=20
  static final TYPE_TETRA = new TetrahedronMesh();
  static final TYPE_HEXA = new HexahedronMesh();
  static final TYPE_OCTA = new OctahedronMesh();
  static final TYPE_DODECA = new DodecahedronMesh();
  static final TYPE_ICOSA = new IcosahedronMesh();

  static final List<MeshDescription> types = [TYPE_TETRA, TYPE_HEXA, TYPE_OCTA, TYPE_DODECA, TYPE_ICOSA];
  
  static final dualTypes = new Map<MeshDescription, MeshDescription>.fromIterables(
                                   types, [TYPE_TETRA, TYPE_OCTA, TYPE_HEXA, TYPE_ICOSA, TYPE_DODECA]);  
  
  
  DirectedGraph<MeshVertex> generateShape(PlatonicParameters parms) {
    var graph = new DirectedGraph<MeshVertex>();

    var rotationFlip = parms.flip ? math.PI : 0.0;
    
    for(var c=0; c<parms.copies; c++) {
      var cd = c.toDouble();
      
      // setup up transformation matrix
      Matrix4 tx = new Matrix4.identity();
      tx.setTranslation(parms.translation * (c - parms.copies/ 2.0).toDouble());
      
      var r = new Matrix4.identity();
      r.setRotationX(parms.rotation.x * cd);
      tx.multiply(r);

      r.setRotationY(parms.rotation.y * cd);
      tx.multiply(r);
      
      r.setRotationZ(parms.rotation.z * cd + rotationFlip);
      tx.multiply(r);
      
      tx.scale(parms.size.x, parms.size.y, parms.size.z);
      tx.scale(1.0 + parms.scale.x * cd, 1.0 + parms.scale.y * cd, 1.0 + parms.scale.z * cd);
      
      // create transformed vertices
      for (var i = 0; i < parms.type.nvertices; i++) {
        var a = parms.type.positions[i];
        var p = new Vector3(a[0].toDouble(), a[1].toDouble(), a[2].toDouble());
        tx.transform3(p);        
        graph.create([p, c]);
      }
  
      // create edges
      var npolygons = parms.type.polygons.length;
      int offset = parms.type.nvertices * c;
      
      for (var i = 0; i < npolygons; i++) {
        var poly = parms.type.polygons[i];
        var vertex = (int j) => offset + parms.type.indices[poly[j]];
        
        for(var j=0; j<poly.length; j++) {
          graph.link(vertex(j), vertex((j + 1) % poly.length));  
        }
      }
    }

    return graph;
  }
}
