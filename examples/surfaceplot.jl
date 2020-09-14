using Thebes, Luxor, Colors

@png begin
    setlinejoin("bevel")
    helloworld()
    perspective(300)
    eyepoint(800, 700, 600)
    uppoint(0, 0, 10)
    setopacity(0.7)
    k = 50
    xmax = 6π
    ymax = 6π
    st = 0.15
    f(x, y) = 2(sin(x) * cos(y)) + (cos(x) * sin(y))
    setline(.5)
    fontsize(5)
    for x in -xmax:st:xmax
        for y in -ymax:st:ymax
            sethue(HSB(360rescale(f(x, y), -2, 2), .7, .7))
            p1 = Point3D(k * x,        k * y,       k * f(x, y))
            p2 = Point3D(k * (x ),     k * (y + st), k * f(x, y +st))
            p3 = Point3D(k * (x + st),  k * (y + st), k * f(x + st, y + st))
            p4 = Point3D(k * (x + st),  k * y,       k * f(x + st, y))
            pin([p1, p2, p3, p4], gfunction = (p3s, p2s) -> begin
                poly(p2s, close=true, :fill)
                sethue("red")
                poly(p2s, close=true, :stroke)
            end)
        end
    end
    axes3D()
end 500 500 "/tmp/t.png"
