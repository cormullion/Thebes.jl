using Thebes, Luxor, Random

include(dirname(pathof(Thebes)) * "/../data/moreobjects.jl")

function mygfunction(o::Object)
    sortfaces!(o)
    if !isempty(o.faces)
        @layer begin
            for (n, face) in enumerate(o.faces)
                @layer begin
                    vertices = o.vertices[face]
                    sn = surfacenormal(vertices)
                    ang = anglebetweenvectors(sn, eyepoint())
                    setgrey(rescale(ang, 0, π, 0, 1))
                    pin(vertices, gfunction=(p3, p2) -> poly(p2, :fill))
                end
            end
        end
    end
end

function drawgeodesic(object, cpos, cscale, rotx, roty, rotz, eased)
    eyepoint(Point3D(1200, 1200, 200))

    c = scaleby!(object, cscale.x, cscale.y, cscale.z)
    moveby!(c, cpos)
    theta = rescale(eased, 0, 1, 0, 2pi)
    rotateby!(c, Point3D(0, 0, 0), theta, theta, theta)
    pin(c, gfunction = mygfunction)
end

function backdrop(scene, framenumber)
    pl = box(O, scene.movie.width, scene.movie.height, vertices=true)
    # start at bottom left
    mesh1 = mesh(pl, [
    "midnightblue",
        "grey80",
        "grey70",
        "midnightblue",
    ])
    setmesh(mesh1)
    poly(pl, :fill)
end

function frame1(scene, framenumber)
    sethue("black")
    setline(0.5)
    setlinejoin("bevel")
    setopacity(0.6)
    eased_n = scene.easingfunction(framenumber, 0, 1, scene.framerange.stop)
    # object, cpos, cscale, rotx, roty, rotz, eased
    drawgeodesic(Thebes.copyobject(object), 
        Point3D(0, 0, 0),  # center
        Point3D(150, 150, 150), # scale 
        0, 
        0, 
        0, 
        eased_n)
end

geodesicmovie = Movie(500, 500, "geodesic")
object = sortfaces!(make(geodesic, "geodesic"))

animate(geodesicmovie, [
    Scene(geodesicmovie, backdrop, 1:50),
    Scene(geodesicmovie, frame1, 1:50, easingfunction=easeinoutsine)], creategif=true,
    framerate=5, 
    pathname="/tmp/geodesic.gif")
