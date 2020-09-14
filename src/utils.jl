

"""
    axes3D(n=100)

"""
function axes3D(n=100)
    projection = CURRENTPROJECTION[1]
    @layer begin
        fontsize(16)
        setline(2)
        xaxis1 = project(Point3D(0.1,   0.1,  0.1))
        xaxis2 = project(Point3D(n,   0.1,  0.1))
        sethue("red")
        if (xaxis1 != nothing) && (xaxis2 != nothing) && !isapprox(xaxis1, xaxis2)
            arrow(xaxis1, xaxis2)
            label("X", :N, xaxis2)
        end
        yaxis1 = project(Point3D(0.1,   0.1,  0.1))
        yaxis2 = project(Point3D(0.1,   n,  0.1))
        sethue("green")

        if (yaxis1 != nothing) &&  (yaxis2 != nothing) && !isapprox(yaxis1, yaxis2)
            arrow(yaxis1, yaxis2)
            label("Y", :N, yaxis2)
        end
        zaxis1 = project(Point3D(0.1,   0.1,  0.1))
        zaxis2 = project(Point3D(0.1,   0.1,  n))
        sethue("blue")
        if (zaxis1 != nothing) &&  (zaxis2 != nothing) && !isapprox(zaxis1, zaxis2)
            arrow(zaxis1, zaxis2)
            label("Z", :N, zaxis2)
        end
    end
end

"""
    drawunitbox(n=100, action=:stroke)
"""
function drawunitbox(n=100, action=:stroke)
    projection = CURRENTPROJECTION[1]
    @layer begin
        setline(2)
        fontsize(10)
        setlinecap("butt")
        setlinejoin("bevel")
        p1 = project(Point3D(0,   0,  0))
        p2 = project(Point3D(n,  0,  0))
        p3 = project(Point3D(n, n,  0))
        p4 = project(Point3D(0,  n,  0))
        p5 = project(Point3D(0,   0,  n))
        p6 = project(Point3D(n,  0,  n))
        p7 = project(Point3D(n, n,  n))
        p8 = project(Point3D(0,  n,  n))

        if all(i -> i != nothing, [p1, p2, p3,  p4, p5, p6, p7, p8])
            label("p1 Point3D(0,   0,  0)", :N, p1)
            label("p2 Point3D($(string(n)),  0,  0)", :N, p2)
            label("p3 Point3D($(string(n)), $(string(n)),  0)", :N, p3)
            label("p4 Point3D(0,  $(string(n)),  0)", :N, p4)
            label("p5 Point3D(0,   0, $(string(n)))", :S, p5)
            label("p6 Point3D($(string(n)),  0, $(string(n)))", :S, p6)
            label("p7 Point3D($(string(n)), $(string(n)), $(string(n)))", :S, p7)
            label("p8 Point3D(0,  $(string(n)), $(string(n)))", :S, p8)

            sethue("red")
            prettypoly([p1, p2, p3, p4], action, close=true)

            sethue("purple")
            prettypoly([p1, p2, p6, p5], action, close=true)

            sethue("magenta")
            prettypoly([p3, p7, p8, p4], action, close=true)

            sethue("green")
            prettypoly([p5, p6, p7, p8], action, close=true)
        end
    end
end

"""
    carpet(n; kind=:circular)

Draw a carpet centered at the origin, using current Luxor parameters.
"""
function carpet(n=100; kind=:circular)
    projection = CURRENTPROJECTION[1]
    @layer begin
        if kind != :circular
            p1 = project(Point3D(-n/2, -n/2,  0))
            p2 = project(Point3D(n/2,  -n/2,  0))
            p3 = project(Point3D(n/2, n/2,  0))
            p4 = project(Point3D(-n/2,  n/2,  0))
            if all(i -> i != nothing, [p1, p2, p3,  p4])
                poly([p1, p2, p3, p4], :fill, close=true)
            end
        else
            shape3D = [Point3D(n * cos(theta), n * sin(theta), 0) for theta in 0:0.1:2pi]
            shape2D = Point[]
            for i in shape3D
                pt = project(i)
                if pt != nothing
                    push!(shape2D, pt)
                end
            end
            poly(shape2D, :fill, close=true)
        end
    end
end