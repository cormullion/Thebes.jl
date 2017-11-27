using Thebes, Luxor

using ColorSchemes

cols = ColorSchemes.sandyterrain

cols = shuffle!(eval(ColorSchemes, schemes[rand(1:end)]))

# theta = 0

@svg begin
    background("azure")
    setopacity(0.95)
    setline(1)
    setlinejoin("bevel")
    camerapoint = Point3D(200, 200, 100)
    object1 = make(AxesWire)
    changescale!(object1, 15, 15, 15)
    drawmodel(object1, camerapoint, :stroke, cols=["red"])

    cube = make(Cube)
    changescale!(cube, 25, 25, 25)
    changeposition!(cube, 0, 0, 0)
    rotateby!(cube, Point3D(0, 40, 0), theta, 0, theta)

    drawmodel(changeposition!(make(Cube), 0, 40, 0), camerapoint, :fill, cols=["black"])

    sortfaces!(cube)
    drawmodel(cube, camerapoint, :fillstroke, cols=cols)
end 400 400

theta += pi/6
