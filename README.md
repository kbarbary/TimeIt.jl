TimeIt
======

This module exports a `@timeit` macro that works similarly to the `%timeit`
magic in IPython.

Installation
------------

```julia
julia> Pkg.clone("git://github.com/kbarbary/TimeIt.jl.git")
```

Usage
-----

```julia
julia> using TimeIt

julia> x = rand(10000); y = rand(10000);

julia> @timeit x .* y;
10000 loops, best of 3: 13.71 µs per loop
```

The time per loop in seconds is returned, so you can do `t = @timeit x .* y`
to record the timing.

Caveats
-------

*TL;DR: For a more rigorous benchmarking experience, check out
 [Benchmarks.jl](https://github.com/johnmyleswhite/Benchmarks.jl).*

1. **The macro will give inaccurate results for expressions that take less than about 1 µs.**

   `@timeit` wraps the supplied expression in a loop with an appropriate number of iterations and times the execution. For example, `@timeit x .* y` becomes something like

   ```julia
   # record start time
   for i in 1:10000
       val = x .* y
   end
   # record end time
   ```

   As such, when you run `@timeit x .* y` in global scope (at
   the REPL), you're running a loop in global scope, which has a
   non-negligible overhead. Even a do-nothing expression takes a
   minimum of about 100 ns per iteration:

   ```
   julia> @timeit nothing
   1000000 loops, best of 3: 98.05 ns per loop
   ```

   For expressions that take more than approximately 1µs, this
   overhead becomes negligible.

2. **All typical Julia performance gotchas about global scope still apply.**

   Again, because the loop is in global scope, complex expressions will have
   poor performance. Consider an alternative way to compute `x .* y`:

   ```julia
   julia> @timeit [x[i] * y[i] for i=1:length(x)]
   100 loops, best of 3: 3.06 ms per loop
   ```

   Placing this expression in a function results in a factor of 100 speed-up:

   ```julia
   julia> f(x, y) = [x[i] * y[i] for i=1:length(x)]
   f (generic function with 1 method)

   julia> @timeit f(x, y)
   10000 loops, best of 3: 32.44 µs per loop
   ```
