"""
    make(primitive)

Eg

    make(Cube)

"""
function make(vf)
    # don't redefine constants when passed an array :)
    vertices = deepcopy(vf[1])
    faces    = deepcopy(vf[2])
    labels   = collect(1:length(faces))
    return Model(vertices, faces, labels)
end

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
    [1, 2, 5],
    [2, 3, 5],
    [3, 4, 5],
    [4, 1, 5]])

const Axes3D = (
    [
Point3D(0.0, 0.1, -0.1),
Point3D(10.0, 0.1, -0.1),
Point3D(10.0, -0.1, -0.1),
Point3D(0.0, -0.1, -0.1),
Point3D(0.0, 0.1, 0.1),
Point3D(10.0, 0.1, 0.1),
Point3D(10.0, -0.1, 0.1),
Point3D(0.0, -0.1, 0.1),
Point3D(0.1, 0.0, -0.1),
Point3D(0.1, 10.0, -0.1),
Point3D(-0.1, 10.0, -0.1),
Point3D(-0.1, 0.0, -0.1),
Point3D(0.1, 0.0, 0.1),
Point3D(0.1, 10.0, 0.1),
Point3D(-0.1, 10.0, 0.1),
Point3D(-0.1, 0.0, 0.1),
Point3D(0.1, -0.1, 0.0),
Point3D(0.1, -0.1, 10.0),
Point3D(-0.1, -0.1, 10.0),
Point3D(-0.1, -0.1, 0.0),
Point3D(0.1, 0.1, 0.0),
Point3D(0.1, 0.1, 10.0),
Point3D(-0.1, 0.1, 10.0),
Point3D(-0.1, 0.1, 0.0)
],
[
[1, 2, 3, 4],
[2, 6, 7, 3],
[6, 5, 8, 7],
[5, 1, 4, 8],
[1, 5, 6, 2],
[4, 3, 7, 8],
#
[9, 10, 11, 12],
[10, 14, 15, 11],
[14, 13, 16, 15],
[13, 9, 12, 16],
[9, 13, 14, 10],
[12, 11, 15, 16],
#
[17, 18, 19, 20],
[18, 22, 23, 19],
[22, 21, 24, 23],
[21, 17, 20, 24],
[17, 21, 22, 18],
[20, 19, 23, 24]
])

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
[
[1, 2, 3, 4]
])
