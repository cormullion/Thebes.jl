using Thebes

include(Pkg.dir() * "/Thebes/src/moreobjects.jl")

moreobjects = [boxcube, boxtorus, concave, cone, crossshape, cube, cuboctahedron, dodecahedron , epcot, helix2,
icosahedron, icosidodecahedron, octahedron, octtorus, rhombicosidodecahedron,
rhombicuboctahedron, rhombitruncated_cubeoctahedron, rhombitruncated_icosidodecahedron,
snub_cube, snub_dodecahedron, sphere2, tet3d, tetrahedron, triangle, truncated_cube,
truncated_dodecahedron, truncated_icosahedron, truncated_octahedron, truncated_tetrahedron]

objectnames = ["boxcube", "boxtorus", "concave", "cone", "crossshape", "cube", "cuboctahedron", "dodecahedron", "epcot", "helix2",
"icosahedron", "icosidodecahedron", "octahedron", "octtorus", "rhombicosidodecahedron",
"rhombicuboctahedron", "rhombitruncated_cubeoctahedron", "rhombitruncated_icosidodecahedron",
"snub_cube", "snub_dodecahedron", "sphere2", "tet3d", "tetrahedron", "triangle", "truncated_cube",
"truncated_dodecahedron", "truncated_icosahedron", "truncated_octahedron", "truncated_tetrahedron"]

@svg begin
    background("azure")
    setopacity(0.5)
    setline(0.5)
    fontsize(20)
    setlinejoin("bevel")
    camerapoint = Point3D(0, 0, 450)

    tiles = Tiler(1600, 1600, 6, 6)
    for (pos, n) in tiles
        n > length(moreobjects) && continue
        @layer begin
        translate(pos)
        object = make(moreobjects[n])
        changescale!(object, 35, 35, 35)
        rotateto!(object, 0, 0, 0)
        sortfaces!(object)
        drawmodel(object, camerapoint, :fillstroke, cols=[Luxor.darker_purple, Luxor.darker_red])
        sethue("black")
        label(string(objectnames[n]), :S, offset=tiles.tileheight/2)
    end
end
end 1600 1600
