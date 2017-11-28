using Thebes

include(Pkg.dir() * "/Thebes/src/moreobjects.jl")

moreobjects = [boxcube, boxtorus, concave, cone, cross, cube, cuboctahedron, dodecahedron , epcot, helix2,
icosahedron, icosidodecahedron, octahedron, octtorus, rhombicosidodecahedron,
rhombicuboctahedron, rhombitruncated_cubeoctahedron, rhombitruncated_icosidodecahedron,
snub_cube, snub_dodecahedron, sphere2, tet3d, tetrahedron, triangle, truncated_cube,
truncated_dodecahedron, truncated_icosahedron, truncated_octahedron, truncated_tetrahedron]

# n = 1
@svg begin
    background("azure")
    setopacity(0.5)
    setline(0.5)
    setlinejoin("bevel")
    camerapoint = Point3D(0, 0, 450)

        object = make(moreobjects[n])
        changescale!(object, 135, 135, 135)
        rotateto!(object, 0.1, 0.1,  0.1)
        sortfaces!(object)
        drawmodel(object, camerapoint, :fillstroke, cols=[Luxor.darker_blue])

end 800 800
n += 1
