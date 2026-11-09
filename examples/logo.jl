using Thebes, Luxor, Colors

include(dirname(pathof(Thebes)) * "/../data/moreobjects.jl")

function lighten(col::Colorant, f)
    c = convert(RGB, col)
    return RGB(f * c.r, f * c.g, f * c.b)
end

function main()
    cols = [Luxor.julia_blue, Luxor.julia_purple, Luxor.julia_green, Luxor.julia_red]
    eyepoint(0, 100, 300)
    perspective(320)
    Drawing(500, 500, "/tmp/thebeslogo.png")
    origin()
    squircle(O, 240, 240, :clip, rt = 0.3)
    background("midnightblue")

    sethue(0.0, 0.3, 0.5)
    circle(O + (0, 850), 800, :fill)

    object = make(rhombitruncated_icosidodecahedron, "solid")
    scaleby!(object, 180, 180, 180)
    rotateby!(object, π / 3, 0, 0)
    sortfaces!(object, eyepoint = eyepoint())

    for (n, f) in enumerate(object.faces)
        pts3D = object.vertices[f]
        pts2D = project.(pts3D)
        sethue(cols[mod1(object.labels[n], end)])
        pc = polycentroid(pts2D)
        setblend(
            blend(
                pc, 0,
                pc, 80,
                lighten(getcolor(), 1.5),
                getcolor(),
            )
        )

        mesh1 = mesh(
            box(BoundingBox(pts2D)), [
                RGBA(0.8, 0.2, 0.5, 0.9),
                RGBA(0.8, 0.7, 0.5, 0.5),
                RGBA(0.8, 0.4, 0.4, 0.6),
                RGBA(0.8, 0.3, 0.9, 0.99),
            ]
        )
        setmesh(mesh1)

        poly(pts2D, :fillpreserve, close = true)

        # lines
        setline(2)
        sethue("gold")
        strokepreserve()

        setline(1)
        sethue("white")
        strokepath()
    end
    finish()
    return preview()
end

main()
