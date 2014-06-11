part of graph;

// TODO refactor / extract
abstract class Parameters
{
//  reflection based methods to iterate over parameters
}


/** utility class to deal with parameter ranges */
abstract class Range2<V, R extends Range2>
{
  V min_;
  V max_;
  
  Range2(V min, V max) { set(min, max); }
  
  R set(V min, V max) {
    this.min_ = min;
    this.max_ = max;
    return this;
  }
  
  R scale(double scale);
  
  V get();
}

class Range2d extends Range2<double, Range2d> {
  Range2d([double min=0.0, double max=1.0]) : super(min, max);
  scale(double scale) => set(this.min_ * scale, this.max_ * scale);
  get() => rand.d(this.min_, this.max_);
}

class Range2i extends Range2<int, Range2i> {
  Range2i([int min=0, int max=0]) : super(min, max);
  scale(double scale) => set( (this.min_ * scale).toInt(), (this.max_ * scale).toInt());
  get() => rand.i(this.min_, this.max_);
}