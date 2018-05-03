using Thebes, Luxor

include(Pkg.dir() * "/Thebes/src/moreobjects.jl")

platonics = [:boxtorus, :concave, :cone, :crossshape, :cube, :cuboctahedron, :dodecahedron , :geodesic, :helix2,
:icosahedron, :icosidodecahedron, :octahedron, :octtorus, :rhombicosidodecahedron,
:rhombicuboctahedron, :rhombitruncated_cubeoctahedron, :rhombitruncated_icosidodecahedron,
:snub_cube, :snub_dodecahedron, :sphere2, :tet3d, :tetrahedron, :triangle, :truncated_cube,
:truncated_dodecahedron, :truncated_icosahedron, :truncated_octahedron, :truncated_tetrahedron]

@svg begin
    setopacity(0.75)
    o = platonics[rand(1:end)]
    function anotherrenderfunction(vertices, faces, labels, cols, action=:fill)
        if !isempty(faces)
            @layer begin
                for (n, p) in enumerate(faces)
                    x = mod1(n, length(cols))
                    c = cols[mod1(labels[x], length(cols))]
                    sethue(c)
                    poly(p, action)
                end
            end
        end
    end

    eyepoint    = Point3D(600, 600, 400)
    centerpoint = Point3D(0, 0, 1)
    uppoint     = Point3D(0, 0, 2) # relative to centerpoint
    projection  = newprojection(eyepoint, centerpoint, uppoint, 1500)
    drawcarpet(300, projection)
    draw3daxes(200, projection)
    setline(10)
    for x in -100:50:100
        for y in -100:50:100
            o = :cube
            object = make(eval(o), string(o))
            changescale!(object, 15, 15, 15)
            changeposition!(object, x, y, 50rand())
            rotateby!(object, object.vertices[1], rand(), rand(), rand())
            drawmodel(object, projection,
                cols=[randomhue(), "azure"],
                renderfunc = anotherrenderfunction)

            # dark version
            changeposition!(object, 0, 0, -object.vertices[1].z)
            changescale!(object, 1, 1, 0)
            drawmodel(object, projection, cols=["grey20", "gray40"],
            renderfunc = anotherrenderfunction)
        end
    end
end
