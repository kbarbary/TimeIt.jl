TimeIt
======

This module exports a `@timeit` macro that works similarly to the `%timeit`
magic in IPython.

Installation:

```julia
julia> Pkg.clone("git://github.com/kbarbary/TimeIt.jl.git")
```

Usage:

```julia
julia> using TimeIt

julia> x = rand(10000); y = rand(10000);

julia> @timeit x .* y;
10000 loops, best of 3: 58.59 µs per loop
```

The time per loop in seconds is returned, so you can do `t = @timeit x .* y`
to record the timing.

Differences from IPython `%timeit`:

* This macro doesn't turn off the garbage collector, whereas the
  Python version does. I haven't found consistent timings when turing
  the gc off.

* This macro aims to make the total time between 0.1 and
  1 seconds, whereas the Python version aims at 0.2 to 2 seconds.