using Thebes, Luxor

function mygfunction(o::Object)
    sortfaces!(o)
    return if !isempty(o.faces)
        @layer begin
            for (n, face) in enumerate(o.faces)
                @layer begin
                    vertices = o.vertices[face]
                    sn = surfacenormal(vertices)
                    ang = anglebetweenvectors(sn, eyepoint())
                    setgrey(rescale(ang, 0, π, 0, 1))
                    pin(vertices, gfunction = (p3, p2) -> poly(p2, :fill))
                end
            end
        end
    end
end

@drawsvg begin
    background("black")
    setlinejoin("bevel")
    helloworld()
    perspective(500)
    eyepoint(30, 30, 1000)
    sethue("maroon")
    carpet(700)
    axes3D(300)
    setopacity(0.9)
    objects = [boxcube, boxtorus, concave, cone, crossshape, cube, cuboctahedron, dodecahedron, geodesic, helix2,
    icosahedron, icosidodecahedron, octahedron, octtorus, rhombicosidodecahedron,
    rhombicuboctahedron, rhombitruncated_cubeoctahedron, rhombitruncated_icosidodecahedron,
    snub_cube, snub_dodecahedron, sphere2, tet3d, tetrahedron, triangle, truncated_cube, 
    truncated_dodecahedron, truncated_icosahedron, truncated_octahedron, truncated_tetrahedron]
    
    tbl = Table(6, 6)
    for (i, o) in enumerate(objects)
        object = make(o, "a primitive shape")
        scaleby!(object, 20, 20, 20)
        rotateby!(object, Point3D(0, 0, 0), 0, 0, 0.4)
        @layer begin
            translate(tbl[i])
            pin(object, gfunction = mygfunction)
        end
    end 
end
