using  Thebes

@svg begin
perspective(1200)
eyepoint(500, 500, 150)
k = 20
w, h = 20, 20
for x in 1:8
    for y in 1:8
        iseven(x + y) ? sethue("grey90") : sethue("grey10")

        z = 0
        plist = [
            Point3D(k * x,     k * y,  z),
            Point3D(k * x + w, k * y,  z),
            Point3D(k * x + w, k * y + h,  z),
            Point3D(k * x, k * y + h,  z)
            ]

        pts = pin(plist, gfunction = (p3, p2) -> begin
            d = distance(p3[1], Point3D(0, 0, 0))

            poly(p2, close=true, :fillpreserve)
            sethue("black")
            strokepath()
            end)

        #text("x$x/y$y", polycentroid(pts))
        end
    end
end 500 500 "/tmp/t.svg"
