struct Projection
    U::Point3D     # unit vector: the x axis of the 2D image
    V::Point3D     # unit vector: the y axis of the 2D image
    W::Point3D     # unit vector: the line of sight
    ue::Float64    # eye position projected onto U
    ve::Float64    # eye position projected onto V
    we::Float64    # eye position projected onto W
    eyepoint::Point3D
    centerpoint::Point3D
    uppoint::Point3D
    perspective::Float64
end

"""
    projection()

Define a new Projection:

- the eye position is `Point3D(100, 100, 100)``
- the center point is `Point3D(0, 0, 0)`
- the "up" point is `Point3D(0, 0, 1)`
- perspective is 0 (parallel projection)
"""
projection() = newprojection(Point3D(100, 100, 100), Point3D(0, 0, 0), Point3D(0, 0, 1))

Base.broadcastable(p::Projection) = Ref(p)

# Vectors shorter than this (relative to the size of the scene) are treated as
# zero when building a projection.
const _DEGENERATE_TOL = 1.0e-9

"""
   newprojection(ipos::Point3D, center::Point3D, up::Point3D, perspective=0.0)

Define a new Projection:

- `ipos` is the eye position
- `center` is the 3D point to appear in the center of the 2D image
- `up` is a point that is to appear vertically above the center

If `perspective` is 0.0 (the default) the projection is parallel. Otherwise it's
a vague magnification factor for perspective projections.

If the `up` point lies on the line through the eye and the center, there's no
way to tell which way is up, so the world `z` axis is used instead (or the y axis,
if you're looking along the z axis). If the eye and the center are the same
point there's no line of sight, and a degenerate projection is returned.
"""
function newprojection(ipos::Point3D, center::Point3D, up::Point3D, perspective = 0.0)
    sight = center - ipos
    d = distance(Point3D(0, 0, 0), sight)
    extent = max(1.0, distance(Point3D(0, 0, 0), ipos), distance(Point3D(0, 0, 0), center))
    if d <= _DEGENERATE_TOL * extent
        @warn "eye position and center are the same, so there's no line of sight" maxlog = 1
        zero3 = Point3D(0.0, 0.0, 0.0)
        return Projection(zero3, zero3, zero3, 0.0, 0.0, 0.0, ipos, center, up, perspective)
    end

    # Calculate the three unit vectors `U`, `V`, `W`, and the three scalar products, `ue`, `ve`, and `we`:

    # - `U` is at right angles to line of sight `w` so it corresponds to the x axis of the 2D image
    # - `V` is at right angles to `u` and to the line of sight, so it's the y axis of the 2D image
    # - `W` is the line of sight
    # - `we` is the projection of the eye position onto `w`
    # - `ue` is the projection of the eye position onto that x-axis
    # - `ve` is the projection of the eye position onto that y axis

    W = Point3D(center.x - ipos.x, center.y - ipos.y, center.z - ipos.z)
    r = (W.x * W.x) + (W.y * W.y) + (W.z * W.z)
    if r < _DEGENERATE_TOL
        @info("...eye position and center are the same")
        W = Point3D(0.0, 0.0, 0.0)
    else
        # distancealise w to unit length
        rinv = 1 / sqrt(r)
        W = Point3D(W.x * rinv, W.y * rinv, W.z * rinv)
    end
    we = W.x * ipos.x + W.y * ipos.y + W.z * ipos.z # project e on to w
    U = Point3D(
        W.y * (up.z - ipos.z) - W.z * (up.y - ipos.y),      # u is at right angles to t - e
        W.z * (up.x - ipos.x) - W.x * (up.z - ipos.z),      # and w ., its' the pictures x axis
        W.x * (up.y - ipos.y) - W.y * (up.x - ipos.x)
    )
    r = (U.x * U.x) + (U.y * U.y) + (U.z * U.z)

    if r < _DEGENERATE_TOL
        @info("...struggling to make a valid projection with these parameters")
        U = Point3D(0.0, 0.0, 0.0)
    else
        rinv = 1 / sqrt(r) # distancealise u
        U = Point3D(U.x * rinv, U.y * rinv, U.z * rinv)
    end

    ue = U.x * ipos.x + U.y * ipos.y + U.z * ipos.z # project e onto u

    V = Point3D(
        U.y * W.z - U.z * W.y, # v is at right angles to u and w
        U.z * W.x - U.x * W.z, # it's the world's y axis
        U.x * W.y - U.y * W.x
    )

    ve = V.x * ipos.x + V.y * ipos.y + V.z * ipos.z # project e onto v

    return Projection(U, V, W, ue, ve, we, ipos, center, up, perspective)
