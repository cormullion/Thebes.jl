using Thebes, Luxor

function mygfunction(vertices, faces, labels; action=:fill)
    if !isempty(faces)
        @layer begin
            for (n, p) in enumerate(faces)
                @layer begin
                    setopacity(0.5)
                    randomhue()
                    poly(p, action)
                end

                sethue("black")
                setline(0.5)
                poly(p, :stroke, close=true)

            end
        end
    end
end

@svg begin
    background("black")
    setlinejoin("bevel")
    eyepoint(Point3D(150, 150, 20))
    sethue("pink")
    carpet(200)
    axes3D(20)

    #object = make(Cube, "Cube")
    #object = make(Tetrahedron, "Tetrahedron")
    object = make(Pyramid, "Pyramid")

    scaleby!(object, 100, 100, 100)
    rotateby!(object, Point3D(0, 0, 0), 0, 0, rand())
    sortfaces!(object)
    sethue("orange")
    pin(object, gfunction= mygfunction)
end 500 500 "/tmp/cube.svg"
