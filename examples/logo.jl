using Thebes, Luxor

include(dirname(pathof(Thebes)) * "/../data/moreobjects.jl")

function main()
    eyepoint(0, 100, 300)
    perspective(300)
    Drawing(500, 500, "docs/src/assets/logo.svg")
    origin()
    squircle(O, 240, 240, :clip, rt=0.3)
    background("midnightblue")

    sethue(0.0, 0.3, 0.5)
    circle(O + (0, 850), 800, :fill)

    object = make(rhombitruncated_icosidodecahedron, "solid")
    scaleby!(object, 180, 180, 180)
    rotateby!(object, π/3, 0, 0)
    sortfaces!(object, eyepoint=eyepoint())
    pin(object, gfunction = (args...) -> begin
        vertices, faces, labels = args
        cols = (Luxor.julia_green, Luxor.julia_red,Luxor.julia_purple, Luxor.julia_blue)
        setlinejoin("bevel")
        if !isempty(faces)
            @layer begin
                for (n, p) in enumerate(faces)
                    setopacity(0.8)
                    sethue(cols[mod1(n, end)])
                    poly(p, :fillpreserve, close=true)
                    setline(6)
                    sethue("gold")
                    strokepreserve()
                    setline(2)
                    sethue("black")
                    strokepreserve()
                    setline(1)
                    sethue("white")
                    strokepath()
                end
            end
        end
    end)
    finish()
    preview()
end

main()
