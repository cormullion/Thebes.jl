using Thebes, Luxor

using ColorSchemes

cols = shuffle!(eval(ColorSchemes, schemes[rand(1:end)]))

theta = 0

@svg begin
    background("azure")
    setopacity(0.95)
    setline(1)
    setlinejoin("bevel")
    camerapoint = Point3D(200, 200, 200)
    object1 = make(Thebes.AxesWire)
    changescale!(object1, 25, 25, 25)
    drawmodel(object1, camerapoint, :stroke, cols=["red"])

    obj = make(Pyramid)
    changescale!(obj, 50, 50, 50)
    changeposition!(obj, 0, 0, 0)
    rotateby!(obj, Point3D(0, 0, 0), mod2pi(theta), 0, 0)

    sortfaces!(obj)
    drawmodel(obj, camerapoint, :fillstroke, cols=cols)
end 400 400

theta += pi/6
