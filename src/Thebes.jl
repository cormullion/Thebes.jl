__precompile__(true)

"""
    throwaway experiments in 2.5D graphics
"""
module Thebes

using Luxor
# using StaticArrays, CoordinateTransformations

include("Point3D.jl")

export project, Projection, newprojection,
       Point3D, Model, AxesWire,
       Cube, Tetrahedron, Pyramid, Carpet,
       drawcarpet,  drawunitbox, draw3daxes,
       make,
       rotateX, rotateY, rotateZ,
       rotateto!, rotateto,
       rotateby!, rotateby,
       changeposition!, changeposition,
       drawmodel, modeltopoly,
       changescale!, sortfaces!

mutable struct Projection
   U::Point3D     #
   V::Point3D     #
   W::Point3D     #
   ue::Float64    #
   ve::Float64    #
   we::Float64    #
   perspective::Float64 #
end

"""
   newprojection(ipos::Point3D, center::Point3D, up::Point3D, perspective=1.0)

Make a new Projection:

- ipos is the eye position
- center is the 3D point to appear in the center of the 2D image
- up is a point that is to appear vertically above the center

If `perspective` is 1.0, the default, the projection is parallel. Otherwise it's
a vague magnification factor for perspective projections.

The three vectors U, V, W, and the three scalar products, ue, ve, and we:

- u is at right angles to line of sight w, and to t-e, so it corresponds to
the x axis of the 2D image

- v is at right angles to u and to the line of sight, so it's the y axis of the
2D image

- w is the line of sight

- we is the projection of the eye position onto w

- ue is the projection of the eye position onto that x-axis

- ve is the projection of the eye position onto that y axis
"""
function newprojection(ipos::Point3D, center::Point3D, up::Point3D, perspective=1.0)

   # w is the line of sight
   W = Point3D(center.x - ipos.x, center.y - ipos.y, center.z - ipos.z)

   r = (W.x * W.x) + (W.y * W.y) + (W.z * W.z)

   if r < eps()
       # info("eye position and center are the same")
   else
       # normalise w to unit length
       rinv = 1/sqrt(r)
       W.x = W.x * rinv
       W.y = W.y * rinv
       W.z = W.z * rinv
   end

   we = W.x * ipos.x + W.y * ipos.y + W.z * ipos.z # project e on to w

   U = Point3D(W.y * (up.z - ipos.z) - W.z * (up.y - ipos.y),      # u is at right angles to t - e
               W.z * (up.x - ipos.x) - W.x * (up.z - ipos.z),      # and w ., its' the pictures x axis
               W.x * (up.y - ipos.y) - W.y * (up.x - ipos.x))

   r = (U.x * U.x) + (U.y * U.y) + (U.z * U.z)

   if r < eps()
       info("t coincides with e")
       U = Point3D(0, 0, 0)
   else
       rinv = 1/sqrt(r) # normalise u
       U.x = U.x * rinv
       U.y = U.y * rinv
       U.z = U.z * rinv
   end

   ue = U.x * ipos.x + U.y * ipos.y + U.z * ipos.z # project e onto u

   V = Point3D(U.y * W.z - U.z * W.y, # v is at rightangles to u and w
               U.z * W.x - U.x * W.z, # it's the pictures y axis
               U.x * W.y - U.y * W.x)

   ve = V.x * ipos.x + V.y * ipos.y + V.z * ipos.z # project e onto v

   Projection(U, V, W, ue, ve, we, perspective)
end
"""
   project(P::Point3D, proj::Projection)

Project a 3D point onto a 2D surface, as defined by the projection in `proj`.

TODO Currently this returns 'nothing' if the point is behind the eyepoint. This
makes handling the conversion a bit harder, though, since the function now
returns either a 2D Luxor point or `nothing`. This will probably change.

```
   eyepoint    = Point3D(250, 250, 200)
   centerpoint = Point3D(0, 0, 0)
   uppoint     = Point3D(0, 0, 1)
   newproj     = newprojection(eyepoint, centerpoint, uppoint)
   xaxis1 = project(Point3D(0,   0, 0), newproj)
   xaxis2 = project(Point3D(100, 0, 0), newproj)
   sethue("red")
   arrow(xaxis1, xaxis2)
   label("X", :N, xaxis2)
   pt1 = project(randpoint3D, newproj)
   if pt1 != nothing
       circle(pt1, 5, :dot)
   end
```
"""
function project(P::Point3D, proj::Projection)
   # use default value for perspectiveness if not specified
   r = proj.W.x * P.x + proj.W.y * P.y + proj.W.z * P.z - proj.we
   if r < eps()
       # "point $P is behind eye"
       result = nothing
   else
       if proj.perspective == 1.0
           depth = 1
       else
           depth = proj.perspective * (1/r)
       end
       uq = depth * (proj.U.x * P.x + proj.U.y * P.y + proj.U.z * P.z - proj.ue)
       vq = depth * (proj.V.x * P.x + proj.V.y * P.y + proj.V.z * P.z - proj.ve)
       result = Point(uq, -vq) # because Y is down the page in Luxor
   end
   return result
