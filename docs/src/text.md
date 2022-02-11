```@meta
DocTestSetup = quote
    using Thebes, Luxor, Colors, Rotations
    end
```

# Text

Thebes provides a `text3D()` function that draws text in a 3D environment. For more information about using fonts and font selection, refer to the chapter in the Luxor documentation.

You specify the 3D location of the text, and optionally supply rotations and text alignment (`halign` etc.). By default the text in Thebes (as in Luxor) runs along the x-axis, and it lies in the xy plane.

Use Rotations.jl to specify rotations.

```@example
using Thebes, Luxor, Rotations # hide
Drawing(600, 500, "assets/figures/text1.svg") # hide

fontsize(50)

background("black")
origin()
setlinejoin("bevel")
eyepoint(Point3D(250, 250, 250))
perspective(400)
sethue("white")
axes3D(220)

fontsize(40)
fontface("Georgia-Italic")

text3D("the x-axis", Point3D(0, 0, 0))
text3D("the y-axis", Point3D(0, 0, 0), rotation=RotZ(π/2))
text3D("the z-axis", Point3D(0, 0, 0), rotation=RotX(-π/2) * RotZ(π/2), halign=:right)

finish() # hide
nothing # hide
```

![text ](assets/figures/text1.svg)

You can also use some of Luxor's text functions, such as `textextents()`, which helps you get the (2D) dimensions of text.

```@example
using Thebes, Luxor, Colors, Rotations
Drawing(800, 600, "assets/figures/text2.svg") # hide
background("black") # hide
origin() # hide
eyepoint(Point3D(250, 250, 550))
perspective(500)

fontsize(50)

te = textextents("Julia")

for y in -1200:te[3]:1200
        for x in -1200:te[4]:1200
            sethue(HSB(mod(x*y, 360), .6, .9))
            text3D("Julia", Point3D(x, y, 0), about=Point3D(x, y, 0), rotation=RotZ(π/2))
        end
    end
finish() # hide
nothing # hide
```

![text ](assets/figures/text2.svg)

It's also possible to write math equations in ``\LaTeX`` by
passing a `LaTeXString` to the `text` function. Thebes and
Luxor use
[MathTeXEngine.jl](https://github.com/Kolaru/MathTeXEngine.jl)
to parse the `LaTeXString`. You should load MathTeXEngine.jl
(`using MathTeXEngine`) before accessing this feature.

```julia
using Luxor
using Thebes
using MathTeXEngine
using Rotations
using LaTeXStrings

@drawsvg begin
    background(0.0, 0.05, 0.1)
    helloworld()
    perspective(300)
    eyepoint(200, 200, 200)
    sethue("white")
    fontsize(40)
    setline(1)
    e = L"e^{i\pi} + 1 = 0"
    for i in 0:π/10:2π - π/10
        text3D(e,
            sphericaltocartesian(50, i, π/2),
            about=sphericaltocartesian(50, i, π/2),
            rotation=RotZ(i))
    end
end
```

![LaTeX text](assets/figures/text3.svg)

```@docs
text3D
```
