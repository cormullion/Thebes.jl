mutable struct Object
    vertices::Vector{Point3D}
    faces::Array{Array{Int64, 1}, 1}
    labels::Array{Int64, 1}
    name::String
end

function Base.size(o::Object)
    return length(o.vertices)
end

function Base.length(o::Object)
    return length(o.vertices)
end

Base.lastindex(o::Object) = length(o)

Base.broadcastable(o::Object) = Ref(o)

"""
    make(primitive, name="unnamed")

`primitive` contains two arrays, an array of 3D points, and an array of faces,
where each face is a list of vertex numbers.

Returns a Object.

The following objects are defined (stored in the file `("/data/objects.jl")`:

    boxcube, boxtorus, concave, cone, crossshape, cube, cuboctahedron, dodecahedron, geodesic, helix2,
    icosahedron, icosidodecahedron, octahedron, octtorus, rhombicosidodecahedron,
    rhombicuboctahedron, rhombitruncated_cubeoctahedron, rhombitruncated_icosidodecahedron,
    snub_cube, snub_dodecahedron, sphere2, tet3d, tetrahedron, triangle, truncated_cube, 
    truncated_dodecahedron, truncated_icosahedron, truncated_octahedron, truncated_tetrahedron

Example

    make(Cube, "cube")

returns an Object object containing an array of vertices, an array of faces,
and an array of labels.

```
@draw begin
    helloworld()
    tol = 0.01
    a = []
    sethue("black")
    for t in -2pi:tol:2pi
        push!(a, Point3D((50 + cos(5t)) * cos(3t), (50 + cos(5t)) * sin(2t), sin(5t)))
    end
    Knot = make((a, []), "knot")
    pin(Knot, gfunction=(args...) -> begin
        for verts in args[1].vertices
            pin(verts)
        end
    end)
end
```

The default gfunction expects faces - if there aren't any, use a gfunction that draws vertices.
"""
function make(vf, name = "unnamed")
    # don't redefine when passed an array
    vertices = deepcopy(vf[1])
    faces = deepcopy(vf[2])
    labels = collect(eachindex(faces))
    return Object(vertices, faces, labels, name)
end

include("../data/objects.jl")

# don't load all these now!
# include("moreobjects.jl")

"""
    objecttopoly(o::Object)

Return a tuple:

- an array of 2D points representing the vertices of `o`

- an array of 2D polygons representing the faces of `o`

## Example

This example draws the faces of a cube in colors, and marks
the vertices in black.

```
using Luxor, Thebes

@draw begin
    helloworld()
    o = make(Cube)
    scaleby!(o, 100, 100, 100)
    vs, fs = objecttopoly(o)
    setopacity(0.4)
    sethue("black")
    for face in fs
        randomhue()
        poly(face, :fill)
    end
    sethue("black")
    circle.(vs, 3, :fill)
end
```
"""
function objecttopoly(o::Object)
    vertices2D = Point[]
    for v in o.vertices
        r = project(v)
        if r !== nothing
            push!(vertices2D, r)
        else
            push!(vertices2D, Point(NaN, NaN))
        end
    end
    facepolys = Array[]
    if length(o.faces) > 0
        for n in eachindex(o.faces)
            push!(facepolys, vertices2D[o.faces[n]])
        end
    end
    filter!(f -> !isnan(f.x) && !isnan(f.y), vertices2D)
    return (vertices2D, facepolys)
end

@inline function _ndistinct(vs, f)
    c = 0
    @inbounds for i in eachindex(f)
        dup = false
        for j in 1:(i - 1)
            if vs[f[j]] == vs[f[i]]
                dup = true
                break
            end
        end
        c += !dup
    end
    return c
end

"""
    sortfaces!(o::Object;
        eyepoint::Point3D=eyepoint())

Find the averages of the z values of the faces in Object, and sort the faces
of o so that the faces are in order of nearest (highest) z relative to eyepoint...
"""
function sortfaces!(o::Object; eyepoint::Point3D = eyepoint())
    vs = o.vertices
    avgs = Vector{Float64}(undef, length(o.faces))
    @inbounds for (k, f) in enumerate(o.faces)
        s = 0.0
        for i in f
            s += distance(vs[i], eyepoint)
        end
        avgs[k] = s / _ndistinct(vs, f)
    end
    neworder = reverse!(sortperm(avgs))   # reverse!(sortperm) keeps the original tie order
    o.faces = o.faces[neworder]
    o.labels = o.labels[neworder]
    return o
end

sortfaces!(o::Array{Object, 1}; kwargs...) =
    map(sortfaces!, o)

