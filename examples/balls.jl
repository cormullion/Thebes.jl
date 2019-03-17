using Thebes, Luxor

using ColorSchemes

include(dirname(pathof(Thebes)) * "/../src/moreobjects.jl")

cols = colorschemes[first(Random.shuffle!(collect(keys(colorschemes))))]

Drawing(800, 800, "/tmp/test1.png")
origin()
background("grey95")
setopacity(0.95)

eyepoint    = Point3D(800 ,600, 1000)
centerpoint = Point3D(0, 0, 0)
uppoint     = Point3D(0, 0, 10) # relative to centerpoint

projection  = newprojection(eyepoint, centerpoint, uppoint, 800)

sethue("grey90")
drawcarpet(600, projection)
drawunitbox(500, projection)

setline(.5)
setopacity(1)
for i in -20:10:20, j in -20:10:20, z in -20:10:20
    object = make(sphere2)
    changescale!(object, 50, 50, 50)
    changeposition!(object, i * 15, j * 15, z * 15)
    # sortfaces!(object)
    # rotateto!(object, 0, 0, 0)
    d = distance(object.vertices[1], Point3D(0, 0, 0))
    if d < 300
        drawmodel(object, projection, cols=[randomhue(), randomhue(), randomhue()])
    end
end

finish()

preview()
