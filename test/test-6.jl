using Thebes, Luxor

include(dirname(pathof(Thebes)) * "/../data/moreobjects.jl")

moreobjects = [boxcube, boxtorus, concave, cone, crossshape, cube, cuboctahedron, dodecahedron , geodesic, helix2,
icosahedron, icosidodecahedron, octahedron, octtorus, rhombicosidodecahedron,
rhombicuboctahedron, rhombitruncated_cubeoctahedron, rhombitruncated_icosidodecahedron,
snub_cube, snub_dodecahedron, sphere2, tet3d, tetrahedron, triangle, truncated_cube,
truncated_dodecahedron, truncated_icosahedron, truncated_octahedron, truncated_tetrahedron]

function test_6()
    Drawing(800, 800, "moreobjects.svg")
    origin()
    t = Table(6, 6, 100, 80)

    background("azure")
    setopacity(0.95)
    setline(0.1)

    for (pos, n) in t
        @layer begin
            translate(pos)
            carpet(10)
            object = make(moreobjects[mod1(n, length(moreobjects))])
            scaleby!(object, 10, 10, 10)
            rotateby!(object, 0.1, 0.1,  0.1)
            sortfaces!(object)
            pin(object)
        end
    end
    finish()
end

test_6()
