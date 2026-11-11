using Thebes, Luxor, Colors

include(dirname(pathof(Thebes)) * "/../data/moreobjects.jl")

function lighten(col::Colorant, f)
    c = convert(RGB, col)
    return RGB(f * c.r, f * c.g, f * c.b)
end

function main()
    cols = [Luxor.julia_blue, Luxor.julia_purple, Luxor.julia_green, Luxor.julia_red]
    eyepoint(0, 100, 300)
    perspective(300)
    Drawing(500, 500, dirname(pathof(Thebes)) * "/../docs/src/assets/logo.svg")
    origin()
    squircle(O, 240, 240, :clip, rt = 0.3)
    background("midnightblue")

    sethue(0.0, 0.3, 0.5)
    circle(O + (0, 850), 800, :fill)

    object = make(rhombitruncated_icosidodecahedron, "solid")
    scaleby!(object, 180, 180, 180)
    rotateby!(object, π / 3.1, 0, 0)
    sortfaces!(object, eyepoint = eyepoint())


    for (n, f) in enumerate(object.faces)
        pts3D = object.vertices[f]
        pts2D = project.(pts3D)
        sethue(cols[mod1(object.labels[n], end)])
        pc = polycentroid(pts2D)
        setblend(
            blend(
                pc, 0,
                pc, 90,
                lighten(getcolor(), 1.8),
                lighten(getcolor(), 0.7),
            )
        )

        poly(pts2D, :fillpreserve, close = true)

        # lines
        setline(1)
        sethue("gold")
        strokepreserve()

        setline(0.5)
        sethue("white")
        strokepath()
    end

    setline(3)
    sethue("white")
    setopacity(0.1)
    for (n, f) in enumerate(object.faces)
        pts3D = object.vertices[f]
        pts2D = project.(pts3D)
        pc = polycentroid(pts2D)
        poly(pts2D, :stroke, close = true)
    end
    finish()
    return preview()
end

main()
