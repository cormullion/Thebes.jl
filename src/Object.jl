mutable struct Object
    vertices::Vector{Point3D}
    faces::Array{Array{Int64,1},1}
    labels::Array{Int64,1}
    name::String
end

function Base.size(o::Object)
    length(o.vertices)
end

function Base.length(o::Object)
    length(o.vertices)
end

Base.lastindex(o::Object) = length(o)

Base.broadcastable(o::Object) = Ref(o)

"""
    make(primitive, name="unnamed")

`primitive` contains two arrays, an array of 3D points, and an array of faces,
where each face is a list of vertex numbers.

Returns a Object.

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
    pin(Knot, gfunction = (args...) -> poly(args[1], :stroke))
end

The default gfunction expects faces - if there aren't any, use a gfunction that draws vertices.
```
"""
function make(vf, name="unnamed")
    # don't redefine when passed an array
    vertices = deepcopy(vf[1])
    faces    = deepcopy(vf[2])
    labels   = collect(1:length(faces))
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
        if r != nothing
            push!(vertices2D, r)
        else
            push!(vertices2D, Point(NaN, NaN))
        end
    end
    facepolys = Array[]
    if length(o.faces) > 0
        for n in 1:length(o.faces)
            push!(facepolys, vertices2D[o.faces[n]])
        end
    end
    filter!(f -> !isnan(f.x) && !isnan(f.y), vertices2D)
    return (vertices2D, facepolys)
end

"""
    sortfaces!(o::Object;
        eyepoint::Point3D=eyepoint())

Find the averages of the z values of the faces in Object, and sort the faces
of o so that the faces are in order of nearest (highest) z relative to eyepoint...

or something like that ? not sure how this works
"""
function sortfaces!(o::Object;
        eyepoint::Point3D=eyepoint())
    avgs = Float64[]
    for f in o.faces
        vs = o.vertices[f]
        s = 0.0
        for v in vs
            s += distance(v, eyepoint)
        end
        avg = s/length(unique(vs))
        push!(avgs, avg)
    end
    neworder = reverse(sortperm(avgs))
    o.faces = o.faces[neworder]
    o.labels = o.labels[neworder]
    return o
end

sortfaces!(o::Array{Object, 1}; kwargs...) =
   map(sortfaces!, o)

function hiddensurface(o::Object)
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

function wireframe(o::Object)
   if !isempty(o.faces)
       sortfaces!(o)
       @layer begin
           for (n, face) in enumerate(o.faces)
               @layer begin
                   vertices = o.vertices[face]
                   pin(vertices, gfunction = (p3, p2) ->
                    begin
                       poly(p2, :stroke, close=true)
                    end)
               end
           end
       end
   end
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
function pin(o::Object;
    gfunction = (o) -> hiddensurface(o))
    gfunction(o)
end

"""
    moveby!(o::Object, x, y, z)
    moveby!(o::Object, pt::Point3D)

Set the position of object to Point3D(x, y, z).
"""
function moveby!(o::Object, x, y, z)
   for n in 1:length(o.vertices)
       nv = o.vertices[n]
       o.vertices[n] = Point3D(nv.x + x, nv.y + y, nv.z + z)
   end
   return o
end

"""
    moveby(o::Object, x, y, z)
    moveby(o::Object, pt::Point3D)

Set the position of a copy of the object to Point3D(x, y, z).
"""
function moveby(o::Object, x, y, z)
   ocopy = deepcopy(o)
   return moveby!(ocopy, x, y, z)
end

moveby(o::Object, pt::Point3D) = moveby(o::Object, pt.x, pt.y, pt.z)
moveby!(o::Object, pt::Point3D) = moveby!(o::Object, pt.x, pt.y, pt.z)

"""
    scaleby!(o::Object, x, y, z)

Scale object by x in x, y in y, and z in z.
"""
function scaleby!(o::Object, x, y, z)
   for n in 1:length(o.vertices)
       nv = o.vertices[n]
       o.vertices[n] = Point3D(nv.x * x, nv.y * y, nv.z * z)
   end
   return o
end

"""
    face(o::Object, n)
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
    rotateby!(o::Object, r::Rotation)
    rotateby!(o::Object, angleX, angleY, angleZ)

Rotate an object through rotation `r`, or around the x, y,
and/or z axis by `angleX`, `angleY`, `angleZ`.
"""
function rotateby!(o::Object, angleX, angleY, angleZ)
    for n in 1:length(o.vertices)
        o.vertices[n] = RotXYZ(angleX, angleY, angleZ) * o.vertices[n]
    end
    return o
end

function rotateby!(o::Object, r::Rotation)
    for n in 1:length(o.vertices)
        o.vertices[n] = r * o.vertices[n]
    end
    return o
end

"""
    rotateby(o::Object, angleX, angleY, angleZ)

Rotate a copy of the object by angleX, angleY, angleZ.
"""
function rotateby(o::Object, angleX, angleY, angleZ)
    ocopy = deepcopy(o)
    return rotateby!(ocopy, angleX, angleY, angleZ)
end

function rotateby(o::Object, r::Rotation)
    ocopy = deepcopy(o)
    return rotateby!(ocopy, r)
end

"""
    rotateby!(o::Object, pt::Point3D, angleX, angleY, angleZ)
    rotateby!(o::Object, pt::Point3D, r::Rotation=RotXYZ(0, 0, 0))

Rotate an object around a point by rotation r, or angleX, angleY, angleZ.
"""
function rotateby!(o::Object, pt::Point3D, angleX, angleY, angleZ)
    for n in 1:length(o.vertices)
        v = o.vertices[n] - pt
        v = rotateX(v, angleX)
        v = rotateY(v, angleY)
        v = rotateZ(v, angleZ)
        o.vertices[n] = v + pt
    end
    return o
end

function rotateby!(o::Object, pt::Point3D, r::Rotation=RotXYZ(0, 0, 0))
    for n in 1:length(o.vertices)
        v = o.vertices[n] * r
        o.vertices[n] = v
    end
    return o
end

"""
    rotateby(o::Object, pt::Point3D, angleX, angleY, angleZ)
    rotateby(o::Object, pt::Point3D, r::Rotation=RotXYZ(0, 0, 0))

Rotate a copy of the object around a point by rotation r, or angleX, angleY, angleZ.
"""
function rotateby(o::Object, pt::Point3D, angleX, angleY, angleZ)
    ocopy = deepcopy(o)
    return rotateby!(ocopy, pt, angleX, angleY, angleZ)
end

function rotateby(o::Object, pt::Point3D, r::Rotation=RotXYZ(0, 0, 0))
    ocopy = deepcopy(o)
    return rotateby!(ocopy, pt, r)
end
