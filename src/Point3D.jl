mutable struct Point3D
   x::Float64
   y::Float64
   z::Float64
end

import Base: +, -, ==, norm, *, ^, <, >, /, !=
import Base: size, getindex, isnan, isapprox, isequal, isless

"""
    norm(p1::Point3D, p2::Point3D)
"""

function +(p1::Point3D, p2::Point3D)
    Point3D((p2.x + p1.x), (p2.y + p1.y), (p2.z + p1.z))
end
+(p1::Point3D, k::Number)              = Point3D(p1.x + k, p1.y + k, p1.z + k)
+(p1::Point3D, p2::Point3D)            = Point3D(p1.x + p2.x, p1.y + p2.y, p1.z + p2.z)

function -(p1::Point3D, p2::Point3D)
    Point3D((p1.x - p2.x), (p1.y - p2.y), (p1.z - p2.z))
end
-(p::Point3D)                          = Point3D(-p.x, -p.y, -p.z)
-(k::Number, p1::Point3D)              = Point3D(p1.x - k, p1.y - k, p1.z - k)
-(p1::Point3D, k::Number)              = Point3D(p1.x - k, p1.y - k, p1.z - k)

*(k::Number, p2::Point3D)              = Point3D(k * p2.x, k * p2.y, k * p2.z)
*(p2::Point3D, k::Number)              = Point3D(k * p2.x, k * p2.y, k * p2.z)
*(p1::Point3D, p2::Point3D)            = Point3D(p1.x * p2.x, p1.y * p2.y, p1.z * p2.z)

function ==(p1::Point3D, p2::Point3D)
    p1.x == p2.x && p1.y == p2.y && p1.z == p2.z
end

function norm(p1::Point3D, p2::Point3D)
    sqrt((p2.x - p1.x)^2 + (p2.y - p1.y)^2 + (p2.z - p1.z)^2)
end

function isnan(pt::Point3D)
    isnan(pt.x) || isnan(pt.y) || isnan(pt.z)
end

function between(p1::Point3D, p2::Point3D, x=0.5)
    return p1 + (x * (p2 - p1))
end

function between(couple::NTuple{2, Point3D}, x=0.5)
    p1, p2 = couple
    return p1 + (x * (p2 - p1))
end

# for broadcasting
Base.size(::Point3D) = 3
Base.getindex(p::Thebes.Point3D, i::Int64) = [p.x, p.y, p.z][i]

/(p2::Point3D, k::Number)              = Point3D(p2.x/k, p2.y/k, p2.z/k)
^(p::Point3D, e::Integer)              = Point3D(p.x^e,  p.y^e, p.z^e)
^(p::Point3D, e::Float64)              = Point3D(p.x^e,  p.y^e, p.z^e)

# some refinements
# modifying points with tuples
+(p1::Point3D, shift::NTuple{3, Real}) = Point3D(p1.x + shift[1], p1.y + shift[2], p1.z + shift[3])
-(p1::Point3D, shift::NTuple{3, Real}) = Point3D(p1.x - shift[1], p1.y - shift[2], p1.z - shift[3])
*(p1::Point3D, shift::NTuple{3, Real}) = Point3D(p1.x * shift[1], p1.y * shift[2], p1.z * shift[3])
/(p1::Point3D, shift::NTuple{3, Real}) = Point3D(p1.x / shift[1], p1.y / shift[2], p1.z / shift[3])

# comparisons

isequal(p1::Point3D, p2::Point3D)         = isapprox(p1.x, p2.x, atol=0.00000001) && isapprox(p1.y, p2.y, atol=0.00000001) && isapprox(p1.z, p2.z, atol=0.00000001)
isapprox(p1::Point3D, p2::Point3D)        = isapprox(p1.x, p2.x, atol=0.00000001) && isapprox(p1.y, p2.y, atol=0.00000001) && isapprox(p1.z, p2.z, atol=0.00000001)
isless(p1::Point3D, p2::Point3D)          = (p1.x < p2.x) && (p1.y < p2.y) && (p1.z < p2.z)
!=(p1::Point3D, p2::Point3D)              = !isequal(p1, p2)
<(p1::Point3D, p2::Point3D)               = isless(p1,p2)
>(p1::Point3D, p2::Point3D)               = p2 < p1
==(p1::Point3D, p2::Point3D)              = isequal(p1, p2)
