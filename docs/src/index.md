```@meta
DocTestSetup = quote
    using Dates
end
```

# Introduction to Thebes

Thebes.jl is a small package that provides a few 3D wireframe tools for use with [Luxor.jl](https://github.com/juliagraphics/Luxor.jl), a simple 2D drawing package. You can define simple shapes in 3D, and have them projected onto a Luxor drawing.

!!! note

    Don't set your expectations too high! Thebes.jl merely generates a few simple 3D "wireframe" diagrams. For real 3D work, with solid shapes, lighting, textures, interactivity, and so on, use Makie.jl. Or spend a few months learning Blender...

# Installation and basic usage

Install the package using the package manager at the REPL:

```
] add Thebes
```

To use Thebes, type:

```
using Thebes, Luxor
```

A quick test:

```@example
using Thebes
using Luxor

@drawsvg begin
    background("grey20")
    eyepoint(150, 150, 150)
    perspective(700)
    # read sphere data from a file
    include(dirname(dirname(pathof(Thebes))) * "/data/sphere.jl")
    # make a 3D object
    S = make(sphere, "a sphere")
    axes3D()
    # resize sphere from unit coordinates
    scaleby!(S, 150)

    setopacity(0.8)
    pin(S) # the "project into 2D" function
end 800 500
```

## Documentation

This documentation was built using [Documenter.jl](https://github.com/JuliaDocs).

```@example
using Dates # hide
println("Documentation built $(Dates.now()) with Julia $(VERSION)") # hide
```
