using Thebes, Test

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
