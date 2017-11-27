using Thebes, Luxor

using ColorSchemes

cols = shuffle!(eval(ColorSchemes, schemes[rand(1:end)]))

cols = ColorSchemes.sandyterrain

@png begin
    background("azure")
    setopacity(0.95)
    camerapoint = Point3D(200, 200, 300)
    carpet = make(Carpet)
    changescale!(carpet, 50, 40, 1)
    rotateto!(carpet, pi/2 +0.1, 0, 0)
    drawmodel(carpet, camerapoint, :fill, cols=["gold"])
    object = make(Pyramid)
    object1 = make(Pyramid)
    object2 = make(Pyramid)
    objects = [object, object1, object2]
    changescale!.(objects, 50, 50, 50)
    changeposition!.(objects, [-250, 0, 150], 0, 0)
    rotateto!.(objects, pi/2, 1, 0)
    sortfaces!.(objects)
    drawmodel.(objects, camerapoint, :fill, cols=cols)
end 600 600
