"""
    sortfaces(m::Model)

Find the averages of the z values of the faces in model, and sort the faces
of m so that the faces are in order of nearest.
"""
function sortfaces!(m::Model)
    avgs = []
    for f in m.faces
        vs = m.vertices[f]
        s = 0
        for v in vs
            s += v.z
        end
        avgz = s/length(vs)
        push!(avgs, avgz)
    end
    neworder = sortperm(avgs)
    m.faces = m.faces[neworder]
    m.labels = m.labels[neworder]
end

function drawmodel(m::Model, prj::Projection, cols=cols, action=:stroke)
    verts, faces = modeltopoly(m, prj)
    @layer begin
        for (n, p) in enumerate(faces)
            x = mod1(n, length(cols))
            c = cols[mod1(m.labels[x], length(cols))]
            sethue(c)
            poly(p, action, close=true)
        end
    end
end
