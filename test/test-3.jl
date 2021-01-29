using Thebes, Luxor, Random

function main()
    Drawing(800, 800, "test3.png")
    background("azure")
    origin()

    eyepoint(Point3D(500, 500, 300))
    perspective(1500)
    sethue("pink")
    carpet(400)
    setline(0.2)

    mygfunction(vertices, faces, labels) = begin
        randomhue()
        Thebes.simplegfunction(vertices, faces, labels, action=:fill)
    end

    for k in 1:4:20
        for i in 1:20
            object = make(Pyramid)
            objects = [object]
            s = rescale(k, 5, 20, 10, 20)
            scaleby!.(objects, s, s, s)
            moveby!.(objects, rescale(k, 1, 20, 50, 400), 1, 0)
            a = rescale(i, 1, 20, 0, 2pi)
            rotateby!.(objects, 0, 0, a)
            sortfaces!(objects, eyepoint = eyepoint)
            # default is stroke at the moment
            pin.(objects, gfunction = mygfunction)
        end
    end
    finish()
end

main()
