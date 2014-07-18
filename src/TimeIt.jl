module TimeIt

export @timeit

macro timen(ex, n)
    quote
        local total = 0.0
        for i = 1:$(esc(n))
            # already warm
            total += @elapsed $(esc(ex))
        end
        total / $(esc(n))
    end
end

macro timeit(ex)
    quote
        local val = $(esc(ex))  # Warm up
        t = zeros(3)

        # Determine number of loops so that total time > 0.1s.
        n = 1
        for i = 0:9
            n = 10^i
            t[1] = @timen $(esc(ex)) n
            t[1] * n > 0.1 && break
        end

        # Two more production runs.
        for i = 2:3
            t[i] = @timen $(esc(ex)) n
        end
        best = minimum(t)

        # Format to nano-, micro- or milliseconds.
        if best < 1e-6
            best *= 1e9
            pre = "n"
        elseif best < 1e-3
            best *= 1e6
            pre = "\u00b5"
        elseif best < 1
            best *= 1e3
            pre = "m"
        else
            pre = ""
        end
        @printf "%d loops, best of 3: %4.2f %ss per loop\n" n best pre
    end
end

end  # module
