mutable struct Projection
   U::Point3D     #
   V::Point3D     #
   W::Point3D     #
   ue::Float64    #
   ve::Float64    #
   we::Float64    #
   eyepoint::Point3D
   centerpoint::Point3D
   uppoint::Point3D
   perspective::Float64 #
end

Base.broadcastable(p::Projection) = Ref(p)


"""
   newprojection(ipos::Point3D, center::Point3D, up::Point3D, perspective=0.0)

Define a new Projection:

- ipos is the eye position
- center is the 3D point to appear in the center of the 2D image
- up is a point that is to appear vertically above the center

If `perspective` is 0.0 (the default) the projection is parallel. Otherwise it's
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
function newprojection(ipos::Point3D, center::Point3D, up::Point3D, perspective=0.0)
   # w is the line of sight
   W = Point3D(center.x - ipos.x, center.y - ipos.y, center.z - ipos.z)
   r = (W.x * W.x) + (W.y * W.y) + (W.z * W.z)
   if r < eps()
       # @info("eye position and center are the same")
   else
       # distancealise w to unit length
       rinv = 1/sqrt(r)
       W = Point3D(W.x * rinv, W.y * rinv, W.z * rinv)
   end
   we = W.x * ipos.x + W.y * ipos.y + W.z * ipos.z # project e on to w
   U = Point3D(W.y * (up.z - ipos.z) - W.z * (up.y - ipos.y),      # u is at right angles to t - e
               W.z * (up.x - ipos.x) - W.x * (up.z - ipos.z),      # and w ., its' the pictures x axis
               W.x * (up.y - ipos.y) - W.y * (up.x - ipos.x))
   r = (U.x * U.x) + (U.y * U.y) + (U.z * U.z)

   if r < eps()
       @info("struggling to make a valid projection with these parameters")
       U = Point3D(0, 0, 0)
   else
       rinv = 1/sqrt(r) # distancealise u
       U = Point3D(U.x * rinv, U.y * rinv, U.z * rinv)
   end
   ue = U.x * ipos.x + U.y * ipos.y + U.z * ipos.z # project e onto u
   V = Point3D(U.y * W.z - U.z * W.y, # v is at rightangles to u and w
               U.z * W.x - U.x * W.z, # it's the pictures y axis
               U.x * W.y - U.y * W.x)
   ve = V.x * ipos.x + V.y * ipos.y + V.z * ipos.z # project e onto v
   Projection(U, V, W, ue, ve, we, ipos, center, up, perspective)
end
"""
   project(P::Point3D)

Project a 3D point onto a 2D surface, as defined by the current projection.

TODO Currently this returns 'nothing' if the point is behind the eyepoint. This
makes handling the conversion a bit harder, though, since the function now
returns either a 2D Luxor point or `nothing`. This will probably change.

```
using Thebes, Luxor

@svg begin
    eyepoint(Point3D(250, 250, 100))
    centerpoint(Point3D(0, 0, 0))
    uppoint(Point3D(0, 0, 1))
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
function project(P::Point3D)
   proj = CURRENTPROJECTION[1]
   # use default value for perspectiveness if not specified
   r = proj.W.x * P.x + proj.W.y * P.y + proj.W.z * P.z - proj.we
   if r < eps()
       # "point $P is behind eye"
       result = nothing
   else
       if proj.perspective == 0.0
           depth = 1
       else
           depth = proj.perspective * (1/r)
       end
       uq = depth * (proj.U.x * P.x + proj.U.y * P.y + proj.U.z * P.z - proj.ue)
       vq = depth * (proj.V.x * P.x + proj.V.y * P.y + proj.V.z * P.z - proj.ve)
       result = Point(uq, -vq) # because Y is down the page in Luxor (?!)
   end
   return result
end

project(px, py, pz, proj::Projection) = project(Point3D(px, py, pz), proj)


#  functions to update the projection
function eyepoint()
    CURRENTPROJECTION[1].eyepoint
end

function centerpoint()
    CURRENTPROJECTION[1].centerpoint
end

function uppoint()
    CURRENTPROJECTION[1].uppoint
end

function perspective()
    CURRENTPROJECTION[1].perspective
end

function eyepoint(pt::Point3D)
    CURRENTPROJECTION[1] = newprojection(pt, centerpoint(), uppoint(), perspective())
end

function centerpoint(pt::Point3D)
    CURRENTPROJECTION[1] = newprojection(eyepoint(), pt, uppoint(), perspective())
end

function uppoint(pt::Point3D)
    CURRENTPROJECTION[1] = newprojection(eyepoint(), centerpoint(), pt, perspective())
end

function perspective(k)
    CURRENTPROJECTION[1] = newprojection(eyepoint(), centerpoint(), uppoint(), k)
end

eyepoint(x, y, z) = eyepoint(Point3D(x, y, z))
centerpoint(x, y, z) = centerpoint(Point3D(x, y, z))
uppoint(x, y, z) = uppoint(Point3D(x, y, z))

"""
    helloworld()

Reset all the things. The equivalent of typing:

```
eyepoint(100, 100, 100)
centerpoint(0, 0, 0)
uppoint(0, 0, 10)
perspective(0)
```
"""
function helloworld()
    eyepoint(100, 100, 100)
    centerpoint(0, 0, 0)
    uppoint(0, 0, 10)
    perspective(0)
end
