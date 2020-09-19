using Luxor, Thebes

include(dirname(pathof(Thebes)) * "/../data/moreobjects.jl")

moreobjects = [boxcube, boxtorus, concave, cone, crossshape, cube,
cuboctahedron, dodecahedron , geodesic, # helix2, icosahedron,
icosidodecahedron, octahedron, octtorus, rhombicosidodecahedron,
rhombicuboctahedron, rhombitruncated_cubeoctahedron,
rhombitruncated_icosidodecahedron, snub_cube, snub_dodecahedron, sphere2, tet3d,
tetrahedron, triangle, truncated_cube, truncated_dodecahedron,
truncated_icosahedron, truncated_octahedron, truncated_tetrahedron]

objectnames = ["boxcube", "boxtorus", "concave", "cone", "crossshape", "cube",
"cuboctahedron", "dodecahedron", "geodesic", "helix2", "icosahedron",
"icosidodecahedron", "octahedron", "octtorus", "rhombicosidodecahedron",
"rhombicuboctahedron", "rhombitruncated_cubeoctahedron",
"rhombitruncated_icosidodecahedron", "snub_cube", "snub_dodecahedron",
"sphere2", "tet3d", "tetrahedron", "triangle", "truncated_cube",
"truncated_dodecahedron", "truncated_icosahedron", "truncated_octahedron",
"truncated_tetrahedron"]

function mygfunction(vertices, faces, labels; action=:fill)
   if !isempty(faces)
       @layer begin
           for (n, p) in enumerate(faces)
               @layer begin
                   isodd(n) ? sethue("grey30") : sethue("grey90")
                   setopacity(0.5)
                   poly(p, action)
               end

               sethue("black")
               setline(0.5)
               poly(p, :stroke, close=true)

           end
       end
   end
end

function main()
    Drawing(800, 800.0, "/tmp/test-5.svg")
    origin()

    eyepoint(Point3D(500, 500, 500))

    background("azure")
    setopacity(0.5)
    setline(1)
    fontsize(10)
    setlinejoin("bevel")

    tiles = Tiler(800, 800, 6, 6)
    for (pos, n) in tiles
        n > length(moreobjects) && continue
        @layer begin
            translate(pos)
            object = make(moreobjects[n])
            setscale!(object, 15, 15, 15)
            rotateby!(object, 0, 0, 0)
            #sortfaces!(object)
            pin(object, gfunction = mygfunction)
            sethue("black")
            label(string(objectnames[n]), :S, offset=tiles.tileheight/2)
        end
    end
    finish()
end

main()
