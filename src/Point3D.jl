struct Point3D <: FieldVector{3, Float64}
    x::Float64
    y::Float64
    z::Float64
end

import Base: +, -, ==, *, ^, <, >, /, !=
import Base: isnan, isapprox, isequal, isless, broadcastable
import Luxor: between, distance, midpoint

Base.broadcastable(x::Point3D) = Ref(x)

function +(p1::Point3D, p2::Point3D)
    Point3D((p2.x + p1.x), (p2.y + p1.y), (p2.z + p1.z))
end
+(p1::Point3D, k::Number)              = Point3D(p1.x + k, p1.y + k, p1.z + k)
+(k::Number, p2::Point3D)              = +(p2::Point3D, k::Number)

function -(p1::Point3D, p2::Point3D)
    Point3D((p1.x - p2.x), (p1.y - p2.y), (p1.z - p2.z))
end
-(p::Point3D)                          = Point3D(-p.x, -p.y, -p.z)
-(k::Number, p1::Point3D)              = Point3D(p1.x - k, p1.y - k, p1.z - k)
-(p1::Point3D, k::Number)              = Point3D(p1.x - k, p1.y - k, p1.z - k)

*(k::Number, p2::Point3D)              = Point3D(k * p2.x, k * p2.y, k * p2.z)
*(p2::Point3D, k::Number)              = Point3D(k * p2.x, k * p2.y, k * p2.z)
*(p1::Point3D, p2::Point3D)            = Point3D(p1.x * p2.x, p1.y * p2.y, p1.z * p2.z)

"""
    distance(p1::Point3D, p2::Point3D)

Return the distance between two points.

"""
function distance(p1::Point3D, p2::Point3D)
    sqrt((p2.x - p1.x)^2 + (p2.y - p1.y)^2 + (p2.z - p1.z)^2)
end

function isnan(pt::Point3D)
    isnan(pt.x) || isnan(pt.y) || isnan(pt.z)
end

"""
    between(p1::Point3D, p2::Point3D, x=0.5)
    between((p1::Point3D, p2::Point3D), x=0.5)

Find a point on a line between two 3D points.
If `x` is 0.5, the returned point should be halfway between them.

"""
function between(p1::Point3D, p2::Point3D, x=0.5)
    return p1 + (x * (p2 - p1))
end

function between(couple::NTuple{2, Point3D}, x=0.5)
    p1, p2 = couple
    return p1 + (x * (p2 - p1))
end

/(p2::Point3D, k::Number)              = Point3D(p2.x/k, p2.y/k, p2.z/k)
^(p::Point3D, e::Integer)              = Point3D(p.x^e,  p.y^e, p.z^e)
^(p::Point3D, e::Float64)              = Point3D(p.x^e,  p.y^e, p.z^e)

# conversion

function Base.convert(type::Type{Point3D}, pt::Point)
    return Point3D(pt.x, pt.y, 0.0)
end

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

"""
    dotproduct3D(a::Point3D, b::Point3D)

Finds the dot product of a and b
"""
function dotproduct3D(a::Point3D, b::Point3D)
    return a.x * b.x + a.y * b.y + a.z * b.z
end

"""
    magnitude(a::Point3D)

Calculates magnitude of a.
"""
function magnitude(a::Point3D)
    return sqrt(a.x * a.x + a.y * a.y + a.z * a.z)
end

"""
    anglebetweenvectors(v1::Point3D, v2::Point3D)

Calclate the angle between two vectors.
"""
function anglebetweenvectors(v1::Point3D, v2::Point3D)
    intermediate = dotproduct3D(v1, v2)/(magnitude(v1) * magnitude(v2))
    # avoid domain errors
    if isnan(intermediate)
        return 0.0
    else
        return acos(min(max(-1, intermediate), 1))
    end
end

