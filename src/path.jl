import Luxor: drawpath

"""
    drawpath(path::Path, k::Real, anchor::Point3D;
        about=Point3D(0., 0., 0.),
        rotation::Rotation=RotXYZ(0, 0, 0),
        steps=20, # used when approximating Bezier curve segments
        action=:none,
        startnewpath=true,
        pathlength = 0.0)

Draw a Luxor Path object on a 2D plane, starting at `anchor`
with `rotation` about `about`.
"""
function drawpath(path::Path, k::Real, anchor::Point3D;
        about=Point3D(0., 0., 0.),
        rotation::Rotation=RotXYZ(0, 0, 0),
        steps=20, # used when approximating Bezier curve segments
        action=:none,
        startnewpath=true,
        pathlength = 0.0)

    if iszero(pathlength)
       pathlength = Luxor.pathlength(path)
    end
    requiredlength = k * pathlength # we'll stop when we get past this
    currentlength = 0
    startnewpath && newpath()
    # firstpoint₂ is the point we will return to for a Close
    # currentpoint₂ is Cairo's current point
    # mostrecentpoint₂ is the point we last visited
    currentpoint₂ = mostrecentpoint₂ = firstpoint₂ = O
    for pathelement in path
        # move
        if pathelement isa PathMove
            currentpoint₂ = firstpoint₂ = pathelement.pt1
            newpt = rotateby(Point3D(anchor.x + currentpoint₂.x, anchor.y - currentpoint₂.y, anchor.z), about, rotation)
            newpt₂ = project(newpt)
            if !isnothing(newpt₂)
                move(newpt₂)
            end
        # curve
        elseif pathelement isa PathCurve
            plength = Luxor.get_bezier_length(BezierPathSegment(currentpoint₂, pathelement.pt1, pathelement.pt2, pathelement.pt3), steps=steps)
            controlpoint1₃ = rotateby(Point3D(anchor.x + pathelement.pt1.x, anchor.y - pathelement.pt1.y, anchor.z), about, rotation)
            controlpoint2₃ = rotateby(Point3D(anchor.x + pathelement.pt2.x, anchor.y - pathelement.pt2.y, anchor.z), about, rotation)
            endpoint₃ = rotateby(Point3D(anchor.x + pathelement.pt3.x, anchor.y - pathelement.pt3.y, anchor.z), about, rotation)
            pts₂ = map(p -> project(Point3D(p)), (controlpoint1₃, controlpoint2₃, endpoint₃))
            if all(!isnothing, pts₂) # draw if all points are valid
                curve(pts₂...)
            end
            mostrecentpoint₂ = currentpoint₂ # remember how far we got
            currentpoint₂ = pathelement.pt3 # update currentpoint₂
            currentlength += plength
        # line
        elseif pathelement isa PathLine  # pt1
            plength = distance(currentpoint₂, pathelement.pt1)
            newpt₃ = rotateby(Point3D(anchor.x + pathelement.pt1.x, anchor.y - pathelement.pt1.y, anchor.z), about, rotation)
            endpoint₂ = project(newpt₃)
            if !isnothing(endpoint₂)
                line(endpoint₂)
            end
            mostrecentpoint₂ = currentpoint₂
            currentpoint₂ = pathelement.pt1
            currentlength += plength
        # close
        elseif pathelement isa PathClose
            plength = distance(currentpoint₂, firstpoint₂)
            # I think Close is just drawing to the point established by previous Move...
            endpoint₃ = rotateby(Point3D(anchor.x + firstpoint₂.x, anchor.y - firstpoint₂.y, anchor.z), about, rotation)
            endpoint₂ = project(endpoint₃)
            if !isnothing(endpoint₂)
                line(endpoint₂)
            end
            mostrecentpoint₂ = currentpoint₂
            currentpoint₂ = firstpoint₂
            currentlength += plength
        end
        if currentlength > requiredlength  || abs(currentlength - requiredlength) < 1.0
             break
        end
    end
    do_action(action)
end
