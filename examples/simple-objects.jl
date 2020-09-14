using Thebes, Luxor

function mygfunction(vertices, faces, labels; action=:fill)
    if !isempty(faces)
        @layer begin
            for (n, p) in enumerate(faces)
                x = mod1(n, length(cols))
                c = cols[mod1(labels[x], length(cols))]

                @layer begin
                    setopacity(0.5)
                    sethue(c)
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
    #object = make(AxesWire, "AxesWire")
    #object = make(Carpet, "Carpet")
    object = make(Pyramid, "Pyramid")

    setscale!(object, 100, 100, 100)
    rotateby!(object, Point3D(0, 0, 0), 0, 0, rand())
    sortfaces!(object)
    sethue("orange")
    pin(object, gfunction= mygfunction)
end 500 500 "/tmp/cube.svg"
