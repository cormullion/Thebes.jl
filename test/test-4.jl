using Thebes, Luxor

include(dirname(pathof(Thebes)) * "/../data/moreobjects.jl")

moreobjects = [boxcube, boxtorus, concave, cone, crossshape, cube,
cuboctahedron, dodecahedron , geodesic, # helix2, icosahedron,
icosidodecahedron, octahedron, octtorus, rhombicosidodecahedron,
rhombicuboctahedron, rhombitruncated_cubeoctahedron,
rhombitruncated_icosidodecahedron, snub_cube, snub_dodecahedron, sphere2, tet3d,
tetrahedron, triangle, truncated_cube, truncated_dodecahedron,
truncated_icosahedron, truncated_octahedron, truncated_tetrahedron]

function test_4()

    Drawing(800, 800, "test-4.svg")
    background("ivory")
    origin()
    setopacity(0.5)
    setlinejoin("bevel")
    setline(0.3)

    tiles = Tiler(800, 800, 5, 5, margin=150)

    for (pos, n) in tiles
        @layer begin
            translate(pos)
            object = make(moreobjects[rand(eachindex(moreobjects))])

            scaleby!(object, 30, 30, 30)
            moveby!(object, 1 * rand(), 1 * rand(), 10 * rand())
            rotateby!(object, #= object.vertices[1],=# 2pi * rand(), 2pi * rand(), 2pi * rand())
            sortfaces!(object)
            pin(object)
        end
    end
    finish()
end

test_4()
