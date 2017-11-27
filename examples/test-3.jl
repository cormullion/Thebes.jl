using Thebes, Luxor

using ColorSchemes

cols = shuffle!(eval(ColorSchemes, schemes[rand(1:end)]))

@svg begin
    background("azure")
    setopacity(0.95)
    camerapoint = Point3D(200, 200, 400)

    for k in 1:4:20
        for i in 1:20
            object = make(Thebes.Octahedron)
            objects = [object]
            changescale!.(objects, 20, 20, 20)
            changeposition!.(objects, rescale(k, 1, 20, 100, 350), 1, 0)
            rotateto!.(objects,
                rescale(i, 0, 20, 0, 2pi), 
                0,
                rescale(i, 1, 20, 0, 2pi))
            sortfaces!.(objects)
            drawmodel.(objects, camerapoint, :fill, cols=cols)
        end
    end
end
