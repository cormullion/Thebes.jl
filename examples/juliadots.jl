using  Thebes, Luxor, Rotations

function juliadots3D(origin::Point3D, rotation::Rotation=RotXYZ(0, 0, 0);
    radius=100)
    threedots = Array{Point3D, 1}[]
    points = ngon(O, radius, 3, -π/3, vertices=true) #
    @layer begin
        for (n, p) in enumerate(points)
            # zcoordinate defaults to 0 in convert()
            # TODO broadcasting needs a look
            push!(threedots, Ref(origin) .+ convert.(Point3D, ngon(p, 0.75 * radius, 60)))
        end
        for (n, dot) in enumerate(threedots)
            sethue([Luxor.julia_purple, Luxor.julia_green, Luxor.julia_red][mod1(n, end)])
            # rotate about an arbitrary point (first pt of green dot will do for now)
            rotateby!(dot, threedots[2][1], rotation)
            pin(5dot, gfunction = (_, pts) -> poly(pts, close=true, :fill))
        end
    end
end

function juliaroom()
    @svg begin
        background("black")
        helloworld()
        eyepoint(1200, 1200, 1200)
        perspective(1200)
        for x in 30:30:500
            for y in 30:30:500
                juliadots3D(Point3D(x, y, 0), RotXYZ(0, 0, 0), radius=8)
            end
        end
        for x in 30:30:500
            for z in 30:30:500
                juliadots3D(Point3D(x, 0, z), RotXYZ(-π/2, 0, π/2), radius=8)
            end
        end
        for y in 30:30:500
            for z in 30:30:500
                juliadots3D(Point3D(0, y, z), RotXYZ(0, π/2, 0), radius=8)
            end
        end

        axes3D(300)
    end
end

juliaroom()
