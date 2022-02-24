using Thebes
using Luxor
using LaTeXStrings
using MathTeXEngine
using MathTeXEngine
using Rotations

@draw begin
    background(0.0, 0.05, 0.1)
    helloworld()
    perspective(300)
    eyepoint(200, 200, 200)
    sethue("white")
    fontsize(20)
    setline(1)
    e = L"e^{i\pi} + 1 = 0"
    for i in 0:π/10:2π - π/10
        text3D(e,
            sphericaltocartesian(50, i, π/2),
            action=:stroke,
            about=sphericaltocartesian(50, i, π/2),
            rotation=RotZ(i),
            portion=1.0)
    end
end
