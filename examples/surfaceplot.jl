using Thebes, Luxor, Colors

@drawsvg begin
    background("grey10")
    setlinejoin("bevel")
    helloworld()
#    perspective(200)
    eyepoint(sphericaltocartesian(200, deg2rad(10), deg2rad(50)))
    uppoint(0, 0, 10)
    setopacity(0.9)
    k = 70
    xmax = 2π
    ymax = 2π
    st = 0.2
    f(x, y) = 2(sin(x) * cos(y)) + (cos(x) * sin(y))
    setline(1)
    for x in -xmax:st:xmax
        for y in -ymax:st:ymax
            sethue(HSB(rescale(f(x, y), -π/2, π/2, 200, 320), .7, .7))
            p1 = Point3D(k * x,        k * y,       k * f(x, y))
            p2 = Point3D(k * (x ),     k * (y + st), k * f(x, y +st))
            p3 = Point3D(k * (x + st),  k * (y + st), k * f(x + st, y + st))
            p4 = Point3D(k * (x + st),  k * y,       k * f(x + st, y))
            pin([p1, p2, p3, p4], gfunction = (p3s, p2s) -> begin
                poly(p2s, close=true, :fill)
                sethue("grey70")
                poly(p2s, close=true, :stroke)
            end)
        end
    end
    axes3D()
end
