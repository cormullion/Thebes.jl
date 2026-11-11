using Thebes, Luxor

include(string(pathof(Thebes), "../../../data/evenmoreobjects.jl"))

evenmoreobjects = [:Apple, :Sword01, :asu, :dragon, :goblet,
:head, :heart, :helm, :house, :king, :klingon, :mushroom, :pear, :r2,
:seashell, :space_shuttle, :space_station, :teapot, :volks,
:x29_plane]

function anothergfunction(o; action=:fill)
    sortfaces!(o)
    if !isempty(o.faces)
        @layer begin
            for (n, face) in enumerate(o.faces)
                @layer begin
                    vertices = o.vertices[face]
                    sn = surfacenormal(vertices)
                    ang = anglebetweenvectors(sn, eyepoint())
                    setgrey(rescale(ang, 0, π, 0.5, 1))
                    pin(vertices, gfunction=(p3, p2) -> poly(p2, action))
                    sethue("grey60")
                    pin(vertices, gfunction=(p3, p2) -> poly(p2, :stroke))
                end
            end
        end
    end
end

function main()
    Drawing(1200, 1200, "/tmp/evenmoreobjects.png")
    origin()
    background("grey20")

    axes3D()
    eyepoint(Point3D(500, 500, 500))
    centerpoint(Point3D(0, 0, 0))
    perspective(600)
    setline(2)

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
            setopacity(0.85)
            pin(object, gfunction = anothergfunction)
            m += 1
        end
    end
    finish()
end

main()

preview()
