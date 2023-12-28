import Pkg
Pkg.add("LaTeXStrings")
Pkg.add("MathTeXEngine")

using Luxor
using Thebes
using Rotations
using LaTeXStrings
using MathTeXEngine

@svg begin
    background(0.0, 0.05, 0.1)
    helloworld()
    perspective(300)
    eyepoint(300, 300, 500)
    sethue("white")
    fontsize(60)
    setline(1)
    e = L"e^{i\pi} + 1 = 0"
    for z in -1200:100:200
        setopacity(z < 200 ? 0.3 : 1.0)
        for i in 0:π/10:2π-π/10
            text3D(e,
                sphericaltocartesian(100, i, π / 2) + (0, 0, z),
                about=sphericaltocartesian(100, i, π / 2),
                rotation=RotZ(i))
        end
    end
end 600 600 "latex-test.svg"
