cs = Procedural.CircleShape()
ms = Procedural.MultiShape()
ms:addShape(cs:setRadius(2):realizeShape())
ms:addShape(cs:setRadius(.3):realizeShape():translate(-1,.3):switchSide())
ms:addShape(cs:realizeShape():translate(1,.3):switchSide())
ms:addShape(cs:realizeShape():switchSide())
ms:addShape(cs:realizeShape():scale(2,1):translate(0,-1):switchSide())
Procedural.Triangulator():setMultiShapeToTriangulate(ms):realizeMesh("test")
tests:addMesh("test")