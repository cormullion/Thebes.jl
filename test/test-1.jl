using Thebes, Luxor

using ColorSchemes

cols = shuffle!(eval(ColorSchemes, schemes[rand(1:end)]))

function axes_threed(n, projection::Projection)
    xaxis = make(Cube)
    changescale!(xaxis, n, 1, 1)
    changeposition!(xaxis, n/2, 0, 0)
    yaxis = make(Cube)
    changescale!(yaxis, 1, n, 1)
    changeposition!(xaxis, 0, n/2, 0)
    zaxis = make(Cube)
    changescale!(zaxis, 1, 1, n)
    changeposition!(xaxis, 0, 0, n/2)
    for m in [xaxis, yaxis, zaxis]
        drawmodel(m, projection, :fill, cols=cols)
    end
end

Drawing(800, 800, "/tmp/test1.svg")
    origin()
    background("grey95")
    setopacity(0.95)
    eyepoint    = Point3D(500, 500, 100)
    centerpoint = Point3D(0, 0, 100)
    uppoint     = Point3D(0, 0, 200) # relative to centerpoint
    projection  = newprojection(eyepoint, centerpoint, uppoint)
    axes_threed(300, projection)
    tiles = Tiler(800, 800, 6, 6)
    for (pos, n) in tiles
        @layer begin
            translate(pos)
            object = make(Pyramid)
            changescale!(object, 15, 15, 15)
            changeposition!(object, 0, 0, 0)
            rotateto!(object, 0, n/5, 0)
            sortfaces!(object)
            drawmodel(object, projection, :fill; cols=cols)
            sethue("black")
            text(string(round(n/5, 1)))
        end
    end
finish()
preview()
