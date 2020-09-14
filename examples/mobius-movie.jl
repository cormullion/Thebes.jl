using Thebes, Luxor, ColorSchemes

function makemobius()
    x(u, v) = (1 + (v/2 * cos(u/2))) * cos(u)
    y(u, v) = (1 + (v/2 * cos(u/2))) * sin(u)
    z(u, v) = v/2 * sin(u/2)
    # v goes across
    # u goes round
    w = 1
    st = 2π/50
    Δ = .05
    result = []
    for u in 0:st:2π# -st
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

function frame(scene, framenumber, mobius)
    background("black")
    # flyaround
    theta = rescale(framenumber, 1, scene.framerange.stop, 0, 2pi)
    perspective(400)
    eyepoint(Point3D(250(cos(theta)), 250(sin(theta)), 200))
    setline(.5)
    for (n, p) in enumerate(mobius)
        sethue(get(ColorSchemes.cyclic_wrwbw_40_90_c42_n256_s25, n/length(mobius)))
        pin(100p, gfunction  = (p3l, p2l) -> begin
            poly(p2l, :stroke, close=true)
        end)
    end
end

function  main()
    width, height = (800, 400)
    mobiusmovie = Movie(width, height, "mobiusmovie")

    mb = makemobius()
    gif = animate(mobiusmovie, [
        Scene(mobiusmovie, (s, f) -> frame(s, f, mb), 1:100)
        ],
        creategif=true,
        framerate=20,
        pathname="/tmp/mobiusmovie.gif")
    return gif
end

main()
