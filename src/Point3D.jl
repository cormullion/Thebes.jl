struct Point3D <: Real
   x
   y
   z
end

import Base: +, -, ==, *, ^, <, >, /, !=
import Base: size, getindex, isnan, isapprox, isequal, isless
import Luxor: between, distance, midpoint

function +(p1::Point3D, p2::Point3D)
    Point3D((p2.x + p1.x), (p2.y + p1.y), (p2.z + p1.z))
end
+(p1::Point3D, k::Number)              = Point3D(p1.x + k, p1.y + k, p1.z + k)
+(k::Number, p2::Point3D)              = +(p1::Point3D, k::Number)

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

# for broadcasting
Base.size(::Point3D) = 3
Base.getindex(p::Thebes.Point3D, i::Int64) = [p.x, p.y, p.z][i]

/(p2::Point3D, k::Number)              = Point3D(p2.x/k, p2.y/k, p2.z/k)
^(p::Point3D, e::Integer)              = Point3D(p.x^e,  p.y^e, p.z^e)
^(p::Point3D, e::Float64)              = Point3D(p.x^e,  p.y^e, p.z^e)

# conversion

function Base.convert(type::Type{Point3D}, pt::Point)
    return Point3D(pt.x, pt.y, 0)
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

Calclates anglebetweenvectors
"""
function anglebetweenvectors(v1::Point3D, v2::Point3D)
    intermediate = dotproduct3D(v1, v2)/(magnitude(v1) * magnitude(v2))
    # avoid domain errors
    return acos(min(max(-1, intermediate), 1))
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

Return Point3D(x, y, z) of (rho, theta, phi).
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

### TODO 3D rotations hurt my brain, so this is a good hunting ground for bugs...
"""
    rotateX(pt3D::Point3D, rad)

Return a new point resulting from rotating the point around the x axis by an angle in radians.

Rotations are anticlockwise when looking along axis from 0 to +axis.
"""
function rotateX(pt3D::Point3D, rad)
    cosa = cos(rad)
    sina = sin(rad)
    y = pt3D.y * cosa - pt3D.z * sina
    z = pt3D.y * sina + pt3D.z * cosa
    return Point3D(pt3D.x, y, z)
end

"""
    rotateY(pt3D::Point3D, rad)

Return a new point resulting from rotating the point around the y axis by an angle in radians.
"""
function rotateY(pt3D::Point3D, rad)
    cosa = cos(rad)
    sina = sin(rad)
    z = pt3D.z * cosa - pt3D.x * sina
    x = pt3D.z * sina + pt3D.x * cosa
    return Point3D(x, pt3D.y, z)
end

"""
    rotateZ(pt3D::Point3D, rad)

Return a new point resulting from rotating the point around the z axis by an angle in radians.
"""
function rotateZ(pt3D::Point3D, rad)
    cosa = cos(rad)
    sina = sin(rad)
    x = pt3D.x * cosa - pt3D.y * sina
    y = pt3D.x * sina + pt3D.y * cosa
    return Point3D(x, y, pt3D.z)
end

# rotate around axes

"""
    rotateby(pt::Point3D, angleX, angleY, angleZ)
    rotateby(ptlist::Array{Point3D, 1}, angleX, angleY, angleZ)

Return a new point/list of points resulting from rotating
around the x, y, and z axes by angleX, angleY, angleZ.
"""
function rotateby(pt::Point3D, angleX, angleY, angleZ)
    v = rotateX(pt, angleX)
    v = rotateY(v, angleY)
    v = rotateZ(v, angleZ)
    return v
end

function rotateby(ptlist::Array{Point3D, 1}, angleX, angleY, angleZ)
    return rotateby.(ptlist, angleX, angleY, angleZ)
end

"""
    rotateby!(ptlist::Array{Point3D, 1}, angleX, angleY, angleZ)

Return the list of points with each one rotated
around the x, y, and z axes by angleX, angleY, angleZ.
"""
function rotateby!(ptlist::Array{Point3D, 1}, angleX, angleY, angleZ)
    for i in eachindex(ptlist)
        ptlist[i] = rotateby(ptlist[i], angleX, angleY, angleZ)
    end
    return ptlist
end

# rotate around point

"""
    rotateby(newpt::Point3D, existingpt::Point3D, angleX, angleY, angleZ)

Return a new point/list resulting from rotating each point
by angleX, angleY, angleZ around another point.
"""
function rotateby(newpt::Point3D, existingpt::Point3D, angleX, angleY, angleZ)
    v = newpt - existingpt
    v = rotateX(v, angleX)
    v = rotateY(v, angleY)
    v = rotateZ(v, angleZ)
    return v + existingpt
end

"""
    rotateby!(ptlist::Point3D, existingpt::Point3D, angleX, angleY, angleZ)

Rotate each point in the list by angleX, angleY, angleZ around another point.
"""
function rotateby!(ptlist::Array{Point3D, 1}, existingpt::Point3D, angleX, angleY, angleZ)
    for i in eachindex(ptlist)
        ptlist[i] = rotateby(ptlist[i], existingpt, angleX, angleY, angleZ)
    end
    return ptlist
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
    surfacenormal(ptlist)

Finds one of these.
"""
function surfacenormal(ptlist)
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
