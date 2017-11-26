using Luxor, Thebes, ColorSchemes

@svg begin
    background("ivory")
    tiles = Tiler(800, 800, 3, 3, margin=25)
    setopacity(0.9)
    setlinejoin("bevel")
    persp = Projection(1, 0, 0)
    cube = make(Cube)
    pyramid = make(Pyramid)

    carpet = make(Carpet)

    # changescale!(cube, 50, 50, 50)

    move!(carpet, 0, 0, -10)
    changescale!(carpet, 10, 10, 10)

    # rotateto!(pyramid, 0, 0, pi/4)
    # move!(pyramid, 0, 0, 50)

    cols = shuffle!(eval(ColorSchemes, schemes[rand(1:end)]))
    for object in [carpet, cube, pyramid]
        # angleX = 2pi * rand()
        # angleY = 2pi * rand()
        # angleZ = 2pi * rand()

        # rotateto!(object, pi/5, pi/5, pi/5)

        sortfaces!(object)
        verts, faces = modeltopoly(object, persp)
        drawmodel(object, persp, cols, :fill)
    end
end 800 800
