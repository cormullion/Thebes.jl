using Thebes, Luxor

function makemobius(;
        w = π/10, # "width"
        stepsacross=4, # steps across the band
        stepsaround=150) # steps round the band
    x(u, v) = (1 + (v/2 * cos(u/2))) * cos(u)
    y(u, v) = (1 + (v/2 * cos(u/2))) * sin(u)
    z(u, v) = v/2 * sin(u/2)
     # v goes across
    # u goes round
    st = 2π/stepsaround
    Δ  = 2w/stepsacross
    result = Vector{Vector{Point3D}}()
    for i in 1:stepsaround
        u = (i - 1) * st
        for j in 1:stepsacross
            v = -w + (j - 1) * Δ
            p1 = Point3D(x(u,      v + Δ), y(u,      v + Δ), z(u,      v + Δ))
            p2 = Point3D(x(u + st, v + Δ), y(u + st, v + Δ), z(u + st, v + Δ))
            p3 = Point3D(x(u + st, v),     y(u + st, v),     z(u + st, v))
            p4 = Point3D(x(u,      v),     y(u,      v),     z(u,      v))
            push!(result, [p1, p2, p3, p4])
        end
    end
    return result
end

@drawsvg begin
    background("black")
    setline(0.5)
    eyepoint(300, 300, 300)
    perspective(1500)
    mb = makemobius(w = π/3, stepsacross=6, stepsaround = 50)
    for p in mb
        sethue([Luxor.julia_green, Luxor.julia_red,Luxor.julia_purple, Luxor.julia_blue][rand(1:end)])
        pin(60p, gfunction  = (p3l, p2l) -> begin
            setopacity(0.85)
            randomhue()
            poly(p2l, :fillpreserve, close=true)
            setopacity(1)
            sethue("white")
            strokepath()
        end)
    end
end
