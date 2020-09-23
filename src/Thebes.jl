module Thebes

using Luxor

include("utils.jl")
include("Point3D.jl")
include("Projection.jl")
include("Object.jl")
include("pin.jl")
include("text.jl")

export project, Projection, newprojection,
       Point3D,

       helloworld, eyepoint, centerpoint, uppoint,
       perspective,

       pin,

       simplegfunction,

       Object, Teapot, Cube, Tetrahedron, Pyramid,

       carpet, drawcube, axes3D,
       between, make, distance, midpoint,

       rotateX, rotateY, rotateZ, rotateby!, rotateby,

       moveby!, moveby,

       objecttopoly,
       scaleby!, sortfaces!,
       sphericaltocartesian, cartesiantospherical,
       dotproduct3D, magnitude, anglebetweenvectors,
       surfacenormal, face,

       text3D

const CURRENTPROJECTION = [newprojection(Point3D(100, 100, 100), Point3D(0, 0, 0), Point3D(0, 0, 1))]

end
