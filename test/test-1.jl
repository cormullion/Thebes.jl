using Thebes, Luxor, Random, Rotations

function main()
    Drawing(800, 800, "test1.svg")
    origin()
    background("grey95")
    setopacity(0.7)
    setlinejoin("bevel")
    eyepoint(Point3D(500, 500, 100))
    uppoint(Point3D(0, 0, 20))
    centerpoint(Point3D(0, 0, 10))
    tiles = Tiler(800, 800, 6, 6)
    fontsize(20)
    for (pos, n) in tiles
        @layer begin
            r = RotXYZ(0, 0, 0)
            translate(pos)
            axes3D(150)
            object = make(Cube)
            scaleby!(object, 50, 50, 50)
            moveby!(object, 0, 0, 0)
            rotateby!(object, 0, n/5, 0)
            sortfaces!(object)
            pin(object)
            sethue("black")
            text(string(n), O  + (0, 30))
            fontsize(50)
            r *= RotXYZ(0, n/5, 0)
            text3D("$n", halign=:center, object.vertices[1], rotation = r)
        end
    end
    finish()
    preview()
end

main()
