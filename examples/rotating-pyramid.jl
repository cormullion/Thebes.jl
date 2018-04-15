using Thebes, Luxor, ColorSchemes


function frame(scene, framenumber)
    cols = shuffle!(eval(ColorSchemes, schemes[rand(1:end)]))

    cols = ColorSchemes.sandyterrain
    background("lightblue1")
    setopacity(0.5)

    theta = rescale(framenumber, 1, scene.framerange.stop, 0, 2pi)

    eyepoint    = Point3D(300cos(theta), 300sin(theta), 50 + 10sin(theta))
    centerpoint = Point3D(0, 0, 0)
    uppoint     = Point3D(0, 0, 1) # relative to centerpoint
    projection  = newprojection(eyepoint, centerpoint, uppoint, 1)

    object  = make(Pyramid)
    changescale!(object, 150, 150, 150)
    # sortfaces!(object)
    drawmodel(object, projection, :fill, cols=[cols[1], cols[2], cols[3]])
    draw3daxes(projection)

    # sethue("black")
    # info = String[]
    # foreach(n -> push!(info, string(n, ": ", getfield(projection, n))), fieldnames(projection))
    # textbox(info, BoundingBox()[1])
end

width, height = (800, 800)
pyramidmovie = Movie(width, height, "pyramidmovie")

animate(pyramidmovie, [
    Scene(pyramidmovie, frame, 1:50)
    ],
    creategif=true,
    framerate=20,
    pathname="/tmp/pyramid-animation.gif")