end

project(px, py, pz, proj::Projection) = project(Point3D(px, py, pz), proj)

mutable struct Model
    vertices::Vector{Point3D}
    faces
    labels
    name::String
end

"""
    make(primitive, name="unnamed")

`primitive` contains two arrays, an array of 3D points, and an array of faces,
where each face is a list of vertex numbers.

Returns a model.

Example

    make(Cube, "cube")

returns a Model object containing an array of vertices, and array of faces,
and an array of labels.

```
tol = 0.001
a = []
for t in -2pi:tol:2pi
    push!(a, Point3D((2 + cos(5t)) * cos(3t), (2 + cos(5t)) * sin(2t), sin(5t)))
end
Knot = make((a, []), "knot")
```
"""
function make(vf, name="unnamed")
    # don't redefine when passed an array
    vertices = deepcopy(vf[1])
    faces    = deepcopy(vf[2])
    labels   = collect(1:length(faces))
    return Model(vertices, faces, labels, name)
end


include("objects.jl")

# don't load all these now!
# include("moreobjects.jl")

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
    modeltopoly(m::Model, projection::Projection)

Return a list of 2D points representing the 3D model in `m` projected using the
projection in `projection`.

TODO I don't this works at the moment.
"""
function modeltopoly(m::Model, projection::Projection)
    vertices2D = Point[]
    for v in m.vertices
        r = project(v, projection)
        if r != nothing
            push!(vertices2D, r)
        else
            push!(vertices2D, Point(NaN, NaN))
        end
    end
    facepolys = []
    if length(m.faces) > 0
        for f in m.faces
            push!(facepolys, vertices2D[f])
        end
    end
    filter!(f -> !isnan(f.x) && !isnan(f.y), vertices2D)
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

"""
    simplerender(vertices, faces, labels, cols; action=:stroke)

In the Luxor drawing, draw the 2D vertices and faces, using colors in the `cols` array.
"""
function simplerender(vertices, faces, labels, cols; action=:stroke)
    setlinejoin("bevel")
    if !isempty(faces)
        @layer begin
            for (n, p) in enumerate(faces)
                x = mod1(n, length(cols))
                c = cols[mod1(labels[x], length(cols))]
                sethue(c)
                poly(p, action, close=true)
            end
        end
    else
        @layer begin
            sethue(cols[1])
            poly(vertices, action, close=true)
        end
    end
end

"""
    drawmodel(m::Model, projection::Projection;
        cols=["black", "grey80"],
        renderfunc = (v, f, l, c; kwargs... ) -> simplerender(v, f, l, c; kwargs...))

Draw a model. Calls a rendering function, the default is `simplerender()`.

To define and change the default rendering function:

```
function myrenderfunction(vertices, faces, labels, cols; action=:fill)
    if !isempty(faces)
        @layer begin
            for (n, p) in enumerate(faces)
                x = mod1(n, length(cols))
                c = cols[mod1(labels[x], length(cols))]

                @layer begin
                    setopacity(0.5)
                    sethue(c)
                    poly(p, action)
                end

                sethue("black")
                setline(0.5)
                poly(p, :stroke, close=true)

            end
        end
    end
end

@svg begin
    eyepoint    = Point3D(60, 60, 60)
    centerpoint = Point3D(0, 0, 1)
    uppoint     = Point3D(0, 0, 2) # relative to centerpoint
    projection  = newprojection(eyepoint, centerpoint, uppoint, 500)

o = :Cube
object = make(eval(o), string(o))
changescale!(object, 15, 15, 15)
rotateby!(object, object.vertices[1], rand(), rand(), rand())
sortfaces!(object)
drawmodel(object, projection,
    cols=["magenta", "green", "red", "blue", "yellow", "orange"],
    renderfunc = myrenderfunction)
end
```
"""
function drawmodel(m::Model, projection::Projection;
    cols=["black", "grey80"],
    renderfunc = (v, f, l, c; kwargs... ) -> simplerender(v, f, l, c; kwargs...))
    vertices, faces = modeltopoly(m, projection)
    renderfunc(vertices, faces, m.labels, cols)
end

"""
    changeposition!(m::Model, x, y, z)
"""
function changeposition!(m::Model, x, y, z)
    for n in 1:length(m.vertices)
        nv = m.vertices[n]
        m.vertices[n] = Point3D(nv.x + x, nv.y + y, nv.z + z)
    end
    return m
end

"""
    changeposition(m::Model, x, y, z)
"""
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
    rotateX(pt3D::Point3D, rad)

rotate a point around x axis by an angle in radians
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

rotate a point around y axis by an angle in radians
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

rotate a point around z axis to an angle in radians
"""
function rotateZ(pt3D::Point3D, rad)
    cosa = cos(rad)
    sina = sin(rad)
    x = pt3D.x * cosa - pt3D.y * sina
    y = pt3D.x * sina + pt3D.y * cosa
    return Point3D(x, y, pt3D.z)
