using Thebes, Luxor, Random, ColorSchemes

cols = colorschemes[first(Random.shuffle!(collect(keys(colorschemes))))]

myrenderfunction(vertices, faces, labels, cols) =
    Thebes.simplerender(vertices, faces, labels, cols, action=:fill)

Drawing(800, 800, "/tmp/test1.svg")
origin()
background("grey95")
setopacity(0.7)
eyepoint    = Point3D(500, 500, 100)
centerpoint = Point3D(0, 0, 10)
uppoint     = Point3D(0, 0, 20) # relative to centerpoint
projection  = newprojection(eyepoint, centerpoint, uppoint, 700)
tiles = Tiler(800, 800, 6, 6)
for (pos, n) in tiles
    @layer begin
        translate(pos)
        draw3daxes(50, projection)
        object = make(Cube)
        changescale!(object, 25, 25, 25)
        changeposition!(object, 0, 0, 0)
        rotateto!(object, 0, n/5, 0)
        sortfaces!(object)
        drawmodel(object, projection, cols=cols, renderfunction=myrenderfunction)
        sethue("black")
        text(string(round(n/5, digits = 1)))
    end
end
finish()
