__precompile__(true)

"""
    throwaway experiments in 2.5D graphics
"""
module Thebes

using Luxor
# using StaticArrays, CoordinateTransformations

export convertpoint,
       Point3D, Model, AxesWire,
       Cube, Tetrahedron, Pyramid, Carpet,
       make,
       rotateX, rotateY, rotateZ,
       rotateto!, rotateto,
       rotateby!, rotateby,
       changeposition!, changeposition,
       drawmodel, modeltopoly,
       changescale!, sortfaces!

struct Point3D
    x::Float64
    y::Float64
    z::Float64
end

mutable struct Model
    vertices::Vector{Point3D}
    faces
    labels
    name::String
end

"""
    make(primitive, name="unnamed")

`primitive` is a variable holding the two arrays.

Eg

    make(Cube, "cube")

returns a Model object containing an array of vertices, and array of faces,
and an array of labels.
"""
function make(vf, name="unnamed")
    # don't redefine when passed an array
    vertices = deepcopy(vf[1])
    faces    = deepcopy(vf[2])
    labels   = collect(1:length(faces))
    return Model(vertices, faces, labels, name)
end

import Base: +, -, !=, <, >, ==, norm
import Base: size, getindex

function norm(p1::Point3D, p2::Point3D)
    sqrt((p2.x - p1.x)^2 + (p2.y - p1.y)^2 + (p2.z - p1.z)^2)
end

function -(p1::Point3D, p2::Point3D)
    Point3D((p2.x - p1.x), (p2.y - p1.y), (p2.z - p1.z))
end

function +(p1::Point3D, p2::Point3D)
    Point3D((p2.x + p1.x), (p2.y + p1.y), (p2.z + p1.z))
end

# for broadcasting
Base.size(::Point3D) = 3
Base.getindex(p::Thebes.Point3D, i::Int64) = [p.x, p.y, p.z][i]
Base.convert(::Type{Luxor.Point}, v::AbstractVector) = Luxor.Point(v[1], v[2])

include("objects.jl")

# don't load all these now!
# include("moreobjects.jl")

function convertpoint(pt3D::Point3D, camerapoint::Point3D)
    focallength = norm(camerapoint, Point3D(0, 0, 0))
    multiplier = focallength/(focallength + pt3D.z) # z co-ordinate
    x = pt3D.x * multiplier # x co-ordinate
    y = pt3D.y * multiplier # y co-ordinate
    return Point(x, y)
end

function sphericaltocartesian(rho, theta, phi)
    x = rho * sin(phi) * cos(theta)
    y = rho * sin(phi) * sin(theta)
    z = rho * cos(phi)
    return Point3D(x, y, z)
end

function cartesiantospherical(x, y, z)
    phi = atan2(y, x)
    rho = sqrt(x^2 + y^2 + z^2)
    theta = acos(z/rho)
    return (phi, rho, theta)
end

"""
    modeltopoly(m::Model, camerapoint)

"""
function modeltopoly(m::Model, camerapoint::Point3D)
    vertices2D = Point[]
    for v in m.vertices
        push!(vertices2D, convertpoint(v, camerapoint))
    end
    facepolys = []
    if length(m.faces) > 0
        for f in m.faces
            push!(facepolys, vertices2D[f])
        end
    end
    return (vertices2D, facepolys)
end

"""
    sortfaces(m::Model)

find the averages of the z values of the faces in model, and sort the faces
of m so that the faces are in order of nearest (highest) z?.
"""
function sortfaces!(m::Model)
    avgs = Float64[]
    for f in m.faces
        vs = m.vertices[f]
        s = 0.0
        for v in vs
            s += v.z
        end
        avgz = s/length(vs)
        push!(avgs, avgz)
    end
    neworder = sortperm(avgs)
    m.faces = m.faces[neworder]
    m.labels = m.labels[neworder]
    return m
end

function simplerender(vertices, faces, labels, cols)
    if !isempty(faces)
        @layer begin
            for (n, p) in enumerate(faces)
                x = mod1(n, length(cols))
                c = cols[mod1(labels[x], length(cols))]
                sethue(c)
                poly(p, :fill, close=true)
            end
        end
    else
        @layer begin
            sethue(cols[1])
            poly(vertices, :stroke, close=true)
        end
    end
