using Thebes, Luxor

function makecube()

    cube = [
    Point3D(1,   1, -1),
    Point3D(1,  -1, -1),
    Point3D(-1, -1, -1),
    Point3D(-1,  1, -1),
    Point3D(1,   1,  1),
    Point3D(1,  -1,  1),
    Point3D(-1, -1,  1),
    Point3D(-1,  1,  1)]

    r = Point3D[]

    for e in [
        [1, 2], [2, 3], [3, 4], [4, 1],
        [5, 6], [6, 7], [7, 8], [8, 5],

        [1, 5], [5, 8], [8, 4], [4, 1],
        [1, 2], [2, 6], [6, 5], [5, 1],
        [3, 2], [2, 6], [6, 7], [7, 3],
        [4, 8], [8, 7], [7, 3], [3, 4],
        ]
        push!(r, cube[e][1])
        push!(r, cube[e][2])
    end
    return r
end

@draw begin
    setline(1.5)
    background("midnightblue")
    sethue("darkorange")
    eyepoint(Point3D(500, 500, 500))
    perspective(0)
    for θ in 0:π/48:4π
        p = Point3D(100cos(θ), 100sin(θ), 20θ)

        #=
        pin(p, gfunction = (p3, p2) -> begin
            d = distance(p3, eyepoint())
            circle(p2, rescale(d, 0, 300, 20, 5), :fill)
        end
        )
        =#

        #=
        pin(p, Point3D(50cos(θ), 50sin(θ), p.z), gfunction = (p3s, p2s) -> begin
            line(p2s..., :stroke)
        end)
        =#

        # pin(p, between(p, eyepoint(), 0.8))

        helix = [Point3D(100cos(θ), 100sin(θ), 20θ) for θ in 0:π/12:4π]
        eyepoint(Point3D(120, 120, 120))
        a_box =
        pin(helix,
        gfunction = (p3list, p2list) -> prettypoly(p2list, :stroke, () ->
        begin

            randomhue()
            circle(O, 2, :fill)
        end)
        )
    end

    axes3D()

    setline(0.5)

    #draw cubes, moving each one and scaling it
    for x in -200:40:200
        for y in -200:40:200
            randomhue()
            pin(moveby!(15makecube(), Point3D(x, y, 0)))
        end
    end



end
