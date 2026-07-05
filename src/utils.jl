"""
    axes3D(n=100)

Draw labelled 3D axes at `(0, 0, 0)` with length `n`.
"""
function axes3D(n=100)
    projection = CURRENTPROJECTION[1]
    @layer begin
        fontsize(16)
        setline(2)
        xaxis1 = project(Point3D(0.1, 0.1, 0.1))
        xaxis2 = project(Point3D(n, 0.1, 0.1))
        sethue("red")
        if (xaxis1 != nothing) && (xaxis2 != nothing) && !isapprox(xaxis1, xaxis2)
            arrow(xaxis1, xaxis2)
            label("X", :N, xaxis2)
        end
        yaxis1 = project(Point3D(0.1, 0.1, 0.1))
        yaxis2 = project(Point3D(0.1, n, 0.1))
        sethue("green")

        if (yaxis1 != nothing) && (yaxis2 != nothing) && !isapprox(yaxis1, yaxis2)
            arrow(yaxis1, yaxis2)
            label("Y", :N, yaxis2)
        end
        zaxis1 = project(Point3D(0.1, 0.1, 0.1))
        zaxis2 = project(Point3D(0.1, 0.1, n))
        sethue("blue")
        if (zaxis1 != nothing) && (zaxis2 != nothing) && !isapprox(zaxis1, zaxis2)
            arrow(zaxis1, zaxis2)
            label("Z", :N, zaxis2)
        end
    end
end

"""
    drawcube(n=10, action=:stroke)

Draw a cube. `drawcube(1)` draws a wireframe unit cube.
"""
function drawcube(n=10, action=:stroke)
    @layer begin
        setline(2)
        fontsize(10)
        setlinecap("butt")
        setlinejoin("bevel")
        p1 = project(Point3D(0, 0, 0))
        p2 = project(Point3D(n, 0, 0))
        p3 = project(Point3D(n, n, 0))
        p4 = project(Point3D(0, n, 0))
        p5 = project(Point3D(0, 0, n))
        p6 = project(Point3D(n, 0, n))
        p7 = project(Point3D(n, n, n))
        p8 = project(Point3D(0, n, n))

        if all(i -> i != nothing, [p1, p2, p3, p4]) # , p5, p6, p7, p8])
            sethue("red")
            prettypoly([p1, p2, p3, p4], action, close=true, () -> begin
                circle(O, n / 100)
            end)
        end

        if all(i -> i != nothing, [p1, p2, p6, p5])
            sethue("purple")
            prettypoly([p1, p2, p6, p5], action, close=true, () -> begin
                circle(O, n / 100)
            end)
        end

        if all(i -> i != nothing, [p3, p7, p8, p4])
            sethue("magenta")
            prettypoly([p3, p7, p8, p4], action, close=true, () -> begin
                circle(O, n / 100)
            end)
        end

        if all(i -> i != nothing, [p5, p6, p7, p8])
            sethue("green")
            prettypoly([p5, p6, p7, p8], action, close=true, () -> begin
                circle(O, n / 100)
            end)
        end
    end
end


"""
    carpet(n; kind=:circular)

Draw a circular carpet centered at the origin, using current Luxor parameters.

If `kind` is not `:circular`, the carpet will be a square.

Points that can't be rendered are not included in the final shape.
"""
function carpet(n=100; kind=:circular)
    projection = CURRENTPROJECTION[1]
    @layer begin
        if kind != :circular
            p1 = project(Point3D(-n / 2, -n / 2, 0))
            p2 = project(Point3D(n / 2, -n / 2, 0))
            p3 = project(Point3D(n / 2, n / 2, 0))
            p4 = project(Point3D(-n / 2, n / 2, 0))
            if all(i -> i != nothing, [p1, p2, p3, p4])
                poly([p1, p2, p3, p4], :fill, close=true)
            end
        else
            shape3D = [Point3D(n * cos(theta), n * sin(theta), 0) for theta in 0:0.1:2pi]
            shape2D = Point[]
            for i in shape3D
                pt = project(i)
                if pt != nothing
                    push!(shape2D, pt)
                end
            end
            if length(shape2D) > 1
                poly(shape2D, :fill, close=true)
            end
        end
    end