end

"""
    drawmodel(object, Point3D(100, 100, 100),
        :fill,
        cols=["black", "white"],
        renderfunc = arenderfunction)

draw a model

change default rendering function:

```
function myrenderfunction(vertices, faces, labels, cols, action=:fill)
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

o = :cube
object = make(eval(o), string(o))
changescale!(object, 15, 15, 15)
rotateby!(object, object.vertices[1], rand(), rand(), rand())
sortfaces!(object)
drawmodel(object, Point3D(100, 100, 100),
    :fill,
    cols=[randomhue(), "azure"],
    renderfunc = myrenderfunction)
end
```
"""
function drawmodel(m::Model, camerapoint::Point3D, action=:stroke;
    cols=["black", "grey80"],
    renderfunc = (v, f, l, c) -> simplerender(v, f, l, c))

    vertices, faces = modeltopoly(m, camerapoint)
    renderfunc(vertices, faces, m.labels, cols)
end

function changeposition!(m::Model, x, y, z)
    for n in 1:length(m.vertices)
        nv = m.vertices[n]
        m.vertices[n] = Point3D(nv.x + x, nv.y + y, nv.z + z)
    end
    return m
end

function changeposition(m::Model, x, y, z)
    mcopy = deepcopy(m)
    return changeposition!(mcopy, x, y, z)
end

changeposition(m::Model, pt::Point3D) = changeposition(m::Model, pt.x, pt.y, pt.z)
changeposition!(m::Model, pt::Point3D) = changeposition!(m::Model, pt.x, pt.y, pt.z)

"""
    changescale!(m::Model, x, y, z)

"""
function changescale!(m::Model, x, y, z)
    for n in 1:length(m.vertices)
        nv = m.vertices[n]
        m.vertices[n] = Point3D(nv.x * x, nv.y * y, nv.z * z)
    end
    return m
end

# rotations are anticlockwise when looking along axis from 0 to +axis
"""
    rotate around x axis
"""
function rotateX(pt3D::Point3D, rad)
    cosa = cos(rad)
    sina = sin(rad)
    y = pt3D.y * cosa - pt3D.z * sina
    z = pt3D.y * sina + pt3D.z * cosa
    return Point3D(pt3D.x, y, z)
end

"""
    rotate around y axis
"""
function rotateY(pt3D::Point3D, rad)
    cosa = cos(rad)
    sina = sin(rad)
    z = pt3D.z * cosa - pt3D.x * sina
    x = pt3D.z * sina + pt3D.x * cosa
    return Point3D(x, pt3D.y, z)
end

"""
rotate around z axis to an angle
"""
function rotateZ(pt3D::Point3D, rad)
    cosa = cos(rad)
    sina = sin(rad)
    x = pt3D.x * cosa - pt3D.y * sina
    y = pt3D.x * sina + pt3D.y * cosa
    return Point3D(x, y, pt3D.z)
end

# rotate model to an angle
function rotateto!(m::Model, angleX, angleY, angleZ)
    for n in 1:length(m.vertices)
        v = m.vertices[n]
        v = rotateX(v, angleX)
        v = rotateY(v, angleY)
        v = rotateZ(v, angleZ)
        m.vertices[n] = v
    end
    return m
end

# make a rotated copy
function rotateto(m::Model, angleX, angleY, angleZ)
    mcopy = deepcopy(m)
    return rotateto!(mcopy, angleX, angleY, angleZ)
end

# rotate model by an angle
function rotateby!(m::Model, pt::Point3D, angleX, angleY, angleZ)
    for n in 1:length(m.vertices)
        v = m.vertices[n] - pt
        v = rotateX(v, angleX)
        v = rotateY(v, angleY)
        v = rotateZ(v, angleZ)
        m.vertices[n] = v + pt
    end
    return m
end

# rotate a copy by an angle
function rotateby(m::Model, pt::Point3D, angleX, angleY, angleZ)
    mcopy = deepcopy(m)
    return rotateby!(mcopy, pt, angleX, angleY, angleZ)
end

end