end
"""
   project(P::Point3D)

Project a 3D point onto a 2D surface, as defined by the current projection.

TODO Currently this returns 'nothing' if the point is behind the eyepoint. This
makes handling the conversion a bit harder, though, since the function now
returns either a 2D Luxor point or `nothing`.

```
using Thebes, Luxor

@svg begin
    eyepoint(Point3D(250, 250, 100))
    centerpoint(Point3D(0, 0, 0))
    uppoint(Point3D(0, 0, 10))
    sethue("grey50")
    carpet(300)
    axes3D(100)
    sethue("red")
    for i in 1:30
        randpoint3D = Point3D(rand(0.0:150, 3)...)
        sethue("red")
        pt1 = pin(randpoint3D)
        if pt1 != nothing
            circle(pt1, 5, :fill)
        end
    end
end
```
"""
function project(P::Point3D; proj=CURRENTPROJECTION[1])
    r = proj.W.x * P.x + proj.W.y * P.y + proj.W.z * P.z - proj.we
    # use default value for perspectiveness if not specified
    if proj.perspective == 0.0
        depth = 1.0
    elseif r <= eps()
        # the point is behind the eye
        return nothing
    else
        depth = proj.perspective / r
    end
    uq = depth * (proj.U.x * P.x + proj.U.y * P.y + proj.U.z * P.z - proj.ue)
    vq = depth * (proj.V.x * P.x + proj.V.y * P.y + proj.V.z * P.z - proj.ve)
    return Point(uq, -vq) # Y is down the page in Luxor
end

project(px, py, pz, proj::Projection) = project(Point3D(px, py, pz), proj=proj)

project(P::Point3D, proj) = project(P.px, P.py, P.pz, proj=proj)

# functions to update the projection

"""
    eyepoint()
    eyepoint(pt::Point3D)

Get or set the current eye position.
"""
function eyepoint()
    return CURRENTPROJECTION[1].eyepoint
end


"""
    centerpoint()
    centerpoint(pt::Point3D)

Get or set the current center position.
"""
function centerpoint()
    return CURRENTPROJECTION[1].centerpoint
end

"""
    uppoint()
    uppoint(pt::Point3D)

The "up" direction for the world: a line from the
centerpoint to the uppoint defines the up direction.
"""
function uppoint()
    return CURRENTPROJECTION[1].uppoint
end

"""
    perspective()
    perspective(n)

Get or set the current  perspective.
"""
function perspective()
    return CURRENTPROJECTION[1].perspective
end

function eyepoint(pt::Point3D)
    CURRENTPROJECTION[1] = newprojection(pt, centerpoint(), uppoint(), perspective())
    return CURRENTPROJECTION[1].eyepoint
end

function centerpoint(pt::Point3D)
    if isapprox(pt, uppoint())
        throw(error("if the uppoint is the centerpoint, which way is up?"))
    end
    CURRENTPROJECTION[1] = newprojection(eyepoint(), pt, uppoint(), perspective())
    return CURRENTPROJECTION[1].centerpoint
end

"""
    uppoint(pt::Point3D)

Specify the "up" direction for the world: a line from the
centerpoint to the uppoint defines the up direction.
"""
function uppoint(pt::Point3D)
    if isapprox(pt, centerpoint())
        throw(error("if the uppoint is the centerpoint, which way is up?"))
    end
    CURRENTPROJECTION[1] = newprojection(eyepoint(), centerpoint(), pt, perspective())
    return CURRENTPROJECTION[1].uppoint
end

function perspective(k)
    CURRENTPROJECTION[1] = newprojection(eyepoint(), centerpoint(), uppoint(), k)
    return CURRENTPROJECTION[1].perspective
end

eyepoint(x, y, z) = eyepoint(Point3D(x, y, z))
centerpoint(x, y, z) = centerpoint(Point3D(x, y, z))

"""
    uppoint(x, y, z)

Specify the "up" direction for the world: a line from the
centerpoint to the `uppoint` defines the up direction.
"""
uppoint(x, y, z) = uppoint(Point3D(x, y, z))


"""
    setprojection!(;
        eye=eyepoint(),
        center=centerpoint(),
        up=uppoint(),
        persp=perspective()
        )

Replace the current projection.
"""
function setprojection!(;
        eye=eyepoint(),
        center=centerpoint(),
        up=uppoint(),
        persp=perspective())
    CURRENTPROJECTION[1] = newprojection(eye, center, up, persp)
    return CURRENTPROJECTION[1]
end

"""
    helloworld()

Reset all the things to a sensible default. The equivalent of typing:

```
eyepoint(100, 100, 100)
centerpoint(0, 0, 0)
uppoint(0, 0, 10)
perspective(0)
```
"""
function helloworld()
    setprojection!(
        eye = Point3D(100, 100, 100),
        center = Point3D(0, 0, 0),
        up = Point3D(0, 0, 10),
        persp = 0)
    return perspective()
end
