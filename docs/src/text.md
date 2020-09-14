```@meta
DocTestSetup = quote
    using Thebes, Luxor, Colors
    end
```

# Text

Displaying text is often difficult for applications, since it depends on font technology, which can be awkward and platform-dependent. For more information about using fonts, you should refer to the chapter in the Luxor documentation. Thebes provides a `text3D()` function that draws text in a 3D environment.

Specify the location of the text, and optionally supply rotation (a tuple of three angles for x, y, and z) and alignment.

```@example
using Thebes, Luxor # hide
Drawing(600, 500, "assets/figures/text1.svg") # hide

fontsize(50)

background("black")
origin()
setlinejoin("bevel")
eyepoint(Point3D(250, 250, 250))
perspective(0)
sethue("white")
axes3D(20)

fontsize(100)


text3D(" Julia 1", Point3D(0, 0, 0), rotation=(π/2, 0, π))

text3D(" Julia 2", Point3D(0, 0, 0), rotation=(π/2, 0, π/2))

text3D(" Julia 3", Point3D(0, 0, 0), rotation=(π/2, 0, 3π/2))

text3D(" Julia 4", Point3D(0, 0, 0), rotation=(π/2, 0, 0), halign=:right)

finish() # hide
nothing # hide
```

![text ](assets/figures/text1.svg)

By default the text starts at the origin and runs along the x-axis.

You can use Luxor's tools for text placement, such as `textextents()`, such as they are.

```@example
using Thebes, Luxor, Colors # hide
Drawing(600, 500, "assets/figures/text2.svg") # hide
background("black")
origin()
eyepoint(Point3D(250, 250, 550))
perspective(500)

fontsize(50)

te = textextents("Julia")

for y in -1200:te[3]:1200
    for x in -1200:te[4]:1200
            sethue(HSB(mod(x*y, 360), .8, .8))
            text3D("Julia", Point3D(x, y, 0), rotation=(0, 0, π/2))
    end
end
finish() # hide
nothing # hide
```

![text ](assets/figures/text2.svg)
