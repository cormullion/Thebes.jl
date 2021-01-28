using Thebes, Luxor, Colors, Rotations

function frame(scene, fn)
    background("black")
    eased_n = scene.easingfunction(fn, 0, 1, scene.framerange.stop)
    sethue("gold")
    fontsize(50)
    helloworld()
    eyepoint(400, 50, 200)
    fontface("JuliaMono-Black")
    axes3D(100)
    r = eased_n * 2π
    text3D("Hello Ole",
        Point3D(0, 0, 0),
        halign=:center,
        rotation = RotXYZ(-r, π/2 + r, π/2 + r))
end

oletext = Movie(300, 300, "oletext")
animate(oletext, [Scene(oletext, frame, 1:150, easingfunction=easeinoutcubic)],
    creategif=true,
    pathname="/tmp/oletext.gif")
