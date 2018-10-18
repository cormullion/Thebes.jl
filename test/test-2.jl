using Thebes, Luxor

using ColorSchemes

cols = ColorSchemes.sandyterrain

myrenderfunction(vertices, faces, labels, cols) =
    Thebes.simplerender(vertices, faces, labels, cols, action=:fill)

Drawing(400, 400, "/tmp/test2-pyramids.png")
origin()
background("lightblue1")
setopacity(1)

eyepoint    = Point3D(160, 160, 40)
centerpoint = Point3D(0, 0, 10)
uppoint     = Point3D(0, 0, 20) # relative to centerpoint
projection  = newprojection(eyepoint, centerpoint, uppoint, 500)

setblend(blend(O, 50, O, 500, cols[1], cols[5]))
drawcarpet(400, projection, kind=:circular)

objects = [make(Pyramid), make(Pyramid), make(Pyramid)]
changescale!.(objects, 10, 10, 15)
changeposition!.(objects, [-25, 0, 35], 0, 0)

# needs depth sorting of faces
sortfaces!.(objects, eyepoint=eyepoint)
drawmodel.(objects, projection, cols=cols, renderfunction=myrenderfunction)
finish()
