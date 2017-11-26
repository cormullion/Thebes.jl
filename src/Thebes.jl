__precompile__(true)

module Thebes

using Luxor, StaticArrays

include("basics.jl")
include("display.jl")
include("primitives.jl")
include("transforms.jl")

export Axes3D, Point3D, Tetrahedron, Cube, Projection, Model, Pyramid, Carpet, AxesWire,
    make, project,
    rotateX, rotateY, rotateZ, rotateto!, rotateto,
    move!,
    drawmodel, modeltopoly,
    changescale!, sortfaces!
end # module