"""
    midpoint(pt1::Point3D, pt2::Point3D)

Find the midpoint between two points. See also `between()`.
"""
function midpoint(pt1::Point3D, pt2::Point3D)
    return Point3D((pt1.x + pt2.x)/2, (pt1.y + pt2.y)/2, (pt1.z + pt1.z)/2)
end


"""
    sphericaltocartesian(rho, theta, phi)

Return `Point3D(x, y, z)` corresponding to `(rho, theta, phi)`.
"""
function sphericaltocartesian(rho, theta, phi)
    x = rho * sin(phi) * cos(theta)
    y = rho * sin(phi) * sin(theta)
    z = rho * cos(phi)
    return Point3D(x, y, z)
end

"""
    cartesiantospherical(x, y, z)

Return (phi, rho, theta) of (x, y, z).
"""
function cartesiantospherical(x, y, z)
    phi = atan(y, x)
    rho = sqrt(x^2 + y^2 + z^2)
    theta = acos(z/rho)
    return (phi, rho, theta)
end

# rotations


# old versions just redirect to Rotations now
"""
    rotateX(pt3D::Point3D, rad)

Return a new point resulting from rotating the point around the x axis by an angle in radians.

Rotations are anticlockwise when looking along axis from 0 to +axis.
"""
function rotateX(pt3D::Point3D, rad)
    return RotX(rad) * pt3D
end

"""
    rotateY(pt3D::Point3D, rad)

Return a new point resulting from rotating the point around the y axis by an angle in radians.

Rotations are anticlockwise when looking along axis from 0 to +axis.
"""
function rotateY(pt3D::Point3D, rad)
    return RotY(rad) * pt3D
end

"""
    rotateZ(pt3D::Point3D, rad)

Return a new point resulting from rotating the point around the z axis by an angle in radians.
"""
function rotateZ(pt3D::Point3D, rad)
    return RotZ(rad) * pt3D
end

# rotate around axes

## copies (new points)
"""
    rotateby(pt::Point3D, angleX, angleY, angleZ)
    rotateby(ptlist::Array{Point3D, 1}, angleX, angleY, angleZ)
    rotateby(point::Point3D, r::Rotation)
    rotateby(ptlist::Array{Point3D, 1}, r::Rotation)

Return a new point/list of points resulting from rotating
around the x, y, and z axes by angleX, angleY, angleZ.

The Z rotation is first, then the Y, then the X.

A 3×3 rotation matrix parameterized by the
"Tait-Bryant" XYZ Euler angle convention,
consisting of first a rotation about the Z
axis by theta3, followed by a rotation about
the Y axis by theta2, and finally a rotation
about the X axis by theta1.
"""
function rotateby(point::Point3D, angleX::Float64, angleY::Float64, angleZ::Float64)
    return RotXYZ(angleX, angleY, angleZ) * point
end

function rotateby(ptlist::Array{Point3D, 1}, angleX::Float64, angleY::Float64, angleZ::Float64)
    return rotateby.(ptlist, angleX, angleY, angleZ)
end

function rotateby(point::Point3D, r::Rotation)
    return r * point
end

function rotateby(ptlist::Array{Point3D, 1}, r::Rotation)
    return rotateby.(ptlist, r)
end

## update an array of points
"""
    rotateby!(ptlist::Array{Point3D, 1}, angleX, angleY, angleZ)

Modify a list of points by rotating each one around the
x, y, and z axes by angleX, angleY, angleZ.
"""
function rotateby!(ptlist::Array{Point3D, 1}, angleX::Float64, angleY::Float64, angleZ::Float64)
    for i in eachindex(ptlist)
        ptlist[i] = rotateby(ptlist[i], angleX, angleY, angleZ)
    end
    return ptlist
end

# rotate a point around another point

## copy (new point)

