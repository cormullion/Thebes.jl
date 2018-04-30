using Thebes, Luxor

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
    eyepoint    = Point3D(40, 30, 40)
    centerpoint = Point3D(0, 0, 1)
    uppoint     = Point3D(0, 0, 2) # relative to centerpoint
    projection  = newprojection(eyepoint, centerpoint, uppoint, 800)
    o = :Cube
    object = make(eval(o), string(o))
    changescale!(object, 15, 15, 15)
    rotateby!(object, Point3D(0, 0, 0), 0, 0, rand())
    sortfaces!(object)
    sethue("orange")
    drawcarpet(20, projection)
    drawmodel(object, projection,
        cols=["magenta", "green", "red", "blue", "yellow", "orange"],
        renderfunc = myrenderfunction)
    draw3daxes(20, projection)
end
