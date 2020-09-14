"""
    text3D(str, pt::Point3D;
        halign=:left,
        valign=:baseline,
        rotation = (0, 0, 0)))

Draw text in 3D.
"""
function text3D(str, origin::Point3D;
        halign=:left,
        valign=:baseline,
        rotation = (0, 0, 0))

    textoutlines(str, O, :path,
        halign=halign,
        valign=valign,
        startnewpath=true)

    o = getpathflat()
    newpath() # otherwise the path would be drawn twice
    z = origin.z
    for e in o
        if e.element_type == 0
            (x, y) = e.points
            pt3 = rotateby(origin + Point3D(x, -y, z), origin, rotation...)
            pin(pt3, gfunction = (p3, p2) -> move(p2))
        elseif e.element_type == 1
            (x, y) = e.points
            pt3 = rotateby(origin + Point3D(x, -y, z), origin, rotation...)
            pin(pt3, gfunction = (p3, p2) -> line(p2))
        elseif e.element_type == 3
            closepath()
        else
            error("unknown path element " * repr(e.element_type) * repr(e.points))
        end
    end
    fillpath()
end
