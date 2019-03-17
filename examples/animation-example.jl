using Thebes, Luxor

using ColorSchemes

include(dirname(pathof(Thebes)) * "/../src/moreobjects.jl")

cols = colorschemes[first(Random.shuffle!(collect(keys(colorschemes))))]

myrenderfunction(vertices, faces, labels, cols) =
    Thebes.simplerender(vertices, faces, labels, cols, action=:fill)

function frame(scene, framenumber)
    background("white")
    # flyaround
    theta = rescale(framenumber, 1, scene.framerange.stop, 0, 2pi)
    eyepoint    = Point3D(600cos(theta), 600sin(theta), rescale(theta, 0, 2pi, 100, 400))
    centerpoint = Point3D(0, 0, 10)
    uppoint     = Point3D(0, 0, 20) # relative to centerpoint
    projection  = newprojection(eyepoint, centerpoint, uppoint, 1000)

    sethue("white")
    # drawcarpet(1000, projection)
    # drawunitbox(50, projection)
    draw3daxes(100, projection)

    setline(.5)
    setopacity(0.5)
    st = [-2, 1, 2]
    for x in st, y in st, z in st
      n = x * y * z
      object = make(tetrahedron)
      changescale!(object, 20, 20, 20)
      changeposition!(object, x * 25, y * 25, z * 25)
      d = distance(object.vertices[end], Point3D(0, 0, 0))
      if d < 800
          drawmodel(object, projection,
            cols=[get(ColorSchemes.rainbow, rescale(x, -2, 2, 0, 1))],
            renderfunction=myrenderfunction)
      end
    end
    sethue("black")
    text(string(eyepoint), Point(0, boxheight(BoundingBox()/2) - 20))
end

width, height = (800, 800)

threedmovie = Movie(width, height, "threedmovie")

animate(threedmovie, [
    Scene(threedmovie, frame, 1:25)
    ],
    creategif=true,
    framerate=3,
    pathname="/tmp/threed-animation.gif")
