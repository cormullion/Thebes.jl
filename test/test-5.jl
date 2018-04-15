using Luxor, Thebes

include(Pkg.dir() * "/Thebes/src/moreobjects.jl")

moreobjects = [boxcube, boxtorus, concave, cone, crossshape, cube, cuboctahedron, dodecahedron , geodesic,
# helix2,
icosahedron, icosidodecahedron, octahedron, octtorus, rhombicosidodecahedron,
rhombicuboctahedron, rhombitruncated_cubeoctahedron, rhombitruncated_icosidodecahedron,
snub_cube, snub_dodecahedron, sphere2, tet3d, tetrahedron, triangle, truncated_cube,
truncated_dodecahedron, truncated_icosahedron, truncated_octahedron, truncated_tetrahedron]

objectnames = ["boxcube", "boxtorus", "concave", "cone", "crossshape", "cube", "cuboctahedron", "dodecahedron", "geodesic",
# "helix2",
"icosahedron", "icosidodecahedron", "octahedron", "octtorus", "rhombicosidodecahedron",
"rhombicuboctahedron", "rhombitruncated_cubeoctahedron", "rhombitruncated_icosidodecahedron",
"snub_cube", "snub_dodecahedron", "sphere2", "tet3d", "tetrahedron", "triangle", "truncated_cube",
"truncated_dodecahedron", "truncated_icosahedron", "truncated_octahedron", "truncated_tetrahedron"]

Drawing(800, 800., "/tmp/test-5.svg")
    origin()
    eyepoint    = Point3D(500, 500, 100)
    centerpoint = Point3D(0, 0, 0)
    uppoint     = Point3D(0, 0, 1) # relative to centerpoint
    projection  = newprojection(eyepoint, centerpoint, uppoint)

    background("azure")
    setopacity(0.5)
    setline(0.5)
    fontsize(10)
    setlinejoin("bevel")

    tiles = Tiler(800, 800, 6, 6)
    for (pos, n) in tiles
        n > length(moreobjects) && continue
        @layer begin
        translate(pos)
        object = make(moreobjects[n])
        changescale!(object, 15, 15, 15)
        rotateto!(object, 0, 0, 0)
        sortfaces!(object)
        drawmodel(object, projection, :fillstroke, cols=[Luxor.darker_purple, Luxor.darker_red])
        sethue("white")
        drawmodel(object, projection, :stroke)
        sethue("black")
        label(string(objectnames[n]), :S, offset=tiles.tileheight/2)
    end
end
finish()
preview()
