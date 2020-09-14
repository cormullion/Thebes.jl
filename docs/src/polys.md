```@meta
DocTestSetup = quote
    using Thebes, Luxor, Colors
    end
```

# Polygons and planes

The `pin()` function accepts an array of 3D points as well. In this case, the default graphical treatment is to apply the `Luxor.poly(... :stroke)` function to the 2D points.

This of course isn't always going to work very well, if the 3D points don't lie in a plane, for example, or if you decide to use filling rather than stroking actions.

## Möbius

```@example
using Thebes, Luxor # hide

function makemobius()
    x(u, v) = (1 + (v/2 * cos(u/2))) * cos(u)
    y(u, v) = (1 + (v/2 * cos(u/2))) * sin(u)
    z(u, v) = v/2 * sin(u/2)
    w = .5
    st = 2π/200
    Δ = .05
    result = Array{Point3D, 1}[]
    for u in 0:st:2π-st
        for v in -w:Δ:w
            p1 = Point3D(x(u,      v + Δ),   y(u,      v + Δ),     z(u,       v + Δ))
            p2 = Point3D(x(u + st, v + Δ),   y(u + st, v + Δ),     z(u  + st, v + Δ))
            p3 = Point3D(x(u + st, v),       y(u + st, v),         z(u + st,  v))
            p4 = Point3D(x(u,      v),       y(u,      v),         z(u,       v))
            push!(result, [p1, p2, p3, p4])
        end
    end
    return result
end

# ... in a drawing
Drawing(600, 600, "assets/figures/mobiusband.svg") # hide
origin() # hide
background("black") # hide
setline(0.5) # hide
eyepoint(300, 300, 300)
perspective(1200)
mb = makemobius()
setopacity(1)
sethue("white")
for p in mb
    pin(100p, gfunction  = (p3l, p2l) -> begin
        poly(p2l, :stroke, close=true)
    end)
end
finish() # hide
nothing # hide
```

![mobius band](assets/figures/mobiusband.svg)


## Chessboard

You can probably risk filling a set of 3D points if they lie in the same plane.

Here's a simple example. The gfunction here:

```
pin(plist,
    gfunction = (p3, p2) -> begin
        poly(p2, close=true, :fillpreserve)
        sethue("black")
        strokepath()
    end)
```

simply fills the polygon with the current color, then outlines it in black.

```@example
using Thebes, Luxor # hide
Drawing(600, 300, "assets/figures/chessboard.svg") # hide
background("white") # hide
origin() # hide
sethue("blue") # hide
helloworld() # hide

perspective(1200)
eyepoint(500, 500, 150)
k = 20
w, h = 20, 20
for x in 1:8
    for y in 1:8
        iseven(x + y) ? sethue("grey90") : sethue("grey10")
        z = 0
        plist = [
            Point3D(k * x,     k * y,      z),
            Point3D(k * x + w, k * y,      z),
            Point3D(k * x + w, k * y + h,  z),
            Point3D(k * x,     k * y + h,  z)
            ]
        pts = pin(plist, gfunction = (p3, p2) -> begin
                poly(p2, close=true, :fillpreserve)
                sethue("black")
                strokepath()
            end)
    end
end

finish() # hide
nothing # hide
```

![chess board example](assets/figures/chessboard.svg)

The polygon is constructed in `plist` and then `pin()` applies its gfunction on it.

## Surfaces

A surface plot like the following also works quite well. It's just that each new polygon hides the ones behind it.

```@example
using Thebes, Luxor, Colors # hide
Drawing(600, 500, "assets/figures/surfaceplot.svg") # hide
background("white") # hide
origin() # hide
sethue("blue") # hide
helloworld() # hide

perspective(600)
eyepoint(500, 500, 500)

k = 20
xmax = 4π
ymax = 4π
st = 0.5

f(x, y) = 2(sin(x) * cos(y)) + (cos(x) * sin(y))

setline(.5)

for x in -xmax:st:xmax
    for y in -ymax:st:ymax
        sethue(HSB(360rescale(x, -xmax, xmax), .8, .8))

        p1 = Point3D(k * x,         k * y,        k * f(x,      y))
        p2 = Point3D(k * x,         k * (y + st), k * f(x,      y +st))
        p3 = Point3D(k * (x + st),  k * (y + st), k * f(x + st, y + st))
        p4 = Point3D(k * (x + st),  k * y,        k * f(x + st, y))
        pin([p1, p2, p3, p4], gfunction = (p3s, p2s) -> begin
            poly(p2s, close=true, :fill)
            sethue("white")
            poly(p2s, close=true, :stroke)
        end)
    end
end

axes3D(200)

finish() # hide
nothing # hide
```

![surface plot example](assets/figures/surfaceplot.svg)