end

"""
    crossproduct3D(A::Point3D, B::Point3D)

Find one of these.
"""
function crossproduct3D(A::Point3D, B::Point3D)
    x = (A.y * B.z) - (A.z * B.y)
    y = (A.z * B.x) - (A.x * B.z)
    z = (A.x * B.y) - (A.y * B.x)
    return Point3D(x, y, z)
end

"""
    pointsperpendicular(p1::Point3D, p2::Point3D, radius, angles = [0, π])

Find points perpendicular to a line joining p1 and p2.
Points are `radius` units away from the line.
"""
function pointsperpendicular(p1::Point3D, p2::Point3D, radius, angles=[0, π])
    V3 = p2 - p1 # unit vector
    V3 /= distance(Point3D(0.0, 0.0, 0.0), V3)
    e = Point3D(0.0, 0.0, 1.0)
    V1 = crossproduct3D(e, V3) # unit vector perpendicular to both e and V3
    V1 /= distance(Point3D(0.0, 0.0, 0.0), V1)
    V2 = crossproduct3D(V3, V1) # third unit vector perpendicular to both V3 and V1
    # find points P on the circle θ radians relative to vector V1 (x-axis)
    return [p1 + radius * (cos(θ) * V1 + sin(θ) * V2) for θ in angles]
end

"""
    import_off_file(fname)

Import a file in OFF (Object File Format).

Returns a Tuple - vertices, and faces. Vertices is a vector of [x, y, z], and faces a vector of vectors of vertex numbers. 

```julia
off_file = raw"
    OFF
    8 6 0
    -0.500000 -0.500000 0.500000
    0.500000 -0.500000 0.500000
    -0.500000 0.500000 0.500000
    0.500000 0.500000 0.500000
    -0.500000 0.500000 -0.500000
    0.500000 0.500000 -0.500000
    -0.500000 -0.500000 -0.500000
    0.500000 -0.500000 -0.500000
    4 0 1 3 2
    4 2 3 5 4
    4 4 5 7 6
    4 6 7 1 0
    4 1 7 5 3
    4 6 0 2 4
"

f = open("/tmp/cube.off", "w") do f
    write(f, off_file)    
end

@draw begin
    o = make(import_off_file("/tmp/cube.off"))
    scaleby!(o, 100)
    pin(o)
end
```
"""
function import_off_file(fname)
    infile = readlines(open(fname))
    filter!(l -> !isempty(l), infile)
    if !(startswith(infile[1], "OFF") ||
         startswith(infile[1], "COFF"))
        error("not an OFF file")
    end
    i = 2
    while first(strip(infile[i])) == '#'
        i += 1
    end 
    nverts, nfaces, nedges = map(Meta.parse, split(infile[i]))
    @info "reading $nverts vertices, $nfaces faces, $nedges edges"
    vertices = Point3D[]
    i += 1
    while length(vertices) < nverts
        if first(strip(infile[i])) == '#'
            i += 1
            continue
        end
        a, b, c = map(Meta.parse, split(strip(infile[i])))
        push!(vertices, Point3D(a, -b, c))
        i += 1
    end
    faces = Array{Int64,1}[]
    while i <= (nverts + 2 + nfaces) && i <= length(infile)
        vals = map(Meta.parse, split(strip(infile[i]), r"( )+|\t|\#"))
        ta = Int64[]
        for j in 2:(vals[1]+1)
            if !isnothing(j)
                push!(ta, vals[j] + 1)
            end
        end
        if length(ta) > 1
            push!(faces, ta)
        end
        i += 1
    end
    return (vertices, faces)
end
