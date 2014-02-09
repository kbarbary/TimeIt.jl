module TimeIt

export @timeit

macro timen(ex, n)
    quote
        local t0 = time_ns()
        for i = 1:$(esc(n))
            local val = $(esc(ex))
        end
        local t1 = time_ns()
        (t1 - t0) / 1.e9
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
            if t[1] > 0.1
                break
            end
        end

        # Two more production runs.
        for i = 2:3
            t[i] = @timen $(esc(ex)) n
        end
        best = minimum(t) / n

        # Format to nano-, micro- or milliseconds.
        if best < 1e-6
            best *= 1e9
            pre = "n"
        elseif best < 1e-3
            best *= 1e6
            pre = "\u00b5"
        else
            best *= 1e3
            pre = "m"
        end
        @printf "%d loops, best of 3: %4.2f %ss per loop\n" n best pre
    end
end

end  # module
