```@meta
DocTestSetup = quote
    using Dates
end
```

# Introduction to Thebes

Thebes.jl is a small package that provides a few 3D wireframe tools for use with Luxor.jl, a 2D drawing package. You can define simple shapes in 3D, and have them drawn onto a Luxor drawing.

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

## Documentation

This documentation was built using [Documenter.jl](https://github.com/JuliaDocs).

```@example
using Dates # hide
println("Documentation built $(Dates.now()) with Julia $(VERSION)") # hide
```
