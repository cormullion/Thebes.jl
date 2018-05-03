using Thebes

include(Pkg.dir() * "/Thebes/src/moreobjects.jl")

moreobjects = [boxcube, boxtorus, concave, cone, crossshape, cube, cuboctahedron, dodecahedron , geodesic, helix2,
icosahedron, icosidodecahedron, octahedron, octtorus, rhombicosidodecahedron,
rhombicuboctahedron, rhombitruncated_cubeoctahedron, rhombitruncated_icosidodecahedron,
snub_cube, snub_dodecahedron, sphere2, tet3d, tetrahedron, triangle, truncated_cube,
truncated_dodecahedron, truncated_icosahedron, truncated_octahedron, truncated_tetrahedron]

function myrenderfunction(vertices, faces, labels, cols, action=:fill)
    if !isempty(faces)
        @layer begin
            for (n, p) in enumerate(faces)
                x = mod1(n, length(cols))
                c = cols[mod1(labels[x], length(cols))]
                sethue(c)
                poly(p, action)
                sethue("black")
                poly(p, :stroke)
            end
        end
    end
end

Drawing(800, 800, "/tmp/moreobjects.svg")
    origin()
    t = Table(6, 6, 100, 80)
    eyepoint    = Point3D(1, 1, 100)
    centerpoint = Point3D(0, 0, 0)
    uppoint     = Point3D(0, 0, 1) # relative to centerpoint
    projection  = newprojection(eyepoint, centerpoint, uppoint)

    background("azure")
    setopacity(0.95)
    setline(0.1)

    for (pos, n) in t
        @layer begin
            translate(pos)
            drawcarpet(10, projection)
            object = make(moreobjects[mod1(n, length(moreobjects))])
            changescale!(object, 10, 10, 10)
            rotateto!(object, 0.1, 0.1,  0.1)
            sortfaces!(object)
            drawmodel(object, projection, cols=[Luxor.lighter_blue],
                renderfunc = myrenderfunction)
        end
    end
finish()
preview()
