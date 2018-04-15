using Thebes, Luxor

include(Pkg.dir() * "/Thebes/src/moreobjects.jl")

platonics = [:boxtorus, :concave, :cone, :crossshape, :cube, :cuboctahedron, :dodecahedron , :geodesic, :helix2,
:icosahedron, :icosidodecahedron, :octahedron, :octtorus, :rhombicosidodecahedron,
:rhombicuboctahedron, :rhombitruncated_cubeoctahedron, :rhombitruncated_icosidodecahedron,
:snub_cube, :snub_dodecahedron, :sphere2, :tet3d, :tetrahedron, :triangle, :truncated_cube,
:truncated_dodecahedron, :truncated_icosahedron, :truncated_octahedron, :truncated_tetrahedron]

@svg begin

setopacity(0.5)

translate(-200, -200)
#axes()

o = platonics[rand(1:end)]

# drawmodel(changescale!(make(Thebes.AxesWire), 100, 100, 100), Point3D(100, 100, 200))

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

eyepoint    = Point3D(500, 500, 100)
centerpoint = Point3D(0, 0, 100)
uppoint     = Point3D(0, 0, 200) # relative to centerpoint
projection  = newprojection(eyepoint, centerpoint, uppoint, 3)

for x in -100:50:100
    for y in -100:50:100
        o = :cube
        object = make(eval(o), string(o))
        changescale!(object, 15, 15, 15)
        changeposition!(object, x, y, 20)
        rotateby!(object, object.vertices[1], rand(), rand(), rand())
        sortfaces!(object)
        drawmodel(object, projection,
            :fill,
            cols=[randomhue(), "azure"],
            renderfunc = anotherrenderfunction)
    end
end
end
