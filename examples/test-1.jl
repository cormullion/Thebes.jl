using Luxor, Thebes, ColorSchemes

@svg begin
    background("ivory")
    tiles = Tiler(800, 800, 3, 3, margin=25)
    setopacity(0.9)
    setlinejoin("bevel")
    persp = Projection(0, 0, Point3D(-120, 120, 800))
    cube = make(Cube)
    pyramid = make(Pyramid)

    changescale!(cube, 50, 50, 50)
    changescale!(pyramid, 50, 50, 50)

    # rotateto!(pyramid, 0, 0, pi/4)
    move!(cube, 0, 0, 50)

    for (pos, n) in tiles
        cols = shuffle!(eval(ColorSchemes, schemes[rand(1:end)]))
        @layer begin
            translate(pos)
            for object in [cube, pyramid]
                # angleX = 2pi * rand()
                # angleY = 2pi * rand()
                # angleZ = 2pi * rand()

                # rotateto!(object, pi/5, pi/5, pi/5)

                sortfaces!(object)
                verts, faces = modeltopoly(object, persp)
                drawmodel(object, persp, cols, :fill)
            end
        end
    end
end 800 800
