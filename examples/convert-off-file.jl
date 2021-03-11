using Thebes

function convert_off_file(fname)
    infile = readlines(open(fname))
    filter!(l -> !isempty(l), infile)
    @show infile[1]
    if ! startswith(infile[1], "OFF")
        error("not an OFF file")
    end
    nverts, nfaces, nedges = map(Meta.parse, split(infile[2]))
    vertices = Point3D[]
    for i in 3:nverts+2
        a, b, c = map(Meta.parse, split(strip(infile[i])))
        push!(vertices, Point3D(a, -b, c))
    end

    faces = Array{Int64, 1}[]
    for i in nverts + 2 + 1: nverts + 2 + nfaces
        vals = map(Meta.parse, split(strip(infile[i]), r" |\t"))
        ta = Int64[]
        for j in 2:vals[1] + 1
            push!(ta, vals[j] + 1)
        end
        push!(faces, ta)
    end
    return (vertices, faces)
end


# cd(expanduser("/tmp/geometry"))
# iobuffer = IOBuffer()
#
# for f in ["boxcube.off", "boxtorus.off", "concave.off", "cone.off", "cross.off", "cube.off",
# "cuboctahedron.off", "dodecahedron.off", "geodesic.off", "helix2.off", "icosahedron.off",
# "icosidodecahedron.off", "octahedron.off", "octtorus.off", "rhombicosidodecahedron.off",
# "rhombicuboctahedron.off", "rhombitruncated_cubeoctahedron.off",
# "rhombitruncated_icosidodecahedron.off", "snub_cube.off", "snub_dodecahedron.off",
# "sphere2.off", "tet3d.off", "tetrahedron.off", "triangle.off", "truncated_cube.off",
# "truncated_dodecahedron.off", "truncated_icosahedron.off", "truncated_octahedron.off",
# "truncated_tetrahedron.off"]
#     fname, _ = splitext(f)
#     object = convert_off_file(f)
#     println(iobuffer, fname, " ", object)
# end
#
#=open("/tmp/objects.txt", "w") do f
    write(f, String(take!(iobuffer)))
end
for f in readdir()
object = convert_off_file(f)
println(iobuffer, f, " ", object)
end
=#

sphere1  = convert_off_file("/tmp/Untitled.obj.off")
