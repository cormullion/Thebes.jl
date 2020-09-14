```@meta
DocTestSetup = quote
    using Thebes, Luxor, Colors
    end
```

# Tools

There are few useful tools that might help you explore.

## Sorting faces

Because Thebes isn't really for modelling solid objects, you'll find that drawing them with `poly(... :fill)` won't give good results.

Here, the faces of the `cuboctahedron` weren't defined in the correct order:

```@example

using Thebes, Luxor, Colors # hide
Drawing(600, 500, "assets/figures/sortingfaces.svg") # hide
background("white") # hide
origin() # hide
sethue("blue") # hide
helloworld() # hide
eyepoint(200, 200, 200)

include(dirname(pathof(Thebes)) * "/../data/moreobjects.jl")

object = make(cuboctahedron, "solid")

pin(setscale!(object, 100, 100, 100), gfunction = (args...) -> begin
    vertices, faces, labels = args
    setlinejoin("bevel")
    setopacity(0.8)
    if !isempty(faces)
        @layer begin
            for (n, p) in enumerate(faces)
                sethue([Luxor.julia_green, Luxor.julia_red,
                    Luxor.julia_purple, Luxor.julia_blue][mod1(n, end)])
                poly(p, :fillpreserve, close=true)
                sethue("grey20")
                strokepath()
            end
        end
    end
end)


finish() # hide
nothing # hide
```

![sorting faces](assets/figures/sortingfaces.svg)

Use `sortfaces!()` to modify the object such that the faces are sorted according to their distance from the eyepoint (by default).


```@example

using Thebes, Luxor, Colors # hide
Drawing(600, 500, "assets/figures/sortingfaces1.svg") # hide
background("white") # hide
origin() # hide
sethue("blue") # hide
helloworld() # hide
eyepoint(200, 200, 200)

include(dirname(pathof(Thebes)) * "/../data/moreobjects.jl")

object = make(cuboctahedron, "solid")

sortfaces!(object)

pin(setscale!(object, 100, 100, 100), gfunction = (args...) -> begin
    vertices, faces, labels = args
    setlinejoin("bevel")
    setopacity(0.8)
    if !isempty(faces)
        @layer begin
            for (n, p) in enumerate(faces)
                sethue([Luxor.julia_green, Luxor.julia_red,
                    Luxor.julia_purple, Luxor.julia_blue][mod1(n, end)])
                poly(p, :fillpreserve, close=true)
                sethue("grey20")
                strokepath()
            end
        end
    end
end)


finish() # hide
nothing # hide
```

![sorting faces](assets/figures/sortingfaces1.svg)

# Geometry

There are some geometry routines - some of them are extensions to the Luxor 2D versions.

## Distances

```@docs
between
distance
midpoint
```

## Rotations


```@docs
rotateX
rotateY
rotateZ
rotateby!
rotateby
```

## Position and scale

You can change the position or position of objects:

```@docs
setposition!
setposition
setscale!
```

## Coordinates

Here are some of the less frequently used functions.

```@docs
sphericaltocartesian
cartesiantospherical

dotproduct3D
magnitude
anglebetweenvectors
surfacenormal
```
