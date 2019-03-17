using Thebes, Luxor

using ColorSchemes

cols = ColorSchemes.sandyterrain

cols = [Luxor.darker_purple, Luxor.darker_green, Luxor.darker_red]

myrenderfunction(vertices, faces, labels, cols) =
    Thebes.simplerender(vertices, faces, labels, cols, action=:fill)

Drawing(400, 400, "/tmp/test2-pyramids.png")
origin()
background("white")
setopacity(1)

eyepoint    = Point3D(-200, 150, 20)
centerpoint = Point3D(0, 0, 10)
uppoint     = Point3D(0, 0, 20) # relative to centerpoint
projection  = newprojection(eyepoint, centerpoint, uppoint, 500)

#setblend(blend(O, 50, O, 500, cols[1], cols[5]))
#drawcarpet(400, projection, kind=:circular)


# The northernmost and oldest pyramid of the group was built for Khufu (Greek: Cheops), the second king of the 4th dynasty. Called the Great Pyramid, it is the largest of the three, the length of each side at the base averaging 755.75 feet (230 metres) and its original height being 481.4 feet (147 metres).

# The middle pyramid was built for Khafre (Greek: Chephren), the fourth of the eight kings of the 4th dynasty; the structure measures 707.75 feet (216 metres) on each side and was originally 471 feet (143 metres) high.

# The southernmost and last pyramid to be built was that of Menkaure (Greek: Mykerinus), the fifth king of the 4th dynasty; each side measures 356.5 feet (109 metres), and the structure’s completed height was 218 feet (66 metres).

sethue("gold")
drawcarpet(80, projection)

khufu = make(Pyramid)
khafre = make(Pyramid)
menkaure = make(Pyramid)

pyramids = [menkaure, khafre, khufu]

changescale!(khufu,   23.0/2, 23.0/2, 14.7)
changescale!(khafre,  21.6/2, 21.6/2, 14.3)
changescale!(menkaure, 10.9/2, 10.9/2, 6.6)

changeposition!(khufu,     30, 30, 0)
changeposition!(khafre,   -0, -0, 0)
changeposition!(menkaure, -30, -30, 0)

# needs depth sorting of faces

sortfaces!.(pyramids, eyepoint=eyepoint)
drawmodel(menkaure, projection, cols=[cols[3]], renderfunction=myrenderfunction)
drawmodel(khafre, projection, cols=[cols[2]], renderfunction=myrenderfunction)
drawmodel(khufu, projection, cols=[cols[1]], renderfunction=myrenderfunction)
finish()
