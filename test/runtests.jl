using Thebes, Luxor
using Base.Test

m = make(Cube)
@ test length(m.vertices) == 8
