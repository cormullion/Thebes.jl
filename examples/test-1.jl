using Thebes, Luxor

using ColorSchemes

cols = shuffle!(eval(ColorSchemes, schemes[rand(1:end)]))

function axes_threed(n)
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
        drawmodel(m, Point3D(200, 200, 200), :fill, cols=cols)
    end
end

@svg begin
    background("grey95")
    setopacity(0.95)
    camerapoint = Point3D(100, 0, 0)
    theta = pi/2
    axes_threed(300)
    tiles = Tiler(800, 800, 6, 6)
    for (pos, n) in tiles
        @layer begin
            translate(pos)
            object = make(Pyramid)
            changescale!(object, 15, 15, 15)
            changeposition!(object, 0, 0, 0)
            rotateto!(object, 0, n/5, 0)
            sortfaces!(object)
            drawmodel(object, camerapoint, :fill; cols=cols)
            sethue("black")
            text(string(round(n/5, 1)))
        end
    end
end

# ["red", "blue", "green", "yellow", "orange", "black"]
