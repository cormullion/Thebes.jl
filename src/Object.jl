mutable struct Object
    vertices::Vector{Point3D}
    faces::Array{Array{Int64,1},1}
    labels::Array{Int64,1}
    name::String
end

function Base.size(m::Object)
       length(m.vertices)
end

function Base.length(m::Object)
       length(m.vertices)
end

Base.lastindex(m::Object) = length(m)

Base.broadcastable(m::Object) = Ref(m)

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
    objecttopoly(m::Object)

Return a list of 2D points representing the 3D Object in `m`.
"""
function objecttopoly(m::Object)
    vertices2D = Point[]

    for v in m.vertices
        r = project(v)
        if r != nothing
            push!(vertices2D, r)
        else
            push!(vertices2D, Point(NaN, NaN))
        end
    end
    facepolys = Array[]
    if length(m.faces) > 0
        for n in 1:length(m.faces)
            push!(facepolys, vertices2D[m.faces[n]])
        end
    end
    filter!(f -> !isnan(f.x) && !isnan(f.y), vertices2D)
    return (vertices2D, facepolys)
end

"""
    sortfaces!(m::Object;
        eyepoint::Point3D=Point3D(0, 0, 0))

Find the averages of the z values of the faces in Object, and sort the faces
of m so that the faces are in order of nearest (highest) z relative to eyepoint...

or something like that ? not sure how this works
"""
function sortfaces!(m::Object;
        eyepoint::Point3D=eyepoint())
    avgs = Float64[]
    for f in m.faces
        vs = m.vertices[f]
        s = 0.0
        for v in vs
            s += distance(v, eyepoint)
        end
        avg = s/length(unique(vs))
        push!(avgs, avg)
    end
    neworder = reverse(sortperm(avgs))
    m.faces = m.faces[neworder]
    m.labels = m.labels[neworder]
    return m
end

sortfaces!(m::Array{Object, 1}; kwargs...) =
   map(sortfaces!, m)


"""
    simplegfunction(vertices, faces, labels; action=:stroke)

In a Luxor drawing, draw the 2D vertices and faces, using alternating grey shades.

"""
function simplegfunction(vertices, faces, labels; action=:fill)
   if !isempty(faces)
       @layer begin
           for (n, p) in enumerate(faces)
               @layer begin
                   isodd(n) ? sethue("grey20") : sethue("grey80")
                   poly(p, action)
               end
               sethue("black")
               setline(0.5)
               poly(p, :stroke, close=true)
           end
       end
   end
end


"""
    pin(m::Object;
        gfunction = (v, f, l; kwargs... ) -> simplegfunction(v, f, l; kwargs...))

Draw an object, calling a gfunction, the default is `simplegfunction()`.

To define and change the default gfunction:

```
function mygfunction(vertices, faces, labels; action=:fill)
    setlinejoin("bevel")
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

@svg begin
    helloworld()
    object = make(Cube)
    scaleby!(object, 100, 100, 100)
    rotateby!(object, object.vertices[1], rand(), rand(), rand())
    sortfaces!(object)
    pin(object, gfunction = mygfunction)
end
```
"""
function pin(m::Object;
      gfunction = (v, f, l; kwargs... ) -> simplegfunction(v, f, l; kwargs...))
   vertices, faces = objecttopoly(m)
   gfunction(vertices, faces, m.labels)
end

function pin(m::Array{Object, 1};
      gfunction = (v, f, l; kwargs... ) -> simplegfunction(v, f, l; kwargs...))
   vertices, faces = objecttopoly.(m)
   gfunction.(vertices, faces, m.labels)
end

"""
    moveby!(m::Object, x, y, z)
    moveby!(m::Object, pt::Point3D)

Set the position of object to Point3D(x, y, z).
"""
function moveby!(m::Object, x, y, z)
   for n in 1:length(m.vertices)
       nv = m.vertices[n]
       m.vertices[n] = Point3D(nv.x + x, nv.y + y, nv.z + z)
   end
   return m
end

"""
    moveby(m::Object, x, y, z)
    moveby(m::Object, pt::Point3D)

