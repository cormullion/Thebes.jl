__precompile__(true)

struct Point3D # <: FieldVector{3, Float64}
    x::Float64
    y::Float64
    z::Float64
end

mutable struct Model
    vertices::Vector{Point3D}
    faces
    labels
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
    theta = acos(z/r)
end

mutable struct Projection
    eyepoint::Point3D
    function Projection(pt3D::Point3D)
        return new(pt3D)
    end
end

Projection(rho, theta, phi) = Projection(sphericaltocartesian(rho, theta, phi))

#    rho is distance
#    theta is angle with x axis
#    phi is angle with z axis

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
