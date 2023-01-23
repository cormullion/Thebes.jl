using Thebes, Luxor

include(dirname(pathof(Thebes)) * "/../data/moreobjects.jl")

function main()
    cols = [Luxor.julia_blue, Luxor.julia_purple, Luxor.julia_green, Luxor.julia_red]
    eyepoint(0, 100, 300)
    perspective(300)
    Drawing(500, 500, "/tmp/thebeslogo.svg")
    origin()
    squircle(O, 240, 240, :clip, rt=0.3)
    background("midnightblue")

    sethue(0.0, 0.3, 0.5)
    circle(O + (0, 850), 800, :fill)

    object = make(rhombitruncated_icosidodecahedron, "solid")
    scaleby!(object, 180, 180, 180)
    rotateby!(object, π/3, 0, 0)
    sortfaces!(object, eyepoint=eyepoint())

    for (n, f) in enumerate(object.faces)
        pts3D = object.vertices[f]
        pts2D = project.(pts3D)
        sethue(cols[mod1(object.labels[n], end)])
        setopacity(0.8)
        poly(pts2D, :fillpreserve, close=true)
        setline(6)
        sethue("gold")
        strokepreserve()
        setline(2)
        sethue("black")
        strokepreserve()
        setline(1)
        sethue("white")
        strokepath()
    end
    finish()
    preview()
end

main()
