"""
    throwaway experiments in faux-3D or 2¼-D graphics
"""
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

       Object, AxesWire,
       Cube, Tetrahedron, Pyramid, Carpet,
       carpet, drawunitbox, axes3D,
       between,
       make, distance,
       rotateX, rotateY, rotateZ,
      
       rotateby!, rotateby,
       setposition!, setposition,
       objecttopoly,
       setscale!, sortfaces!,
       midpoint,
       sphericaltocartesian, cartesiantospherical,
       dotproduct3D, magnitude, anglebetweenvectors,
       surfacenormal, face,

       text3D

const CURRENTPROJECTION = [newprojection(Point3D(100, 100, 100), Point3D(0, 0, 0), Point3D(0, 0, 1))]

end
