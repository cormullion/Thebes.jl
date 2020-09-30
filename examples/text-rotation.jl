using Thebes, Luxor, Colors

function frame(scene, fn)
    background("black")
    eased_n = scene.easingfunction(fn, 0, 1, scene.framerange.stop)
    sethue("gold")
    fontsize(50)
    helloworld()
    eyepoint(400, 0, 200)
    fontface("JuliaMono-Black")
    #axes3D(100)
    for i in 1:-.02:0
        setopacity(1 - i)
        sethue(HSB(360i, .8, .85))
        text3D("Hello Ole", between(eyepoint()/5, Point3D(0, 0, 0), i), halign=:center,
            rotation = (-π/2 + (eased_n * 2π), π, -π/2 + eased_n * 2π))
    end
end

oletext = Movie(300, 300, "oletext")
animate(oletext, [Scene(oletext, frame, 1:150, easingfunction=easeinoutcubic)],
    creategif=true,
    pathname="/tmp/oletext.gif")
