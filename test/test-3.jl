using Thebes, Luxor, Random

using ColorSchemes

Drawing(800, 800, "/tmp/test3.png")
background("azure")
origin()
#setopacity(0.5)
eyepoint    = Point3D(1000, 1, 300)
centerpoint = Point3D(0, 0, 10)
uppoint     = Point3D(0, 0, 20) # relative to centerpoint
projection  = newprojection(eyepoint, centerpoint, uppoint)
sethue("pink")
drawcarpet(400, projection)
colors = Random.shuffle!(Base.eval(ColorSchemes, schemes[rand(1:end)]))
setline(0.2)

myrenderfunction(vertices, faces, labels, cols) =
    Thebes.simplerender(vertices, faces, labels, cols, action=:fill)

for k in 1:4:20
    for i in 1:20
        object = make(Pyramid)
        objects = [object]
        s = rescale(k, 5, 20, 10, 20)
        changescale!.(objects, s, s, s)
        changeposition!.(objects, rescale(k, 1, 20, 50, 400), 1, 0)
        a = rescale(i, 1, 20, 0, 2pi)
        rotateto!.(objects, 0, 0, a)
        sortfaces!(objects, eyepoint=eyepoint)
        # default is stroke at the moment
        drawmodel.(objects, projection, cols=colors, renderfunction=myrenderfunction)
    end
end
finish()
