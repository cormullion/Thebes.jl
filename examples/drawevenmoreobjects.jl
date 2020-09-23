using Thebes, Luxor

include(string(pathof(Thebes), "../../../data/evenmoreobjects.jl"))

evenmoreobjects = [:Apple, :Sword01, :asu, :dragon, :goblet,
:head, :heart, :helm, :house, :king, :klingon, :mushroom, :pear, :r2,
:seashell, :space_shuttle, :space_station, :teapot, :volks,
:x29_plane]

function anothergfunction(vertices, faces, labels, action=:fill)
    if !isempty(faces)
        @layer begin
            for (n, p) in enumerate(faces)
                poly(p, action)
            end
        end
    end
end

function main()
    Drawing(1200, 1200, "/tmp/evenmoreobjects.png")
    origin()
    background("grey20")
    setopacity(0.75)

    axes3D()
    eyepoint(Point3D(500, 500, 500))
    centerpoint(Point3D(0, 0, 0))
    perspective(1000)
    setline(1)

    K = 120

    m = 1
    for x in -500:K:500
        for y in -500:K:500
            o = evenmoreobjects[mod1(m, length(evenmoreobjects))]
            object = make(eval(o))

            scalefactor = distance(extrema(object.vertices)...)

            loc = Point3D(x, y, 0)
            moveby!(object, loc)

            scaleby!(object, 1/scalefactor * K, 1/scalefactor * K, 1/scalefactor * K)
            randomhue()
            setopacity(0.5)
            pin(object, gfunction= anothergfunction)
            m += 1
        end
    end
    finish()
end

main()

preview()
