__precompile__(true)

struct Point3D
    x::Float64
    y::Float64
    z::Float64
end

mutable struct Model
    vertices::Vector{Point3D}
    faces
    labels
end

mutable struct Projection
    w::Float64
    h::Float64
    eyepoint::Point3D
end

import Base: +, -, *, /, ^, !=, <, >, ==, norm
import Base: isequal, isless, isapprox, cmp, dot, size, getindex

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
Base.getindex(p::Point3D, i) = [p.x, p.y, p.z][i]
