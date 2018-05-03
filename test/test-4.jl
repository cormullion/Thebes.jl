using Thebes, Luxor

include(Pkg.dir() * "/Thebes/src/moreobjects.jl")

platonics = [:boxtorus, :concave, :cone, :crossshape, :cube, :cuboctahedron, :dodecahedron , :geodesic, :helix2,
:icosahedron, :icosidodecahedron, :octahedron, :octtorus, :rhombicosidodecahedron,
:rhombicuboctahedron, :rhombitruncated_cubeoctahedron, :rhombitruncated_icosidodecahedron,
:snub_cube, :snub_dodecahedron, :sphere2, :tet3d, :tetrahedron, :triangle, :truncated_cube,
:truncated_dodecahedron, :truncated_icosahedron, :truncated_octahedron, :truncated_tetrahedron]

function anotherrenderfunction(vertices, faces, labels, cols, action=:fill)
    if !isempty(faces)
        @layer begin
            for (n, p) in enumerate(faces)
                x = mod1(n, length(cols))
                c = cols[mod1(labels[x], length(cols))]
                sethue(c)
                polysmooth(p, 2, action)
                sethue("black")
                polysmooth(p, 2, :stroke)
            end
        end
    end
end

Drawing(800, 800, "/tmp/test-4.svg")
    background("ivory")
    origin()
    setopacity(0.5)
    setlinejoin("bevel")
    setline(0.3)
    #axes()
    o = platonics[rand(1:end)]
    eyepoint    = Point3D(500, 500, 100)
    centerpoint = Point3D(0, 0, 1)
    uppoint     = Point3D(0, 0, 2) # relative to centerpoint
    projection  = newprojection(eyepoint, centerpoint, uppoint, 1)

    o = :rhombicosidodecahedron

    tiles = Tiler(800, 800, 3, 3, margin=150)

    for (pos, n) in tiles
        @layer begin
        translate(pos)
        object = make(eval(o), string(o))
        changescale!(object, 70, 70, 70)
        changeposition!(object, 1 * rand(), 1 * rand(), 10 * rand())
        rotateto!(object, #= object.vertices[1],=# 2pi * rand(), 2pi * rand(), 2pi * rand())
        sortfaces!(object)
        drawmodel(object, projection,
            cols=[randomhue(), "azure", randomhue()],
            renderfunc = anotherrenderfunction)
        end
    end
finish()
preview()
