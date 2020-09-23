using Thebes, Luxor

include(dirname(pathof(Thebes)) * "/../data/moreobjects.jl")

Drawing(800, 800, "/tmp/test1.png")
origin()
background("grey95")
setopacity(0.95)

eyepoint(Point3D(800 ,600, 500))

sethue("grey90")
carpet(600)
drawcube(500)

setline(.5)
setopacity(1)
for i in -20:10:20, j in -20:10:20, z in -20:10:20
    object = make(sphere2)
    scaleby!(object, 50, 50, 50)
    moveby!(object, i * 15, j * 15, z * 15)
    d = distance(object.vertices[1], Point3D(0, 0, 0))
    if d < 300
        pin(object)
    end
end

finish()

preview()