function _normal_idx(vs, face)          # surfacenormal without the copy or the extra /l
    nx = ny = nz = 0.0
    n = length(face)
    @inbounds for i in 1:n
        c = vs[face[i]]
        d = vs[face[i == n ? 1 : i + 1]]
        nx += (c.y - d.y) * (c.z + d.z)
        ny += (c.z - d.z) * (c.x + d.x)
        nz += (c.x - d.x) * (c.y + d.y)
    end
    return Point3D(nx, ny, nz)
end

"""
    hiddensurface(o::Object)

Given an object `o`, sort the faces in `o.faces`, 
then draw filled grey polygons for each face.
"""

function hiddensurface(o::Object)
    isempty(o.faces) && return nothing
    sortfaces!(o)
    nv = length(o.vertices)
    pts = Vector{Point}(undef, nv)
    vis = Vector{Bool}(undef, nv)
    @inbounds for i in 1:nv
        r = project(o.vertices[i])
        vis[i] = r !== nothing
        pts[i] = r === nothing ? Point(NaN, NaN) : r
    end
    eye = eyepoint()
    buf = Point[]
    @layer begin                                  # one save/restore for the whole object
        @inbounds for face in o.faces
            ang = anglebetweenvectors(_normal_idx(o.vertices, face), eye)
            setgrey(rescale(ang, 0, π, 1, 0))
            ok = true
            for i in face
                ok &= vis[i]
            end
            ok || continue                        # original drew nothing visible for these either
            resize!(buf, length(face))
            for k in eachindex(face)
                buf[k] = pts[face[k]]
            end
            poly(buf, :none, close = true)
            fillpreserve()
            sethue(1.0, 1.0, 1.0)
            strokepath()
        end
    end
    return nothing
end

function _projectvertices(o::Object)
    # Project every vertex once; 
    # shared by hiddensurface() and wireframe()
    nv = length(o.vertices)
    pts = Vector{Point}(undef, nv)
    vis = Vector{Bool}(undef, nv)
    @inbounds for i in 1:nv
        r = project(o.vertices[i])
        vis[i] = r !== nothing
        pts[i] = r === nothing ? Point(NaN, NaN) : r
    end
    return pts, vis
end

"""
    wireframe(o::Object)

Given an object `o`, sort the faces in `o.faces`, 
then draw grey stroked polygons for each face.    

"""
function wireframe(o::Object)
    isempty(o.faces) && return nothing
    sortfaces!(o)
    pts, vis = _projectvertices(o)
    buf = Point[]
    @layer begin
        for face in o.faces
            ok = true
            for i in face
                ok &= vis[i]
            end
            ok || continue # original drew nothing visible
            resize!(buf, length(face))
            for k in eachindex(face)
                buf[k] = pts[face[k]]
            end
            poly(buf, :stroke, close=true)
        end
    end
    return nothing
end

"""
    pin(o::Object;
        gfunction=(o) -> hiddensurface(o))

Draw a rendering of an object.

The default rendering function is `hiddensurface()`.

You can also use the built-in `wireframe()` rendering function.

## Examples

```
@draw begin
    o = make(Cube)
    axes3D(200)
    scaleby!(o, 200, 200, 200)
    eyepoint(250, 270, 300)
    pin(o) # use an attempted hiddensurface rendering

    o = make(Tetrahedron)
    axes3D(200)
    scaleby!(o, 200, 200, 200)
    eyepoint(250, 270, 300)
    pin(o, gfunction=wireframe) # use a wireframe rendering
end
```
## More help

You could write your own rendering function to draw objects.

```
function a_rendering_function(o::Object)
   if !isempty(o.faces)
       sortfaces!(o)
       @layer begin
           for (n, face) in enumerate(o.faces)
               @layer begin
                   vertices = o.vertices[face]
                   sn = surfacenormal(vertices)
                   ang = anglebetweenvectors(sn, eyepoint())
                   setgrey(rescale(ang, 0, π, 1, 0))
                   pin(vertices, gfunction = (p3, p2) ->
                    begin
                       poly(p2, :fill)
                       sethue("white")
                       poly(p2, :stroke, close=true)
                    end)
               end
           end
       end
   end
end
```
"""
function pin(
        o::Object;
        gfunction = (o) -> hiddensurface(o)
    )
    return gfunction(o)
end

"""
    copyobject(o)

Make a copy of an object.
"""
copyobject(o::Object) =
    Object(copy(o.vertices), [copy(f) for f in o.faces], copy(o.labels), o.name * " copy")

"""
    moveby!(o::Object, x, y, z)
    moveby!(o::Object, pt::Point3D)

Set the position of object to `Point3D(x, y, z)`.
"""
function moveby!(o::Object, x, y, z)
    for n in eachindex(o.vertices)
        nv = o.vertices[n]
        o.vertices[n] = Point3D(nv.x + x, nv.y + y, nv.z + z)
    end
    return o