end

"""
    rotateto!(m::Model, angleX, angleY, angleZ)

rotate model to an angle by angleX, angleY, angleZ
"""
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

"""
    rotateto(m::Model, angleX, angleY, angleZ)

rotate a copy of the model to an angle by angleX, angleY, angleZ
"""
function rotateto(m::Model, angleX, angleY, angleZ)
    mcopy = deepcopy(m)
    return rotateto!(mcopy, angleX, angleY, angleZ)
end

"""
    rotateby!(m::Model, pt::Point3D, angleX, angleY, angleZ)

rotate model by an angle
"""
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

"""
    rotateby(m::Model, pt::Point3D, angleX, angleY, angleZ)

rotate a copy of the model by an angle
"""
function rotateby(m::Model, pt::Point3D, angleX, angleY, angleZ)
    mcopy = deepcopy(m)
    return rotateby!(mcopy, pt, angleX, angleY, angleZ)
end

"""
    draw3daxes(n, projection)

"""
function draw3daxes(n, projection)
    @layer begin
    fontsize(16)
    setline(2)
    xaxis1 = project(Point3D(0.1,   0.1,  0.1), projection)
    xaxis2 = project(Point3D(n,   0.1,  0.1), projection)
    sethue("red")
    if (xaxis1 != nothing) &&  (xaxis2 != nothing)
        arrow(xaxis1, xaxis2)
        label("X", :N, xaxis2)
    end
    yaxis1 = project(Point3D(0.1,   0.1,  0.1), projection)
    yaxis2 = project(Point3D(0.1,   n,  0.1), projection)
    sethue("green")

    if (yaxis1 != nothing) &&  (yaxis2 != nothing)
        arrow(yaxis1, yaxis2)
        label("Y", :N, yaxis2)
    end
    zaxis1 = project(Point3D(0.1,   0.1,  0.1), projection)
    zaxis2 = project(Point3D(0.1,   0.1,  n), projection)
    sethue("blue")
    if (zaxis1 != nothing) &&  (zaxis2 != nothing)
        arrow(zaxis1, zaxis2)
        label("Z", :N, zaxis2)
    end
    end
end

"""
    drawunitbox(n, projection, action=:stroke)
"""
function drawunitbox(n, projection, action=:stroke)
    @layer begin
        setline(2)
        fontsize(10)
        setlinecap("butt")
        setlinejoin("bevel")
        p1 = project(Point3D(0,   0,  0), projection)
        p2 = project(Point3D(n,  0,  0), projection)
        p3 = project(Point3D(n, n,  0), projection)
        p4 = project(Point3D(0,  n,  0), projection)
        p5 = project(Point3D(0,   0,  n), projection)
        p6 = project(Point3D(n,  0,  n), projection)
        p7 = project(Point3D(n, n,  n), projection)
        p8 = project(Point3D(0,  n,  n), projection)

        if all(i -> i != nothing, [p1, p2, p3,  p4, p5, p6, p7, p8])
            label("p1 Point3D(0,   0,  0)", :N, p1)
            label("p2 Point3D($(string(n)),  0,  0)", :N, p2)
            label("p3 Point3D($(string(n)), $(string(n)),  0)", :N, p3)
            label("p4 Point3D(0,  $(string(n)),  0)", :N, p4)
            label("p5 Point3D(0,   0, $(string(n)))", :S, p5)
            label("p6 Point3D($(string(n)),  0, $(string(n)))", :S, p6)
            label("p7 Point3D($(string(n)), $(string(n)), $(string(n)))", :S, p7)
            label("p8 Point3D(0,  $(string(n)), $(string(n)))", :S, p8)

            sethue("red")
            prettypoly([p1, p2, p3, p4], action, close=true)

            sethue("purple")
            prettypoly([p1, p2, p6, p5], action, close=true)

            sethue("magenta")
            prettypoly([p3, p7, p8, p4], action, close=true)

            sethue("green")
            prettypoly([p5, p6, p7, p8], action, close=true)
        end
    end
end

"""
    drawcarpet(n, projection; kind=:circular)

Draw a carpet centered at the origin, using current Luxor parameters.
"""
function drawcarpet(n, projection; kind=:circular)
    @layer begin
        if kind != :circular
            p1 = project(Point3D(-n/2, -n/2,  0), projection)
            p2 = project(Point3D(n/2,  -n/2,  0), projection)
            p3 = project(Point3D(n/2, n/2,  0), projection)
            p4 = project(Point3D(-n/2,  n/2,  0), projection)
            if all(i -> i != nothing, [p1, p2, p3,  p4])
                poly([p1, p2, p3, p4], :fill, close=true)
            end
        else
            shape3D = [Point3D(n * cos(theta), n * sin(theta), 0) for theta in 0:0.1:2pi]
            shape2D = Point[]
            for i in shape3D
                pt = project(i, projection)
                if pt != nothing
                    push!(shape2D, pt)
                end
            end
            poly(shape2D, :fill, close=true)
        end
    end
end

end
