using Thebes, Luxor, Random
mygfunction(vertices, faces, labels) =
Thebes.simplegfunction(vertices, faces, labels, action=:fill)

function main()
    Drawing(800, 800, "/tmp/test1.svg")
    origin()
    background("grey95")
    setopacity(0.7)
    setlinejoin("bevel")
    eyepoint(Point3D(500, 500, 100))
    centerpoint(Point3D(0, 0, 10))
    uppoint(Point3D(0, 0, 20))
    tiles = Tiler(800, 800, 6, 6)
    fontsize(20)
    for (pos, n) in tiles
        @layer begin
            translate(pos)
            axes3D(150)
            object = make(Cube)
            scaleby!(object, 25, 25, 25)
            moveby!(object, 0, 0, 0)
            rotateby!(object, 0, n/5, 0)
            sortfaces!(object)
            pin(object, gfunction=mygfunction)
            sethue("black")
            text(string(round(n/5, digits = 1)), O  + (0, 30))
            fontsize(100)
            text3D(".", Point3D(0, 0, 0), rotation = (π/2, 0, π/2))
        end
    end
    finish()
end

main()
