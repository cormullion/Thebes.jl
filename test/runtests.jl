using Thebes
using Base.Test

m = make(Cube)
@test length(m.vertices) == 8

m = make(Cube, "this is a cube")
@test length(m.vertices) == 8

include("point3d-arithmetic.jl")
include("test-1.jl")
include("test-2.jl")
include("test-3.jl")
include("test-4.jl")
include("test-5.jl")
include("test-6.jl")
include("test-7.jl")
