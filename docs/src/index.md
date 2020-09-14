```@meta
DocTestSetup = quote
    using Luxor, Thebes, Dates, Colors
end
```

# Introduction to Thebes

Thebes.jl is a small package that provides a few 3D wireframe tools for use with Luxor.jl, a 2D drawing package.

Most of my work is 2D in nature, but occasionally I require some graphic elements that are three-dimensional. The Thebes package lets you define a few simple shapes in 3D and project them onto a Luxor drawing, which remains resolutely 2D.

!!! note

    Don't set your expectations too high! Thebes.jl merely generates a few simple 3D "wireframe" diagrams. For real 3D work, with solid shapes, lighting, textures,  interactivity, and so on, use Makie.jl. Or spend a few months learning Blender...

# Installation and basic usage

Install the package using the package manager at the REPL:

```
] add Thebes
```

To use Thebes, type:

```
using Thebes
```

## Documentation

This documentation was built using [Documenter.jl](https://github.com/JuliaDocs).

```@example
using Dates # hide
println("Documentation built $(Dates.now()) with Julia $(VERSION)") # hide
```
