"""
    pin(pt::Point3D;
        gfunction = (p3, p2) -> circle(p2, 1, :stroke))

Draw a single 3D point on the current Luxor drawing.

The default graphic is a circle. You can define others using a custom
gfunction, which takes two arguments: the 3D point and its 2D counterpoint.

For example, this draws a circle whose radius is larger if the point is nearer to the eye.

```
pin(p, gfunction = (p3, p2) -> begin
        d = distance(p3, eyepoint())
        circle(p2, rescale(d, 0, 300, 20, 5), :fill)
    end
    )
```

Returns the 2D point.
"""
function pin(p3::Point3D;
        gfunction = (p3, p2) -> circle(p2, 1, :stroke))
    p2 = project(p3)
    if !(p2 == nothing)
        gfunction(p3, p2)
    end
    return p2
end

"""
    pin(p3_1::Point3D, p3_2::Point3D;
        gfunction = ((p3_1, p3_2), (p2_1, p2_2)) ->
            line(p2_1, p2_2, :stroke))

Draw two 3D points.

The default action is to draw a line between two points.

The gfunction can access the 3D points as the first
argument, the two 2D points in the second argument.

```
pin(p, Point3D(50cos(θ), 50sin(θ), p.z),
    gfunction = (p3s, p2s) -> begin
        line(p2s..., :stroke)
    end)

```

Returns the two 2D points.
"""
function pin(p3_1::Point3D, p3_2::Point3D;
        gfunction = ((p3_1, p3_2), (p2_1, p2_2)) ->
            line(p2_1, p2_2, :stroke))
    p2_1, p2_2 = project.([p3_1, p3_2])
    if !(p2_1 == nothing) && !(p2_2 == nothing)
        gfunction((p3_1, p3_2), (p2_1, p2_2))
    end
    return p2_1, p2_2
end

"""
    pin(p3list::Array{Point3D, 1};
        gfunction = (p3list, p2list) ->
            poly(p2list, :stroke, close=true))

Draw an array of 3D points.

The default action is to draw a polygon through all the points.

The gfunction can access the 3D points as the first
argument, the two 2D points in the second argument.

```
helix = [Point3D(100cos(θ), 100sin(θ), 20θ) for θ in 0:π/12:4π]
a_box = pin(helix, gfunction =
    (p3list, p2list) -> prettypoly(p2list, :stroke)
    )
```

Returns the list of 2D points.

"""
function pin(p3list::Array{Point3D, 1};
        gfunction = (p3list, p2list) ->
            poly(p2list, :stroke, close=true))
    p2list = project.(p3list)

    if all(p -> !(p == nothing), p2list)
        gfunction(p3list, p2list)
    else
        for n in eachindex(p2list)
            if p2list[n] == nothing
            else
                gfunction([p3list[n]], [p2list[n]])
            end
        end
    end
    return p2list
end
