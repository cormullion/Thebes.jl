```@meta
DocTestSetup = quote
    using Dates
end
```
```@raw html
---
layout: home

hero:
  name: Thebes.jl
  text: 3D vector graphics
  tagline: a little 3D toolbox companion for Luxor.jl
  actions:
    - theme: brand
      text: Introduction
      link: /basics
    - theme: alt
      text: View on GitHub
      link: https://github.com/cormullion/Thebes.jl
  image:
    src: /assets/logo.svg
    alt: Thebes.jl
    dark: /assets/logo.svg # optional: a variant for dark themes

features:
  - icon:
      light: /figures/icon-1.svg
      dark: /figures/icon-1.svg
      alt: simple 3D vectors
      wrap: true
    title: Simple 3D vector graphics
    details: "Thebes.jl is a little extension package to accompany the vector-graphics package Luxor.jl. It provides some rudimentary 3D wireframe functionality."
    link: /basics
  - icon:
      light: /figures/icon-2.svg
      dark: /figures/icon-2.svg
      alt: colorful graphics
      wrap: true
    title: Project 3D points onto a drawng
    details: "Thebes projects points from the 3D world onto a 2D Luxor drawing. All the graphics are drawn using Luxor drawing functions."
    link: /polys
  - icon:
      light: /figures/icon-3.png
      dark: /figures/icon-3.png
      alt: text handling
      wrap: true
    title: Load object data in OFF format
    details: "Thebes.jl knows how to load some objects in the Object File Format (.OFF)."
    link: /objects
---
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
