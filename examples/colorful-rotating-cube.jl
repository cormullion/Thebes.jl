using Thebes, Luxor, Random


function cuboid(cpos::Point3D, w, h, d)
    pin(cpos + (w/2, h/2, d/2), cpos + (-w/2, h/2, d/2))
end

function frame(scene, framenumber)
    background("midnightblue")
    setlinejoin("bevel")
    setline(5.0)

    eased_n = scene.easingfunction(framenumber, 0, 1, scene.framerange.stop)
    eased_n_2π = eased_n * 2π

    perspective(0)
    eyepoint(Point3D(100 * cos(eased_n_2π), 100 * sin(eased_n_2π), 50 + 20sin(eased_n_2π)))

    carpet()
    axes3D()
    temp = Point3D[]
    k = 19
    for z in -50:k:50
        for y in -50:k:50
            for x in -50:k:50
                push!(temp, Point3D(x, y, z))
            end
        end
    end
    # sort by distance
    sort!(temp, lt = (a, b) -> distance(a, eyepoint()) > distance(b, eyepoint()))
    for pt in temp
        sethue(rescale.([pt.x, pt.y, pt.z], -50, 50, 0, 1)...)
        pin(pt, gfunction = (pt3, pt2) -> begin
            d = rescale(distance(pt3, eyepoint()), 1, 200, 10, 5)
            circle(pt2, d, :fill)
        end)
    end
end

animation = Movie(400, 400, "thebes")

Random.seed!(42)

animate(animation, [Scene(animation, frame, 1:100)],
    framerate=15,
    creategif=true,
    pathname="animation.gif")
