using Luxor, Thebes


@svg begin
    background("ivory")
    tiles = Tiler(800, 800, 5, 5, margin=25)
    setopacity(0.95)
    setlinejoin("bevel")
    persp = Projection(Point3D(10, 10, 10))
    object = make(Cube)
    object = make(Carpet)
    object = make(Tetrahedron)
    # object = make(AxesWire)

    changescale!(object, 20, 20, 20)

    # changescale!(axes3D, 1, 1, 1)

    # rotateto!(pyramid, 0, 0, pi/4)
    move!(object, 0, 0, 0)

#    verts, faces = modeltopoly(cube, persp)
#    drawmodel(cube, persp, ["red", "green", "blue"], :fill)

#    sortfaces!(cube)
#    verts, faces = modeltopoly(cube, persp)
#    drawmodel(cube, persp, ["red", "green", "blue"], :fill)

    for (pos, n) in tiles
        @layer begin
        translate(pos)
        sortfaces!(object)

        persp = Projection(Point3D(5, 5, 2n))
        verts, faces = modeltopoly(object, persp)


        setline(0.2)

        drawmodel(object, persp, ["red", "green", "blue", "orange"], :fill)
        drawmodel(object, persp, ["black"], :stroke)
    end
    end
end
