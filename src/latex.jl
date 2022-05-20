using LaTeXStrings
import MathTeXEngine:
    generate_tex_elements, inkwidth, inkheight, bottominkbound, TeXChar, HLine

# try this version using Paths

"""
text3D(str::LaTeXString, anchor::Point3D;
        halign=:left,
        valign=:baseline,
        about=Point3D(0., 0., 0.),
        rotation::Rotation=RotXYZ(0, 0, 0),
        portion = 1.0,
        steps = 20,
        startnewpath=true,
        action=:fill)

Like `text3D()` but draws LaTeX strings. Needs Luxor >= 3.1.
"""
function text3D(str::LaTeXString, anchor::Point3D;
        halign=:left,
        valign=:baseline,
        about=Point3D(0., 0., 0.),
        rotation::Rotation=RotXYZ(0, 0, 0),
        portion = 1.0,
        steps = 20,
        startnewpath=true,
        action=:fill)

    text(str, paths=true, halign=halign, valign=valign) # angle? rotationfixed?
    latexpath = storepath()
    drawpath(latexpath, portion, anchor, action=action, startnewpath=startnewpath, about=about, rotation=rotation, steps=steps)
end
