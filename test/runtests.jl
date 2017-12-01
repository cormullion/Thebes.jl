using Thebes
using Base.Test

m = make(Cube)
@test length(m.vertices) == 8

m = make(Cube, "this is a cube")
@test length(m.vertices) == 8
