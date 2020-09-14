using  Thebes, Luxor

function juliadots3D(origin::Point3D, rotation=(0, 0, 0);
    radius=100)
    dots = Array{Point3D, 1}[]
    points = ngon(O, radius, 3, -π/3, vertices=true)
    @layer begin
        for (n, p) in enumerate(points)
            push!(dots, origin .+ convert.(Point3D, ngon(p, 0.75 * radius, 60)))
        end
        for (n, d) in enumerate(dots)
            sethue([Luxor.julia_purple, Luxor.julia_green, Luxor.julia_red][mod1(n, end)])
            # rotate about an arbitrary point
            d1 = rotateby.(d, dots[2][1], rotation...)
            pin(d1, gfunction = (_, pts) -> poly(pts, close=true, :fill))
        end
    end
end


function juliaroom()
    @svg begin
        background("black")
        helloworld()
        eyepoint(1200, 1200, 1200)
        perspective(800)
        for x in 30:50:500
            for y in 30:50:500
                    juliadots3D(Point3D(x, y, 0), (0, 0, 0), radius=12)
            end
        end
        for x in 30:50:500
            for z in 30:50:500
                    juliadots3D(Point3D(x, 0, z), (π/2, π/2, 0), radius=12)
            end
        end
        for y in 30:50:500
            for z in 30:50:500
                    juliadots3D(Point3D(0, y, z), (0, π/2, -π), radius=12)
            end
        end

        axes3D(300)
    end 500 500 "/tmp/t.svg"
end

juliaroom()
