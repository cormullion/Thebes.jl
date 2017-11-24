using Luxor, Thebes

@svg begin
    background("ivory")
    tiles = Tiler(1200, 1200, 8, 8, margin=25)
    setopacity(0.9)
    setlinejoin("bevel")
    persp = Projection(0, 0, Point3D(500, 500, 1200))
    s = make(Axes3D)
    @show s
    resize!(s, 5, 5, 5)

    cols = ["white", "red", "green", "blue", "orange"]
    for (pos, n) in tiles
        @layer begin
            angleX = rand()
            angleY = rand()
            angleZ = rand()
            translate(pos)
            rotateto!(s, angleX, angleY, angleZ)
            # move!(s, Point3D(10, 10, 10))
            # sortfaces!(s)
            verts, faces = modeltopoly(s, persp)
            cols=["red"]
            drawmodel(s, persp, cols, :fill)
            sethue("black")
            for pt in verts
               circle(pt, .15, :fill)
            end
        end
    end
end 500 500
