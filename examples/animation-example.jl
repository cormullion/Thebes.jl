using Thebes, Luxor, Random

include(dirname(pathof(Thebes)) * "/../data/moreobjects.jl")

mygfunction(vertices, faces, labels) =
    Thebes.simplegfunction(vertices, faces, labels, action=:fill)

function frame(scene, framenumber)
    background("white")
    # flyaround
    theta = rescale(framenumber, 1, scene.framerange.stop, 0, 2pi)
    eyepoint(Point3D(150 + 80(cos(theta)), 150 + 80(sin(theta)), 40(sin(theta))))

    sethue("white")
    carpet(1000)
    drawunitbox(250)
    axes3D(250)

    setline(.5)
    setopacity(0.5)
    st = [-2, 1, 2]
    for x in st, y in st, z in st
      n = x * y * z
      object = make(tetrahedron)
      setscale!(object, 10, 10, 10)
      setposition!(object, x * 25, y * 25, z * 25)
      d = distance(object.vertices[end], Point3D(0, 0, 0))
      if d < 1200
          pin(object, gfunction=mygfunction)
      end
    end
    sethue("black")
    text(string(eyepoint()), Point(0, boxheight(BoundingBox()/2) - 20))
end

width, height = (800, 800)

threedmovie = Movie(width, height, "threedmovie")

animate(threedmovie, [
    Scene(threedmovie, frame, 1:25)
    ],
    creategif=true,
    framerate=20,
    pathname="/tmp/threed-animation.gif")
