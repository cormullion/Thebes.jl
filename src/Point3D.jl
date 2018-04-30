mutable struct Point3D
   x::Float64
   y::Float64
   z::Float64
end

import Base: +, -, ==, norm
import Base: size, getindex, isnan

"""
    norm(p1::Point3D, p2::Point3D)
"""

function +(p1::Point3D, p2::Point3D)
    Point3D((p2.x + p1.x), (p2.y + p1.y), (p2.z + p1.z))
end

function -(p1::Point3D, p2::Point3D)
    Point3D((p2.x - p1.x), (p2.y - p1.y), (p2.z - p1.z))
end

function ==(p1::Point3D, p2::Point3D)
    p1.x == p2.x && p1.y == p2.y && p1.z == p2.z
end

function norm(p1::Point3D, p2::Point3D)
    sqrt((p2.x - p1.x)^2 + (p2.y - p1.y)^2 + (p2.z - p1.z)^2)
end

function isnan(pt::Point3D)
    isnan(pt.x) || isnan(pt.y)
end

# for broadcasting
Base.size(::Point3D) = 3
Base.getindex(p::Thebes.Point3D, i::Int64) = [p.x, p.y, p.z][i]
Base.convert(::Type{Luxor.Point}, v::AbstractVector) = Luxor.Point(v[1], v[2])
