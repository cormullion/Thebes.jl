using Thebes, Luxor

@draw begin
    background("black")
    setopacity(0.5)
    sethue("gold")
    c = pin.([Point3D(randn() * 50, randn() * 50, randn() * 50) for x in 1:75, y in 1:75, z in 1:75], gfunction = (pt3, pt2) -> begin
        circle(pt2, 1, :fill)
    end)
    axes3D()
    @show length(c)
end
