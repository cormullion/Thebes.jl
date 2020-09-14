using Thebes, Luxor


function frame(scene, framenumber)
    background("lightblue1")
    setopacity(0.5)

    theta = rescale(framenumber, 1, scene.framerange.stop, 0, 2pi)
    perspective(500)

    eyepoint(Point3D(300cos(theta), 300sin(theta), 50 + 10sin(theta)))

    object  = make(Pyramid)
    setscale!(object, 150, 150, 150)
    pin(object)
    axes3D(50)

end

width, height = (800, 800)
pyramidmovie = Movie(width, height, "pyramidmovie")

animate(pyramidmovie, [
    Scene(pyramidmovie, frame, 1:50)
    ],
    creategif=true,
    framerate=20,
    pathname="/tmp/pyramid-animation.gif")
