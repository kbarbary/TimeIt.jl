TimeIt
======

This module exports a `@timeit` macro that works similarly to the `%timeit`
magic in IPython.

Installation:

    julia> Pkg.clone("git://github.com/kbarbary/TimeIt.jl.git")

Usage:

    julia> using TimeIt

    julia> x = rand(1000); y = rand(1000)

    julia> @timeit x .* y

Differences from Python `timeit`:

* This macro doesn't turn off the garbage collector, whereas the
  Python version does. I haven't found consistent timings when turing
  the gc off.

* This macro aims to make the total time between 0.1 and
  1 seconds, whereas the Python version aims at 0.2 to 2 seconds.