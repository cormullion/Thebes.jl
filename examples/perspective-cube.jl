using Thebes, Luxor, ColorSchemes

function makecube()
    cube = [
        Point3D(1,   1, -1),
        Point3D(1,  -1, -1),
        Point3D(-1, -1, -1),
        Point3D(-1,  1, -1),
        Point3D(1,   1,  1),
        Point3D(1,  -1,  1),
        Point3D(-1, -1,  1),
        Point3D(-1,  1,  1)]
    r = Point3D[]

    for e in (
            [1, 2, 3, 4, 1],
            [5, 6, 7, 8, 5],
            [5, 1, 2, 6, 7],
            [7, 3, 4, 8, 5])
        append!(r, cube[e])
    end
    return r
end

function frame(scene, framenumber)
    eyepoint(200, 180, 100)
    background("lightblue1")
    sethue("brown")
    setlinejoin("bevel")
    carpet()
    axes3D()
    fontsize(30)
    p = rescale(framenumber, 1, scene.framerange.stop, 0, 1500)
    if p < 300
        p = 0
    end
    perspective(p)
    sethue("black")
    pin(10makecube(), gfunction = (p3, p2) -> poly(p2, :stroke))
    text(string(round(p, digits=0)), boxtopleft(BoundingBox() * 0.9))
end

width, height = (400, 400)
perspectivemovie = Movie(width, height, "perspectivemovie")

animate(perspectivemovie, [
    Scene(perspectivemovie, frame, 1:150)
    ],
    creategif=true,
    framerate=24,
    pathname="/tmp/perspectivemovie-animation.gif")
