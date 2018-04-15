using Thebes, Luxor

using ColorSchemes

Drawing(800, 800, "/tmp/test3.svg")
    background("azure")
    origin()
    setopacity(0.5)
    eyepoint    = Point3D(500, 500, 300)
    centerpoint = Point3D(0, 0, 100)
    uppoint     = Point3D(0, 0, 200) # relative to centerpoint
    projection  = newprojection(eyepoint, centerpoint, uppoint)

    colors = shuffle!(eval(ColorSchemes, schemes[rand(1:end)]))
    for k in 1:4:20
        colors = ColorSchemes.leonardo
        for i in 1:20
            object = make(Pyramid)
            objects = [object]
            changescale!.(objects, 12, 12, 12)
            changeposition!.(objects, rescale(k, 1, 20, 50, 400), 1, 0)
            a = rescale(i, 1, 20, 0, 2pi)
            rotateto!.(objects,
                0,
                0,
                a)
            #rotateby!(object, object.vertices[1], a, a, a)
            sortfaces!.(objects)
            drawmodel.(objects, projection, :stroke, cols=colors)
            sethue("white")
            setline(0.1)
            drawmodel.(objects, projection, :stroke, cols=colors)

            #drawmodel.(objects, projection, :stroke, cols=colors)
        end
    end
finish()
preview()
