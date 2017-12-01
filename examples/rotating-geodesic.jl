using Thebes, Luxor

using ColorSchemes

cols = shuffle!(eval(ColorSchemes, schemes[rand(1:end)]))

include(Pkg.dir() * "/Thebes/src/moreobjects.jl")

function myrenderfunction(vertices, faces, labels, cols, action=:fill)
    if !isempty(faces)
        @layer begin
            for (n, p) in enumerate(faces)
                x = mod1(n, length(cols))
                c = cols[mod1(labels[x], length(cols))]
                sethue(c)
                poly(p, action)
            end
        end
    end
end

function drawgeodesic(object, cpos, cscale, rotx, roty, rotz, cscheme, eased)
    camerapoint = Point3D(300, 300, 100)
    c = changescale!(object, cscale.x, cscale.y, cscale.z)
    changeposition!(c, cpos)
    theta = rescale(eased, 0, 1, 0, 2pi)
    rotateby!(c, Point3D(0, 0, 0), theta, theta, theta)
    drawmodel(c, camerapoint, :fill, cols=cscheme, renderfunc = myrenderfunction)
end


function backdrop(scene, framenumber)
    pl = box(O, scene.movie.width, scene.movie.height, vertices=true)
    # start at bottom left
    mesh1 = mesh(pl, [
    "midnightblue",
        "azure",
        "azure",
        "midnightblue",
    ])
    setmesh(mesh1)
    poly(pl, :fill)
end

function frame1(scene, framenumber)
    sethue("black")
    setlinejoin("bevel")
    setopacity(0.5)
    eased_n = scene.easingfunction(framenumber, 0, 1, scene.framerange.stop)
    drawgeodesic(deepcopy(object), Point3D(0, 0, 0), Point3D(160, 160, 160), 0, 0, 0, cs, eased_n)
end

geodesicmovie = Movie(400, 400, "geodesic")
cs = shuffle(ColorSchemes.magma)
object = sortfaces!(make(geodesic, "geodesic"))

animate(geodesicmovie, [
    Scene(geodesicmovie, backdrop, 1:400),
    Scene(geodesicmovie, frame1, 1:400, easingfunction=easeinoutsine)], creategif=true,
    pathname="/tmp/geodesic.gif")
