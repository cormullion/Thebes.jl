using Thebes, Luxor

using ColorSchemes

cols = shuffle!(eval(ColorSchemes, schemes[rand(1:end)]))

cols = ColorSchemes.sandyterrain

Drawing(800, 800, "/tmp/test2-pyramids.svg")
    origin()
    background("lightblue1")
    setopacity(1)

    eyepoint    = Point3D(16, 30, 5)
    centerpoint = Point3D(0, 0, 10)
    uppoint     = Point3D(0, 0, 200) # relative to centerpoint
    projection  = newprojection(eyepoint, centerpoint, uppoint, 20)

    setblend(blend(O, 50, O, 500, cols[1], cols[5]))
    drawcarpet(40, projection, kind=:circular)

    object  = make(Pyramid)
    object1 = make(Pyramid)
    object2 = make(Pyramid)
    objects = [object, object1, object2]
    changescale!.(objects, 3, 3, 4)
    changeposition!.(objects, [-16, 0, 15], 0, 0)
#    rotateto!.(objects, pi/2, 1, 0)
    sortfaces!.(objects)
    drawmodel.(objects, projection, :fill, cols=cols)
#    drawunitbox(10, projection)

finish()
preview()
