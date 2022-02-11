using LaTeXStrings
import MathTeXEngine:
    generate_tex_elements, inkwidth, inkheight, bottominkbound, TeXChar, HLine


"""
     text3D(str::LaTeXString, anchor::Point3D;
        halign=:left,
        valign=:baseline,
        about=Point3D(0., 0., 0.),
        rotation::Rotation=RotXYZ(0, 0, 0))

Like `text3D()` but draws LaTeX strings.
"""
function text3D(str::LaTeXString, anchor::Point3D;
        halign=:left,
        valign=:baseline,
        about=Point3D(0., 0., 0.),
        rotation::Rotation=RotXYZ(0, 0, 0))

    # this is just a hacked version of the Luxor code

    # Function from MathTexEngine
    sentence = generate_tex_elements(str)

    # Get current font size.
    font_size = get_fontsize()

    textw, texth = latextextsize(str)
    bottom_pt, top_pt = rawlatexboundingbox(str)

    translate_x, translate_y = Luxor.texalign(halign, valign, bottom_pt, top_pt, font_size)

    pt = project(anchor)

    rotationfixed=true
    # Writes text using ModernCMU font.
    for text in sentence
        if isnothing(pt)
            continue
        end
        @layer begin
            translate(pt)
            if !rotationfixed
                #rotate(angle) ?
                translate(translate_x, translate_y)
            else
                l_pt, r_pt = Luxor.latexboundingbox(str, halign = halign, valign = valign)
                translate((l_pt + r_pt)/2)
                #rotate(angle) ?
                translate(Point(translate_x, translate_y) - (l_pt + r_pt)/2)
            end
            if text[1] isa TeXChar
                fontface(text[1].font.family_name)
                fontsize(font_size * text[3])
                # Luxor.text(string(text[1].char), Point(text[2]...) * font_size * (1, -1))
                textoutlines(string(text[1].char), Point(text[2]...) * font_size * (1, -1), :path,
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

            elseif text[1] isa HLine
                pointstart = Point(text[2]...) * font_size * (1, -1)
                pointend = pointstart + Point(text[1].width, 0) * font_size

                newstartpt = rotateby(Point3D(anchor.x + pointstart.x, anchor.y - pointstart.y, anchor.z), about, rotation)
                newendpt = rotateby(Point3D(anchor.x + pointend.x, anchor.y - pointend.y, anchor.z), about, rotation)

                pin(newstartpt, newendpt)
            end
        end
    end
end
