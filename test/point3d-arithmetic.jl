using Thebes, Test, Luxor

p1 = Point3D(0, 0, 0)
p2 = Point3D(10, 10, 10)
p3 = Point3D(20, 20, 20)

@test p1 < p2
@test p3 > p2

@test distance(p1, p2) ≈ 17.320508075688775
@test distance(p1, p3) ≈  34.64101615137755

@test between(p1, p2, 2.0) ≈ Point3D(20.0, 20.0, 20.0)
@test between(p1, p2, 1.0) ≈ Point3D(10.0, 10.0, 10.0)
@test between(p1, p2, 0.0) ≈ Point3D(0.0, 0.0, 0.0)

@test midpoint(p1, p2) ≈ Point3D(5.0, 5.0, 5.0)
@test midpoint(p1, p3) ≈ Point3D(10.0, 10.0, 10.0)
@test midpoint(p2, p3) ≈ Point3D(15.0, 15.0, 15.0)
@test midpoint(Point3D(0, 0, 0), Point3D(10, 0, 0)) ≈ Point3D(5.0, 0.0, 0.0)
@test midpoint(Point3D(0, 0, 0), Point3D(0, 10, 0)) ≈ Point3D(0.0, 5.0, 0.0)
@test midpoint(Point3D(0, 0, 0), Point3D(0, 0, 10)) ≈ Point3D(0.0, 0.0, 5.0)

Drawing(1, 1, :png)
@test pin(Point3D(1000, 1000, 1000)) == nothing

pt = pin(Point3D(-1000, -1000, -1000))
@test isapprox(pt.x, 0)
@test isapprox(pt.y, 0)

# test spherical ↔ cartesian

(ρ, θ, ϕ) = cartesiantospherical(2.0, 3.0, 4.0)

@test ρ ≈ 5.385164807134504
@test θ ≈ 0.982793723247329
@test ϕ ≈ 0.7335813236400831

(x, y, z) = sphericaltocartesian((ρ, θ, ϕ))

@test isapprox(x, 2.0, atol=10e-3)
@test isapprox(y, 3.0, atol=10e-3)
@test isapprox(z, 4.0, atol=10e-3)

(ρ₁, θ₁, ϕ₁) = cartesiantospherical(x, y, z)

# round trip
@test isapprox(ρ₁, ρ)
@test isapprox(θ₁, θ)
@test isapprox(ϕ₁, ϕ)

finish()
