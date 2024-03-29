using Thebes, Luxor

include(dirname(pathof(Thebes)) * "/../data/moreobjects.jl")

platonics = [:boxtorus, :concave, :cone, :crossshape, :cube, :cuboctahedron, :dodecahedron , :geodesic, :helix2,
:icosahedron, :icosidodecahedron, :octahedron, :octtorus, :rhombicosidodecahedron,
:rhombicuboctahedron, :rhombitruncated_cubeoctahedron, :rhombitruncated_icosidodecahedron,
:snub_cube, :snub_dodecahedron, :sphere2, :tet3d, :tetrahedron, :triangle, :truncated_cube,
:truncated_dodecahedron, :truncated_icosahedron, :truncated_octahedron, :truncated_tetrahedron]

function test_7()
    Drawing(800, 800, "cubes.svg")
    origin()
    background("orange")
    #setopacity(0.75)
    o = platonics[rand(1:end)]

    @layer begin
        sethue("magenta")
        carpet(300)
    end
    axes3D()
    setline(10)
    for x in -100:50:100
        for y in -100:50:100
            object = make(moreobjects[2])
            scaleby!(object, 10, 10, 10)
            moveby!(object, x, y, 50rand())
            rotateby!(object, object.vertices[1], rand(), rand(), rand())
            pin(object)

            # dark version
            moveby!(object, 0, 0, -object.vertices[1].z)
            scaleby!(object, 1, 1, 0)
            pin(object)
        end
    end
    finish()
end

test_7()
