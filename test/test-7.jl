using Thebes, Luxor

include(string(@__FILE__, "../../../data/moreobjects.jl"))

platonics = [:boxtorus, :concave, :cone, :crossshape, :cube, :cuboctahedron, :dodecahedron , :geodesic, :helix2,
:icosahedron, :icosidodecahedron, :octahedron, :octtorus, :rhombicosidodecahedron,
:rhombicuboctahedron, :rhombitruncated_cubeoctahedron, :rhombitruncated_icosidodecahedron,
:snub_cube, :snub_dodecahedron, :sphere2, :tet3d, :tetrahedron, :triangle, :truncated_cube,
:truncated_dodecahedron, :truncated_icosahedron, :truncated_octahedron, :truncated_tetrahedron]

function main()
    Drawing(800, 800, "/tmp/cubes.svg")
    origin()
    background("orange")
    #setopacity(0.75)
    o = platonics[rand(1:end)]
    function anothergfunction(vertices, faces, labels, action=:fill)
        if !isempty(faces)
            @layer begin
                for (n, p) in enumerate(faces)
                    randomhue()
                    poly(p, action)
                end
            end
        end
    end

    @layer begin
        sethue("magenta")
        carpet(300)
    end
    axes3D()
    setline(10)
    for x in -100:50:100
        for y in -100:50:100
            object = make(moreobjects[2])
            setscale!(object, 10, 10, 10)
            setposition!(object, x, y, 50rand())
            rotateby!(object, object.vertices[1], rand(), rand(), rand())
            pin(object, gfunction = anothergfunction)

            # dark version
            setposition!(object, 0, 0, -object.vertices[1].z)
            setscale!(object, 1, 1, 0)
            pin(object, gfunction = anothergfunction)
        end
    end
    finish()
end

main()
