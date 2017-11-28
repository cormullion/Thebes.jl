using Thebes, Luxor

using ColorSchemes


@svg begin
    background("azure")
    setopacity(0.95)
    camerapoint = Point3D(200, 200, 400)
    setline(0.3)
    for k in 1:4:20
        colors = shuffle!(eval(ColorSchemes, schemes[rand(1:end)]))
        @show length(colors)
        for i in 1:20
            object = make(Pyramid)
            objects = [object]
            changescale!.(objects, 12, 12, 12)
            changeposition!.(objects, rescale(k, 1, 20, 100, 350), 1, 0)
            a = rescale(i, 1, 20, 0, 2pi)
            rotateto!.(objects,
                0,
                0,
                a)
            rotateby!(object, object.vertices[1], a, a, a)
            sortfaces!.(objects)
            drawmodel.(objects, camerapoint, :fill, cols=colors)
            sethue("black")
            drawmodel.(objects, camerapoint, :stroke, cols=colors)
        end
    end
end