Set the position of a copy of the object to Point3D(x, y, z).
"""
function moveby(m::Object, x, y, z)
   mcopy = deepcopy(m)
   return moveby!(mcopy, x, y, z)
end

moveby(m::Object, pt::Point3D) = moveby(m::Object, pt.x, pt.y, pt.z)
moveby!(m::Object, pt::Point3D) = moveby!(m::Object, pt.x, pt.y, pt.z)

"""
    scaleby!(m::Object, x, y, z)

Scale object by x in x, y in y, and z in z.
"""
function scaleby!(m::Object, x, y, z)
   for n in 1:length(m.vertices)
       nv = m.vertices[n]
       m.vertices[n] = Point3D(nv.x * x, nv.y * y, nv.z * z)
   end
   return m
end

"""
    face(m::Object, n)
"""
function face(m::Object, n)
   facepoints = Point3D[]
   if length(m.faces) > 0
       for i in m.faces[n]
           push!(facepoints, m.vertices[i])
       end
   end
   return facepoints
end

"""
    rotateby!(m::Object, r::Rotation)
    rotateby!(m::Object, angleX, angleY, angleZ)

Rotate an object through rotation `r`, or around the x, y,
and/or z axis by `angleX`, `angleY`, `angleZ`.
"""
function rotateby!(m::Object, angleX, angleY, angleZ)
    for n in 1:length(m.vertices)
        v = m.vertices[n]
        RotXYZ(angleX, angleY, angleZ)
        m.vertices[n] = v
    end
    return m
end

function rotateby!(m::Object, r::Rotation)
    for n in 1:length(m.vertices)
        v = m.vertices[n] * r
        m.vertices[n] = v
    end
    return m
end

"""
    rotateby(m::Object, angleX, angleY, angleZ)

Rotate a copy of the object by angleX, angleY, angleZ.
"""
function rotateby(m::Object, angleX, angleY, angleZ)
    mcopy = deepcopy(m)
    return rotateby!(mcopy, angleX, angleY, angleZ)
end

function rotateby(m::Object, r::Rotation)
    mcopy = deepcopy(m)
    return rotateby!(mcopy, r)
end

"""
    rotateby!(m::Object, pt::Point3D, angleX, angleY, angleZ)
    rotateby!(m::Object, pt::Point3D, r::Rotation=RotXYZ(0, 0, 0))

Rotate an object around a point by rotation r, or angleX, angleY, angleZ.
"""
function rotateby!(m::Object, pt::Point3D, angleX, angleY, angleZ)
    for n in 1:length(m.vertices)
        v = m.vertices[n] - pt
        v = rotateX(v, angleX)
        v = rotateY(v, angleY)
        v = rotateZ(v, angleZ)
        m.vertices[n] = v + pt
    end
    return m
end

function rotateby!(m::Object, pt::Point3D, r::Rotation=RotXYZ(0, 0, 0))
    for n in 1:length(m.vertices)
        v = m.vertices[n] * r
        m.vertices[n] = v
    end
    return m
end

"""
    rotateby(m::Object, pt::Point3D, angleX, angleY, angleZ)
    rotateby(m::Object, pt::Point3D, r::Rotation=RotXYZ(0, 0, 0))

Rotate a copy of the object around a point by rotation r, or angleX, angleY, angleZ.
"""
function rotateby(m::Object, pt::Point3D, angleX, angleY, angleZ)
    mcopy = deepcopy(m)
    return rotateby!(mcopy, pt, angleX, angleY, angleZ)
end

function rotateby(m::Object, pt::Point3D, r::Rotation=RotXYZ(0, 0, 0))
    mcopy = deepcopy(m)
    return rotateby!(mcopy, pt, r)
end
