/**
      _____  __  _____  __     ____
     / ___/ / / /____/ / /    /    \   graph.dart
    / ___/ /_/ /____/ / /__  /  /  /   (c) 2014, FIELD. All rights reserved.
   /_/        /____/ /____/ /_____/    http://www.field.io

   Created by Marcus Wendt on 11/06/2014
   
*/
library graph;

import 'dart:collection' as collection;
import 'dart:mirrors' as mirrors;
import 'dart:math' as math;

import 'package:vector_math/vector_math.dart';
import 'package:randomize/randomize.dart' as rand;

// core library
part 'src/vertex.dart';
part 'src/edge.dart';
part 'src/group.dart';
part 'src/graph.dart';

part 'src/parameters.dart';


// generators
part 'src/generators/tree_params.dart';
part 'src/generators/tree_graph.dart';
part 'src/generators/tree_branch.dart';
part 'src/generators/tree_vertex.dart';

part 'src/generators/platonic_graph.dart';
part 'src/generators/platonic_types.dart';