"""
    rotateby(point::Point3D, about::Point3D, angleX, angleY, angleZ)
    rotateby(point::Point3D, about::Point3D, r::Rotation)
    rotateby(ptlist::Array{Point3D, 1}, about::Point3D, r::Rotation)
"""
function rotateby(point::Point3D, about::Point3D, angleX::Float64, angleY::Float64, angleZ::Float64)
    return RotXYZ(angleX, angleY, angleZ) * (point - about) + about
end
function rotateby(point::Point3D, about::Point3D, r::Rotation)
    return r * (point - about) + about
end
function rotateby(ptlist::Array{Point3D, 1}, about::Point3D, r::Rotation)
    return rotateby.(ptlist, about, r)
end


## update an array of points
"""
    rotateby!(ptlist::Array{Point3D, 1}, existingpt::Point3D, angleX, angleY, angleZ)
    rotateby!(ptlist::Array{Point3D, 1}, existingpt::Point3D, r::Rotation)
    rotateby!(ptlist::Array{Point3D, 1}, r::Rotation=RotXYZ{Float64})

Rotate each point in the list by rotation (or angleX, angleY, angleZ) around another point (or origin).
"""
function rotateby!(ptlist::Array{Point3D, 1}, existingpt::Point3D, angleX::Float64, angleY::Float64, angleZ::Float64)
    for i in eachindex(ptlist)
        ptlist[i] = rotateby(ptlist[i], existingpt, angleX, angleY, angleZ)
    end
    return ptlist
end
function rotateby!(ptlist::Array{Point3D, 1}, existingpt::Point3D, r::Rotation)
    for i in eachindex(ptlist)
        ptlist[i] = rotateby(ptlist[i], existingpt, r)
    end
    return ptlist
end

rotateby!(ptlist::Array{Point3D, 1}, r::Rotation=RotXYZ{Float64}) = rotateby!(ptlist, Point3D(0.0, 0.0, 0.0), r)

"""
    moveby(pt::Point3D, d::Point3D)

Return a new point that's the result of moving a point `pt` by a vector `d`.
"""
function moveby(pt::Point3D, d::Point3D)
    return pt + d
end

"""
    moveby!(ptlist::Point3D, x, y, z)
    moveby!(ptlist::Point3D, pt::Point3D)

Move all points in the list by a vector.
"""
function moveby!(ptlist::Array{Point3D, 1}, pt::Point3D)
    return ptlist .+= pt
end

moveby!(ptlist::Array{Point3D, 1}, x, y, z) = moveby!(ptlist, Point3D(x, y, z))

"""
    scaleby!(ptlist::Array{Point3D, 1}, x, y, z)

Scales a list of points by multiplying by `x` in X, `y` in Y, `z` in Z.
"""
function scaleby!(ptlist::Array{Point3D, 1}, x, y, z)
   for n in 1:length(ptlist)
       v = ptlist[n]
       ptlist[n] = Point3D(v.x * x, v.y * y, v.z * z)
   end
   return ptlist
end

"""
    surfacenormal(ptlist::Array{Point3D, 1})

Finds one of these.
"""
function surfacenormal(ptlist::Array{Point3D, 1})
   normal = Point3D(0, 0, 0)
   for i in 1:length(ptlist)
      vertexCurrent = ptlist[i]
      vertexNext    = ptlist[mod1(i + 1, end)]
      x = normal.x + ( (vertexCurrent.y - vertexNext.y) * (vertexCurrent.z + vertexNext.z))
      y = normal.y + ( (vertexCurrent.z - vertexNext.z) * (vertexCurrent.x + vertexNext.x))
      z = normal.z + ( (vertexCurrent.x - vertexNext.x) * (vertexCurrent.y + vertexNext.y))
      normal = Point3D(x, y, z)
   end
   l = magnitude(normal)
   # return normalize(normal)
   return Point3D(normal.x/l, normal.y/l, normal.z/l) / l
end

function Base.unique(pts::Array{Point3D, 1})
    apts = Point3D[]
    for pt in pts
        if pt ∉ apts
            push!(apts, pt)
        end
    end
    return apts
end