end

"""
    moveby(o::Object, x, y, z)

Set the position of a copy of the object to `Point3D(x, y, z)`.
"""
function moveby(o::Object, x, y, z)
    ocopy = deepcopy(o)
    return moveby!(ocopy, x, y, z)
end

moveby(o::Object, pt::Point3D) = moveby(o::Object, pt.x, pt.y, pt.z)

"""
    moveby!(o::Object, pt::Point3D)

Set the position of the object to `pt`.
"""
moveby!(o::Object, pt::Point3D) = moveby!(o::Object, pt.x, pt.y, pt.z)

"""
    scaleby!(o::Object, x, y, z)

Scale object by `x` in x, `y` in y, and `z` in z.
"""
function scaleby!(o::Object, x, y, z)
    for n in eachindex(o.vertices)
        nv = o.vertices[n]
        o.vertices[n] = Point3D(nv.x * x, nv.y * y, nv.z * z)
    end
    return o
end

"""
    scaleby!(o::Object, d)

Scale object by d in x, d in y, and d in z.
"""
scaleby!(o::Object, d) = scaleby!(o, d, d, d)

"""
    face(o::Object, n)

Return a vector of the 3D points that describe the `n`th face 
of the object.
"""
function face(o::Object, n)
    facepoints = Point3D[]
    if length(o.faces) > 0
        for i in o.faces[n]
            push!(facepoints, o.vertices[i])
        end
    end
    return facepoints
end

"""
    rotateby!(o::Object, angleX, angleY, angleZ)

Rotate an object through rotation `r` around the x, y,
and/or z axis by `angleX`, `angleY`, `angleZ`.
"""
function rotateby!(o::Object, angleX, angleY, angleZ)
    for n in eachindex(o.vertices)
        o.vertices[n] = RotXYZ(angleX, angleY, angleZ) * o.vertices[n]
    end
    return o
end

"""
    rotateby!(o::Object, r::Rotation)

Rotate an object through rotation `r`.
"""
function rotateby!(o::Object, r::Rotation)
    for n in eachindex(o.vertices)
        o.vertices[n] = r * o.vertices[n]
    end
    return o
end

"""
    rotateby(o::Object, angleX, angleY, angleZ)

Rotate a copy of the object by `angleX`, `angleY`, `angleZ`.
"""
function rotateby(o::Object, angleX, angleY, angleZ)
    ocopy = copyobject(o)
    return rotateby!(ocopy, angleX, angleY, angleZ)
end

"""
    rotateby(o::Object, r:Rotation)

Rotate a copy of the object by the Rotation `r`.
"""
function rotateby(o::Object, r::Rotation)
    ocopy = copyobject(o)
    return rotateby!(ocopy, r)
end

"""
    rotateby!(o::Object, pt::Point3D, angleX, angleY, angleZ)

Rotate an object around a point by `angleX`, `angleY`, `angleZ`.
"""
function rotateby!(o::Object, pt::Point3D, angleX, angleY, angleZ)
    for n in eachindex(o.vertices)
        v = o.vertices[n] - pt
        v = rotateX(v, angleX)
        v = rotateY(v, angleY)
        v = rotateZ(v, angleZ)
        o.vertices[n] = v + pt
    end
    return o
end

"""
    rotateby!(o::Object, pt::Point3D, r::Rotation=RotXYZ(0, 0, 0))

Rotate an object around a point by rotation `r`, or `angleX`, `angleY`, `angleZ`.
"""
function rotateby!(o::Object, pt::Point3D, r::Rotation=RotXYZ(0, 0, 0))
    for n in eachindex(o.vertices)
        o.vertices[n] = r * (o.vertices[n] - pt) + pt
    end
    return o
end

"""
    rotateby(o::Object, pt::Point3D, angleX, angleY, angleZ)

Rotate a copy of the object around a point by rotation `r`, or `angleX`, `angleY`, `angleZ`.
"""
function rotateby(o::Object, pt::Point3D, angleX, angleY, angleZ)
    ocopy = copyobject(o)
    return rotateby!(ocopy, pt, angleX, angleY, angleZ)
end

"""
    rotateby(o::Object, pt::Point3D, r::Rotation=RotXYZ(0, 0, 0))

Rotate a copy of the object around a point by rotation `r`.
"""
function rotateby(o::Object, pt::Point3D, r::Rotation = RotXYZ(0, 0, 0))
    ocopy = copyobject(o)
    return rotateby!(ocopy, pt, r)
end
