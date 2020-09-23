```@meta
DocTestSetup = quote
    using Thebes, Luxor, Colors
    end
```

# Tools

There are few useful tools that might help you explore.

## Getting your hands dirty

Suppose you want to remove the front-facing faces of an object, in order to see inside. That's possible, but a bit of code is needed.

```@example
using Thebes, Luxor, Colors # hide
Drawing(600, 500, "assets/figures/cullingfaces.svg") # hide
background("white") # hide
origin() # hide
helloworld() # hide
eyepoint(200, 200, 200)
axes3D(300)
setlinejoin("bevel")

include(dirname(pathof(Thebes)) * "/../data/moreobjects.jl")

objectfull = make(cuboctahedron, "the full object")
objectcut  = make(cuboctahedron, "the cut-open object")

map(o -> scaleby!(o, 60, 60, 60), (objectfull, objectcut))

function cullfrontfaces!(m::Object, angle;
        eyepoint::Point3D=eyepoint())
    avgs = Float64[]
    for f in m.faces
        vs = m.vertices[f]
        s = 0.0
        for v in vs
            s += distance(v, eyepoint)
        end
        avg = s/length(unique(vs))

        θ = surfacenormal(vs)
        if anglebetweenvectors(θ, eyepoint) > angle
            push!(avgs, avg)
        end
    end
    neworder = reverse(sortperm(avgs))
    m.faces = m.faces[neworder]
    m.labels = m.labels[neworder]
    return m
end

function drawobject(object)
    pin(object, gfunction = (args...) -> begin
        vertices, faces, labels = args
        setopacity(0.8)
        sethue("grey80")
        if !isempty(faces)
            @layer begin
                for (n, p) in enumerate(faces)
                    poly(p, :fillpreserve, close=true)
                    @layer begin
                        sethue("grey20")
                        strokepath()
                    end
                end
            end
        end
    end)
end

sortfaces!.((objectcut, objectfull))
cullfrontfaces!(objectcut, π/3)

translate(-200, 0)
drawobject(objectcut)

translate(400, 0)
drawobject(objectfull)

@show length(objectcut.faces)
@show length(objectfull.faces)

finish() # hide
nothing # hide
```

The object on the left has had its four frontfacing faces removed. The one on the right is intact.

![culling faces](assets/figures/cullingfaces.svg)

# Geometry

There are some basic geometry utility functions - some of them are analogous to their Luxor 2D counterparts.

## General

```@docs
axes3D
carpet
drawcube
```

## Distances

```@docs
between
distance
midpoint
```

## Rotations

Work in progress:

```@docs
rotateX
rotateY
rotateZ
rotateby!
rotateby
```

## Position and scale

You can change the position and scale of things:

```@docs
moveby!
moveby
scaleby!
```

## Coordinates

```@docs
sphericaltocartesian
cartesiantospherical

dotproduct3D
magnitude
anglebetweenvectors
surfacenormal
```
