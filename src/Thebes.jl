module Thebes

using Luxor
using StaticArrays
using Rotations

using PackageExtensionCompat

function __init__()
    @require_extensions
end

include("Point3D.jl")
include("utils.jl")
include("Projection.jl")
include("Object.jl")
include("pin.jl")
include("path.jl")
include("text.jl")

export project, Projection, newprojection,
       Point3D,

       helloworld, eyepoint, centerpoint, uppoint,
       perspective,

       pin,

       hiddensurface, wireframe,

       Object, Teapot, Cube, Tetrahedron, Pyramid,

       carpet, drawcube, axes3D,
       between, make, distance, midpoint,

       rotateX, rotateY, rotateZ, rotateby!, rotateby,

       moveby!, moveby,

       objecttopoly,
       scaleby!, sortfaces!,
       sphericaltocartesian, cartesiantospherical,
       dotproduct3D, magnitude, anglebetweenvectors,
       surfacenormal, face, crossproduct3D, pointsperpendicular,

       text3D,

       import_off_file

const CURRENTPROJECTION = [newprojection(Point3D(100, 100, 100), Point3D(0, 0, 0), Point3D(0, 0, 1))]


end
