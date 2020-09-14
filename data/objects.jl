# just the basics, Cube, Tetrahedron, Pyramid, AxesWire, Carpet

const Cube = (
   [
    Point3D(-0.5,  0.5, -0.5),
    Point3D(0.5,   0.5, -0.5),
    Point3D(0.5,  -0.5, -0.5),
    Point3D(-0.5, -0.5, -0.5),
    Point3D(-0.5,  0.5,  0.5),
    Point3D(0.5,   0.5,  0.5),
    Point3D(0.5,  -0.5,  0.5),
    Point3D(-0.5, -0.5,  0.5)
    ],
   [[1, 2, 3, 4],
    [2, 6, 7, 3],
    [6, 5, 8, 7],
    [5, 1, 4, 8],
    [1, 5, 6, 2],
    [4, 3, 7, 8]])

const Tetrahedron = (
    [
    Point3D(1, 1, 1),
    Point3D(-1, -1, 1),
    Point3D(-1, 1, -1),
    Point3D(1, -1, -1)
    ],
   [[1, 2, 3],
    [1, 2, 4],
    [2, 3, 4],
    [4, 1, 3]])

const Pyramid = ([
    Point3D(-1, -1, 0),
    Point3D(1, -1, 0),
    Point3D(1, 1, 0),
    Point3D(-1, 1, 0),
    Point3D(0, 0, 1)],
   [[1, 2, 3, 4],
    [1, 5, 2],
    [2, 5, 3],
    [3, 5, 4],
    [4, 5, 1]])

const AxesWire = (
    [
    Point3D(0.0, 0.0, 0.0),
    Point3D(10.0, 0.0, 0.0),
    Point3D(0.0, 0.0, 0.0),
    Point3D(0.0, 10.0, 0.0),
    Point3D(0.0, 0.0, 0.0),
    Point3D(0.0, 0.0, 10.0),
    Point3D(0.0, 0.0, 0.0)
    ], [])

const Carpet = (
    [
    Point3D(-10.0, -10.0, 0.0),
    Point3D(-10.0, 10.0, 0.0),
    Point3D(10.0, 10.0, 0.0),
    Point3D(10.0, -10.0, 0.0)
    ],
    [[1, 2, 3, 4]])
