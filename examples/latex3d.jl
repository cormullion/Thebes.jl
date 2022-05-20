using Thebes
using Luxor
using LaTeXStrings
using MathTeXEngine
using Rotations

function frame(scene, framenumber)
    eased_n = scene.easingfunction(framenumber - scene.framerange.start,
      0, 1, scene.framerange.stop - scene.framerange.start)

    background(0.0, 0.05, 0.1)
    helloworld()
    perspective(600)
    eyepoint(200, 20, 50)
    sethue("white")
    fontsize(40)
    setline(1)

    t₁ = L"e^{i\pi} + 1 = 0"

    sethue("gold")

    for x in 0:25:500
      setopacity(rescale(x, 0, 500, 1, 0))
      leftpt = Point3D(-x, 0, 0)
      text3D(t₁, leftpt,
        action=:stroke,
        halign=:center,
        about=leftpt,
        rotation=RotYXZ(-π/2, π, -π/2),
        portion=eased_n)
    end

end

amovie = Movie(600, 600, "latex the movie")
animate(amovie, Scene(amovie, frame, 1:150), creategif=true, pathname="/tmp/latexanimation.gif")
