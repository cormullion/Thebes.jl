"""
     text3D(str, anchor::Point3D;
        halign=:left,
        valign=:baseline,
        about=Point3D(0., 0., 0.),
        rotation::Rotation=RotXYZ(0, 0, 0))

Draw text at point `pt`, lying in the plane of the x axis.
Angles in `rotation` rotate the text about the `about` point,
defaulting to `Point3D(0, 0, 0)`.

Uses Luxor's `fontface()` and `fontsize()` settings.

Specify rotations using functions from Rotations.jl, such as:

- `RotX(a)`
- `RotZ(a)`
- `RotXZ(a1, a2)`
- `RotXYZ(a1, a2, a3)`
"""
function text3D(str, anchor::Point3D;
        halign=:left,
        valign=:baseline,
        about=Point3D(0., 0., 0.),
        rotation::Rotation=RotXYZ(0, 0, 0))

    textoutlines(str, O, :path,
        halign=halign,
        valign=valign,
        startnewpath=true)

    o = getpathflat()
    newpath() # otherwise the path would be drawn twice
     for e in o
        if e.element_type == 0
            (x, y) = e.points
            newpt = rotateby(Point3D(anchor.x + x, anchor.y -y, anchor.z), about, rotation)
            pin(newpt,  gfunction = (p3, p2) -> move(p2))
        elseif e.element_type == 1
            (x, y) = e.points
            newpt = rotateby(Point3D(anchor.x + x, anchor.y -y, anchor.z), about, rotation)
            pin(newpt,  gfunction = (p3, p2) -> line(p2))
        elseif e.element_type == 3
            closepath()
        else
            error("unknown path element " * repr(e.element_type) * repr(e.points))
        end
    end
    fillpath()
end
