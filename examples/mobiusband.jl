using Thebes, Luxor

function makemobius()
    x(u, v) = (1 + (v/2 * cos(u/2))) * cos(u)
    y(u, v) = (1 + (v/2 * cos(u/2))) * sin(u)
    z(u, v) = v/2 * sin(u/2)
    # v goes across
    # u goes round
    w = .5
    st = 2π/200
    Δ = .05
    result = []
    for u in 0:st:2π-st
        for v in -w:Δ:w
            p1 = Point3D(x(u,      v + Δ),   y(u,      v + Δ),     z(u,       v + Δ))
            p2 = Point3D(x(u + st, v + Δ),   y(u + st, v + Δ),     z(u  + st, v + Δ))
            p3 = Point3D(x(u + st, v),       y(u + st, v),         z(u + st,  v))
            p4 = Point3D(x(u,      v),       y(u,      v),         z(u,       v))
            push!(result, [p1, p2, p3, p4])
        end
    end
    return result
end

@svg begin
    background("black")
    setline(0.2)
    eyepoint(300, 300, 300)
    perspective(1500)
    mb = makemobius()
    for p in mb
        sethue([Luxor.julia_green, Luxor.julia_red,Luxor.julia_purple, Luxor.julia_blue][rand(1:end)])
        pin(100p, gfunction  = (p3l, p2l) -> begin
            setopacity(0.85)
            sethue("grey20")
            poly(p2l, :fillpreserve, close=true)
            setopacity(1)
            sethue("white")
            strokepath()
        end)
    end
end 1200 1200 "/tmp/mo.svg"
