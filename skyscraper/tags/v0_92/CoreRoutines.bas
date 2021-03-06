Attribute VB_Name = "CoreRoutines"
'Skycraper 0.92 Beta
'Copyright (C) 2003 Ryan Thoryk
'http://www.tliquest.net/skyscraper
'http://sourceforge.net/projects/skyscraper
'Contact - ryan@tliquest.net

'This program is free software; you can redistribute it and/or
'modify it under the terms of the GNU General Public License
'as published by the Free Software Foundation; either version 2
'of the License, or (at your option) any later version.

'This program is distributed in the hope that it will be useful,
'but WITHOUT ANY WARRANTY; without even the implied warranty of
'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'GNU General Public License for more details.

'You should have received a copy of the GNU General Public License
'along with this program; if not, write to the Free Software
'Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

'2/15/03 - Code amount - 79 pages
'3/1/03 - Code amount - 129 pages
'4/26/03 - Code amount - 280 pages

'Building title - "The Triton Center"
'
Option Explicit


Global TV As TVEngine
Global Scene As TVScene
Global Mesh As TVMesh
Global External As TVMesh
Global Landscape As TVMesh
Global Room(138) As TVMesh
Global Shafts1(138) As TVMesh
Global Shafts2(138) As TVMesh
Global Shafts3(138) As TVMesh
Global Shafts4(138) As TVMesh
Global ShaftsFloor(138) As TVMesh
Global Buttons(-1 To 144) As TVMesh
'Global Elevator1 As TVMesh
Global Elevator(40) As TVMesh '-update from Elevator1
'Global FloorIndicator1 As TVMesh
Global FloorIndicator(40) As TVMesh '-update from FloorIndicator1
'Global Elevator1DoorL As TVMesh
'Global Elevator1DoorR As TVMesh
Global ElevatorInsDoorL(40) As TVMesh '-update from Elevator1DoorL
Global ElevatorInsDoorR(40) As TVMesh '-update
'Global ElevatorDoorL(-1 To 138) As TVMesh
'Global ElevatorDoorR(-1 To 138) As TVMesh
Global ElevatorDoorL(40) As TVMesh
Global ElevatorDoorR(40) As TVMesh
Global Stairs(138) As TVMesh
Global CallButtons(40) As TVMesh
Global StairDoor(-1 To 138) As TVMesh
Global Light As TVLightEngine
Global MatFactory As New TVMaterialFactory
Global LightID As Integer
Global LightD As D3DLIGHT8
'Global Plaque As TVMesh
Global Plaque(40) As TVMesh '-update

Global SoundEngine As TVSoundEngine
'Global ElevatorMusic As TVSoundWave3D
Global ElevatorMusic(40) As TVSoundWave3D '-update
'Global Elevator1Sounds As TVSoundWave3D
Global ElevatorSounds(40) As TVSoundWave3D '-update from Elevator1Sounds
Global Listener As TVListener
Global ListenerDirection As D3DVECTOR
'Global MousePositionX As Long
'Global MousePositionY As Long
Global Focused As Boolean
Global LineTest As D3DVECTOR
Global LineTest2 As D3DVECTOR
Global KeepAltitude As Integer
'Global ElevatorSync As Boolean
Global ElevatorSync(40) As Boolean '-update

Global Atmos As New TVAtmosphere
Global sngPositionX As Single
Global sngPositionY As Single
Global sngPositionZ As Single
Global snglookatX As Single
Global snglookatY As Single
Global snglookatZ As Single
Global sngAngleX As Single
Global sngAngleY As Single
Global sngWalk As Single
Global sngStrafe As Single

Global Inp As TVInputEngine
Global TextureFactory As TVTextureFactory
Global linestart As D3DVECTOR
Global lineend As D3DVECTOR
'Global elevator1start As D3DVECTOR
Global elevatorstart(40) As D3DVECTOR '-update from elevator1start
Global isRunning As Boolean
Global Camera As TVCamera
Global ColRes As TV_COLLISIONRESULT
Global i As Single
Global i50 As Single
Global i51 As Single
Global i52 As Single
Global i53 As Single
Global i54 As Single
Global j As Single
Global j50 As Single
'Global ElevatorEnable As Single
Global ElevatorEnable(40) As Single '-update
'Global ElevatorDirection As Integer '1=up -1=down
Global ElevatorDirection(40) As Integer '1=up -1=down UPDATE
Global OpenElevatorLoc(40) As Single
Global ElevatorCheck(40) As Integer
Global ElevatorCheck2(40) As Integer
Global ElevatorCheck3(40) As Integer
Global ElevatorCheck4(40) As Integer
Global X As Integer
Global CollisionResult As TVCollisionResult

'Global GotoFloor As Single
Global GotoFloor(40) As Single '-update
Global CurrentFloor(40) As Integer
Global CurrentFloorExact(40) As Single
Global DistanceToTravel(40) As Single
Global Destination(40) As Single
Global OriginalLocation(40) As Single
Global StoppingDistance(40) As Single
Global FineTune(40) As Boolean
'Global OpenElevator As Integer '1=open -1=close
Global OpenElevator(40) As Integer '1=open -1=close UPDATE
'Global ElevatorFloor As Integer
Global ElevatorFloor(40) As Integer 'update
Global CameraFloor As Integer
Global CameraFloorExact As Single
Global PartialFloor As Single
Global InStairwell As Boolean
'Global FloorIndicator As String
Global FloorIndicatorText(40) As String 'update
Global ElevatorFloor2(40) As Integer
Global CameraFloor2 As Integer
Global FloorIndicatorPic(40) As String
Global FloorIndicatorPicOld(40) As String
'3D Objects
Global Objects(150 * 138) As TVMesh
Global Buildings As TVMesh
Global FileName As String
Global OpeningDoor As Integer
Global ClosingDoor As Integer
Global DoorNumber As Integer
Global DoorRotated As Integer
Global ElevatorNumber As Integer
Declare Function GetCursorPos Lib "user32" (lpPoint As POINTAPI) As Long
Declare Sub Sleep Lib "kernel32.dll" (ByVal dwMilliseconds As Long)
Declare Function GetTickCount Lib "kernel32.dll" () As Long

Global Test1 As Boolean
Global FloorEnabled(138) As Boolean
Global InElevator As Boolean

Global tmpMouseX As Long, tmpMouseY As Long, tmpMouseB1 As Integer
Global EnableCollisions As Boolean
Global Gravity As Single
Global IsFalling As Boolean
Global lngOldTick As Long
Global FallRate As Single
Global CameraOriginalPos As Single

Global ElevTemp(40) As Single
Global ButtonsEnabled As Boolean
Global FloorHeight As Integer
Global ElevatorSpeed As Single
Global ElevatorFineTuneSpeed As Single
Global CallingStairDoors As Boolean

Sub InitRealtime(FloorID As Integer)

'Destroy meshes
For i54 = 1 To 40
CallButtons(i54).Enable False
'ElevatorDoorL(i54).Enable False
'ElevatorDoorR(i54).Enable False
Scene.DestroyMesh CallButtons(i54)
Scene.DestroyMesh ElevatorDoorL(i54)
Scene.DestroyMesh ElevatorDoorR(i54)
Set CallButtons(i54) = Nothing
Set ElevatorDoorL(i54) = Nothing
Set ElevatorDoorR(i54) = Nothing
'Sleep 10
Next i54

'Sleep 100

'Create blank meshes
For i54 = 1 To 40
Set ElevatorDoorL(i54) = New TVMesh
Set ElevatorDoorR(i54) = New TVMesh
Set CallButtons(i54) = New TVMesh
Set ElevatorDoorL(i54) = Scene.CreateMeshBuilder("ElevatorDoorL" + Str$(i54))
Set ElevatorDoorR(i54) = Scene.CreateMeshBuilder("ElevatorDoorR" + Str$(i54))
Set CallButtons(i54) = Scene.CreateMeshBuilder("CallButtons" + Str$(i54))
Next i54

'Generate objects for floors


If FloorID = 1 Then
Call ProcessRealtime(FloorID, 5, 1, True, False, True, True, True, True, False, False, False, False, False, False)
Call ProcessRealtime(FloorID, 5, 2, True, False, True, True, True, True, False, False, False, False, False, False)
Call ProcessRealtime(FloorID, 1, 3, True, False, True, True, True, True, True, True, True, True, True, True)
Call ProcessRealtime(FloorID, 1, 4, True, False, True, True, True, True, True, True, True, True, True, True)
End If

If FloorID = 2 Or FloorID = 39 Then
Call ProcessRealtime(FloorID, 5, 1, True, False, True, False, False, False, False, False, False, False, False, False)
Call ProcessRealtime(FloorID, 5, 2, True, False, True, False, False, False, False, False, False, False, False, False)
Call ProcessRealtime(FloorID, 2, 3, True, False, False, False, False, False, False, False, False, False, False, False)
Call ProcessRealtime(FloorID, 2, 4, True, False, True, True, True, True, True, True, True, True, True, True)
End If
If FloorID > 2 And FloorID < 39 Then
Call ProcessRealtime(FloorID, 5, 1, True, False, False, False, False, False, False, False, False, False, False, False)
Call ProcessRealtime(FloorID, 5, 2, True, False, True, False, False, False, False, False, False, False, False, False)
Call ProcessRealtime(FloorID, 2, 3, True, False, False, False, False, False, False, False, False, False, False, False)
Call ProcessRealtime(FloorID, 2, 4, True, False, True, True, True, True, True, True, True, True, True, True)
End If

If FloorID = 40 Or FloorID = 79 Then
Call ProcessRealtime(FloorID, 5, 1, True, False, True, False, False, False, False, False, False, False, False, False)
Call ProcessRealtime(FloorID, 2, 3, False, False, True, True, True, True, True, True, True, True, True, True)
End If
If FloorID > 40 And FloorID < 79 Then
Call ProcessRealtime(FloorID, 5, 1, True, False, False, False, False, False, False, False, False, False, False, False)
Call ProcessRealtime(FloorID, 2, 3, False, False, True, True, True, True, True, True, True, True, True, True)
End If
If FloorID >= 40 And FloorID <= 51 Then
Call ProcessRealtime(FloorID, 5, 2, True, False, True, False, False, False, False, False, False, False, False, False)
End If
If FloorID <= 79 And FloorID > 51 Then
Call ProcessRealtime(FloorID, 5, 2, True, False, False, True, False, False, False, False, False, False, False, False)
End If
       
If FloorID >= 82 And FloorID <= 98 Then
Call ProcessRealtime(FloorID, 2, 1, True, False, False, False, False, False, False, False, False, False, False, False)
Call ProcessRealtime(FloorID, 2, 2, True, False, False, True, False, False, True, True, True, True, True, True)
End If
If FloorID >= 102 And FloorID < 114 Then
Call ProcessRealtime(FloorID, 2, 1, True, False, True, False, False, False, True, True, True, True, True, True)
Call ProcessRealtime(FloorID, 2, 2, True, False, False, False, False, False, False, False, False, False, False, False)
End If
If FloorID = 81 Or FloorID = 99 Then
Call ProcessRealtime(FloorID, 2, 1, True, False, False, False, False, False, False, False, False, False, False, False)
Call ProcessRealtime(FloorID, 2, 2, True, False, False, True, False, False, True, True, True, True, True, True)
End If
If FloorID = 100 Then
Call ProcessRealtime(FloorID, 2, 1, True, False, False, False, False, False, True, True, True, True, True, True)
Call ProcessRealtime(FloorID, 2, 2, True, False, False, True, False, False, False, False, False, False, False, False)
End If
If FloorID = 114 Then
Call ProcessRealtime(FloorID, 2, 1, True, False, True, False, False, False, True, True, True, True, True, True)
Call ProcessRealtime(FloorID, 2, 2, True, False, False, False, False, False, False, False, False, False, False, False)
End If
If FloorID = 101 Then
Call ProcessRealtime(FloorID, 2, 1, True, False, True, False, False, False, True, True, True, True, True, True)
Call ProcessRealtime(FloorID, 2, 2, True, False, False, True, False, False, False, False, False, False, False, False)
End If
 
If FloorID >= 118 And FloorID <= 129 Then
Call ProcessRealtime(FloorID, 2, 1, False, True, True, False, False, False, True, True, True, True, True, True)
End If

If FloorID = 80 Then
Call ProcessRealtime(FloorID, 2, 1, True, False, True, True, True, True, True, True, True, True, True, True)
Call ProcessRealtime(FloorID, 2, 2, True, False, True, True, True, True, True, True, True, True, True, True)
End If

If FloorID = 115 Then
Call ProcessRealtime(FloorID, 2, 1, True, False, True, False, False, False, False, False, False, False, False, False)
Call ProcessRealtime(FloorID, 2, 2, True, False, True, True, False, False, False, False, False, False, False, False)
End If

If FloorID = 116 Then
Call ProcessRealtime(FloorID, 2, 1, True, False, True, False, False, False, False, False, False, False, False, False)
Call ProcessRealtime(FloorID, 2, 2, True, False, True, True, False, False, False, False, False, False, False, False)
End If

If FloorID = 117 Then
Call ProcessRealtime(FloorID, 2, 1, True, False, True, False, False, False, False, False, False, False, False, False)
Call ProcessRealtime(FloorID, 2, 2, True, False, True, True, False, False, False, False, False, False, False, False)
End If

If FloorID = 130 Then Call ProcessRealtime(FloorID, 5, 1, False, False, True, False, False, False, False, False, False, False, False, False)
If FloorID = 131 Then Call ProcessRealtime(FloorID, 5, 1, False, False, True, False, False, False, False, False, False, False, False, False)
If FloorID = 132 Then Call ProcessRealtime(FloorID, 5, 1, False, False, True, True, True, True, False, False, False, False, False, False)
If FloorID = 133 Then Call ProcessRealtime(FloorID, 5, 1, False, False, True, False, False, False, False, False, False, False, False, False)
If FloorID = 134 Then Call ProcessRealtime(FloorID, 5, 1, False, False, True, True, True, True, False, False, False, False, False, False)
If FloorID = 135 Then Call ProcessRealtime(FloorID, 5, 1, False, False, True, True, True, True, False, False, False, False, False, False)
If FloorID = 136 Then Call ProcessRealtime(FloorID, 5, 1, False, False, True, True, True, True, False, False, False, False, False, False)
If FloorID = 137 Then Call ProcessRealtime(FloorID, 7, 1, False, False, True, False, False, False, False, False, False, False, False, False)
If FloorID = 138 Then Call ProcessRealtime(FloorID, 7, 1, False, False, True, False, False, False, False, False, False, False, False, False)

End Sub

Sub Init_Simulator()
'On Error GoTo ErrorHandler
isRunning = True
EnableCollisions = True
Form2.Show
Form1.Show
Set TV = New TVEngine
Set Scene = New TVScene
Set Mesh = New TVMesh
Set Buildings = New TVMesh
Set External = New TVMesh
Set Landscape = New TVMesh
For i = 1 To 138
DoEvents
Set Room(i) = New TVMesh
Set Stairs(i) = New TVMesh
Set ShaftsFloor(i) = New TVMesh
Set Shafts1(i) = New TVMesh
Set Shafts2(i) = New TVMesh
Set Shafts3(i) = New TVMesh
Set Shafts4(i) = New TVMesh
Next i

For i = -1 To 138
Set StairDoor(i) = New TVMesh
Next i

For i = 1 To 40
Set Elevator(i) = New TVMesh
Set FloorIndicator(i) = New TVMesh
Set ElevatorInsDoorL(i) = New TVMesh
Set ElevatorInsDoorR(i) = New TVMesh
'Set ElevatorMusic(i) = New TV3DMedia.TVSoundWave3D
Set ElevatorSounds(i) = New TV3DMedia.TVSoundWave3D
Set Plaque(i) = New TVMesh
Set CallButtons(i) = New TVMesh
Next i

Set Camera = New TVCamera

Set TextureFactory = New TVTextureFactory
Set SoundEngine = New TV3DMedia.TVSoundEngine
Set Light = New TVLightEngine

If TV.ShowDriverDialog = False Then End
  
Form1.Label1.Caption = "Skyscraper 0.92 Beta - Build" + Str$(App.Revision) + vbCrLf
Form1.Label1.Caption = Form1.Label1.Caption + "�2003 Ryan Thoryk" + vbCrLf
Form1.Label1.Caption = Form1.Label1.Caption + "Compiled on April 26, 2003" + vbCrLf + vbCrLf
Form1.Label1.Caption = Form1.Label1.Caption + "Skyscraper comes with ABSOLUTELY NO WARRANTY. This is free" + vbCrLf
Form1.Label1.Caption = Form1.Label1.Caption + "software, and you are welcome to redistribute it under certain" + vbCrLf
Form1.Label1.Caption = Form1.Label1.Caption + "conditions. For details, see the file gpl.txt" + vbCrLf
Form1.Label1.Caption = Form1.Label1.Caption + "Build number counting has been done since version 0.7" + vbCrLf

DoEvents
   
Sleep 2000
   '2. Initialize the engine with the selected mode
    TV.SetSearchDirectory App.Path
Form1.Label2.Caption = "Initializing TrueVision3D..."
   'TV.Initialize Form1.hWnd
    TV.Init3DWindowedMode Form1.hWnd
    'TV.Init3DFullscreen 640, 480, 16

  Set Inp = New TVInputEngine
  TV.SetSearchDirectory App.Path
  TV.DisplayFPS = True
  
  'TV.MultiSampleTp = TV3D_MULTISAMPLE_16_SAMPLES
  'TV.EnableAntialising True
    
  Scene.SetTextureFilter (TV_FILTER_ANISOTROPIC)
  'Scene.SetDithering True
  TV.EnableAntialising True
  
  Scene.LoadCursor "pointer.bmp", TV_COLORKEY_BLACK, 14, 16
  
  Set Mesh = Scene.CreateMeshBuilder("Mesh")
  Form1.Label2.Caption = "Processing Meshes..."
  For i = 1 To 138
  DoEvents
  Set Room(i) = Scene.CreateMeshBuilder("Room " + Str$(i))
  Set Stairs(i) = Scene.CreateMeshBuilder("Stairs " + Str$(i))
  Set ShaftsFloor(i) = Scene.CreateMeshBuilder("ShaftsFloor " + Str$(i))
  Set Shafts1(i) = Scene.CreateMeshBuilder("Shafts1 " + Str$(i))
  Set Shafts2(i) = Scene.CreateMeshBuilder("Shafts2 " + Str$(i))
  Set Shafts3(i) = Scene.CreateMeshBuilder("Shafts3 " + Str$(i))
  Set Shafts4(i) = Scene.CreateMeshBuilder("Shafts4 " + Str$(i))
  Next i
  
  For i = -1 To 138
    Set StairDoor(i) = Scene.CreateMeshBuilder("StairDoor " + Str$(i))
  Next i
  
  For i = 1 To 40
  DoEvents
  Set Elevator(i) = Scene.CreateMeshBuilder("Elevator" + Str$(i))
  Set FloorIndicator(i) = Scene.CreateMeshBuilder("FloorIndicator" + Str$(i))
  Set ElevatorInsDoorL(i) = Scene.CreateMeshBuilder("ElevatorInsDoorL" + Str$(i))
  Set ElevatorInsDoorR(i) = Scene.CreateMeshBuilder("ElevatorInsDoorR" + Str$(i))
  Set Plaque(i) = Scene.CreateMeshBuilder("Plaque" + Str$(i))
  Set CallButtons(i) = Scene.CreateMeshBuilder("CallButtons" + Str$(i))
  Next i
  Set Buildings = Scene.CreateMeshBuilder("Buildings")
  Set External = Scene.CreateMeshBuilder("External")
  Set Landscape = Scene.CreateMeshBuilder("Landscape")
    
  DoEvents
  Form1.Label2.Caption = "Loading Textures..."
  Scene.SetViewFrustum 90, 200000
  'TextureFactory.LoadTexture "..\..\..\media\stone_wall.jpg", "Floor"
  
  TextureFactory.LoadTexture "brick1.jpg", "BrickTexture"
  TextureFactory.LoadTexture "LobbyFront.jpg", "LobbyFront"
  TextureFactory.LoadTexture "windows11c.jpg", "MainWindows"
  TextureFactory.LoadTexture "granite.jpg", "Granite"
  'TextureFactory.LoadTexture "marbl3.jpg", "Marble3"
  'TextureFactory.LoadTexture "text12.jpg", "Marble3"
  TextureFactory.LoadTexture "symb5.jpg", "Marble3"
  TextureFactory.LoadTexture "marb047.jpg", "Marble4"
  TextureFactory.LoadTexture "elev1.jpg", "Elev1"
  TextureFactory.LoadTexture "textur15.jpg", "Wood1"
  TextureFactory.LoadTexture "text16.jpg", "Wood2"
  'TextureFactory.LoadTexture "text12.jpg", "Wall1"
  TextureFactory.LoadTexture "marbl3.jpg", "Wall1"
  TextureFactory.LoadTexture "marb123.jpg", "Wall2"
  'TextureFactory.LoadTexture "marbl3.jpg", "Wall2"
  'TextureFactory.LoadTexture "marb056.jpg", "Wall3"
  TextureFactory.LoadTexture "cutston.jpg", "Ceiling1"
  TextureFactory.LoadTexture "text12.jpg", "Wall3"
  TextureFactory.LoadTexture "text16.jpg", "ElevDoors"
  TextureFactory.LoadTexture "marb148.jpg", "ElevExtPanels"
  TextureFactory.LoadTexture "mason01.jpg", "Concrete"
  TextureFactory.LoadTexture "text13.jpg", "Stairs"
  TextureFactory.LoadTexture App.Path + "\data\wooddoor3.jpg", "Door1"
  TextureFactory.LoadTexture App.Path + "\data\wooddoor1.jpg", "Door2"
  TextureFactory.LoadTexture App.Path + "\data\servicedoor2.jpg", "StairsDoor"
  TextureFactory.LoadTexture App.Path + "\data\miscdoor8.jpg", "StairsDoor2"
  TextureFactory.LoadTexture App.Path + "\data\button1.jpg", "CallButtonsTex"
  TextureFactory.LoadTexture App.Path + "\data\sidewalk1r.jpg", "Road1"
  TextureFactory.LoadTexture App.Path + "\data\walkway.jpg", "Walkway"
  TextureFactory.LoadTexture App.Path + "\data\sidewalkcorner1.jpg", "Road2"
  TextureFactory.LoadTexture App.Path + "\data\sidewalkcorner2.jpg", "Road3"
  TextureFactory.LoadTexture App.Path + "\data\sidewalkcorner3.jpg", "Road4"
  TextureFactory.LoadTexture App.Path + "\data\roadfull.jpg", "Road5"
  TextureFactory.LoadTexture "windows08.jpg", "Windows8"
  TextureFactory.LoadTexture "windows11.jpg", "Windows11"
  TextureFactory.LoadTexture App.Path + "\data\downtown.jpg", "Downtown"
  TextureFactory.LoadTexture App.Path + "\data\suburbs.jpg", "Suburbs"
      
  TextureFactory.LoadTexture "top.jpg", "SkyTop"
  TextureFactory.LoadTexture "bottom.jpg", "SkyBottom"
  TextureFactory.LoadTexture "left.jpg", "SkyLeft"
  TextureFactory.LoadTexture "right.jpg", "SkyRight"
  TextureFactory.LoadTexture "front.jpg", "SkyFront"
  TextureFactory.LoadTexture "back.jpg", "SkyBack"
  TextureFactory.LoadTexture App.Path + "\objects\benedeti.jpg", "ColumnTex", , , TV_COLORKEY_NO
  TextureFactory.LoadTexture App.Path + "\data\plaque.jpg", "Plaque"
  TextureFactory.LoadTexture App.Path + "\data\floorsign.jpg", "FloorSign"
  TextureFactory.LoadTexture App.Path + "\data\floorsignballroom.jpg", "FloorSignBallroom"
  TextureFactory.LoadTexture App.Path + "\data\floorsignbalcony.jpg", "FloorSignBalcony"
  TextureFactory.LoadTexture App.Path + "\data\floorsignhotel.jpg", "FloorSignHotel"
  TextureFactory.LoadTexture App.Path + "\data\floorsignlobby.jpg", "FloorSignLobby"
  TextureFactory.LoadTexture App.Path + "\data\floorsignmaint.jpg", "FloorSignMaint"
  TextureFactory.LoadTexture App.Path + "\data\floorsignmez.jpg", "FloorSignMez"
  TextureFactory.LoadTexture App.Path + "\data\floorsignmechanical.jpg", "FloorSignMechanical"
  TextureFactory.LoadTexture App.Path + "\data\floorsignobservatory.jpg", "FloorSignObservatory"
  TextureFactory.LoadTexture App.Path + "\data\floorsignoffices.jpg", "FloorSignOffices"
  TextureFactory.LoadTexture App.Path + "\data\floorsignpool.jpg", "FloorSignPool"
  TextureFactory.LoadTexture App.Path + "\data\floorsignresidential.jpg", "FloorSignResidential"
  TextureFactory.LoadTexture App.Path + "\data\floorsignroof.jpg", "FloorSignRoof"
  TextureFactory.LoadTexture App.Path + "\data\floorsignskylobby.jpg", "FloorSignSkylobby"
  
  'loads all the floor indicator/button pictures
  TextureFactory.LoadTexture App.Path + "\data\floorindicators\L.jpg", "ButtonL"
  TextureFactory.LoadTexture App.Path + "\data\floorindicators\M.jpg", "ButtonM"
  TextureFactory.LoadTexture App.Path + "\data\floorindicators\R.jpg", "ButtonR"
  TextureFactory.LoadTexture App.Path + "\data\floorindicators\open.jpg", "ButtonOpen"
  TextureFactory.LoadTexture App.Path + "\data\floorindicators\close.jpg", "ButtonClose"
  TextureFactory.LoadTexture App.Path + "\data\floorindicators\stop.jpg", "ButtonStop"
  TextureFactory.LoadTexture App.Path + "\data\floorindicators\alarm.jpg", "ButtonAlarm"
  TextureFactory.LoadTexture App.Path + "\data\floorindicators\cancel.jpg", "ButtonCancel"
  For i = 2 To 138
  DoEvents
  TextureFactory.LoadTexture App.Path + "\data\floorindicators\" + Mid$(Str$(i), 2) + ".jpg", "Button" + Mid$(Str$(i), 2)
  Next i

   
  'Sound System
    
    Call SoundEngine.Init(Form1.hWnd)
    
    'Load the file into the classes.
    'ElevatorMusic.Load App.Path + "\elevmusic3.wav"
    'ElevatorMusic.Load App.Path + "\elevmusic2.wav"
    'Set sound properties.
    'ElevatorMusic.Volume = -300
    'ElevatorMusic.maxDistance = 1000
    'Call ElevatorMusic.SetConeOrientation(0, 0, 90)
    'ElevatorMusic.ConeOutsideVolume = -300
    'Call ElevatorMusic.SetPosition(-20.25, 20, -23)
    'Call ElevatorMusic.SetPosition(0, 10, 0)
    'Setup the 3D listener.
    'Set Listener = SoundEngine.Get3DListener
    'Call Listener.SetPosition(picDraw.ScaleWidth / 2, 0, picDraw.ScaleHeight / 2)
    'Call Listener.SetPosition(0, 0, 0)
    'Listener.rolloffFactor = 0.1
    'Listener.distanceFactor = 50
DoEvents
  
End Sub





Sub CheckCollisions()
 'Main collision code
LineTest = lineend
 
 If lineend.X > linestart.X Then LineTest.X = lineend.X + 2
 If lineend.X < linestart.X Then LineTest.X = lineend.X - 2
 If lineend.z > linestart.z Then LineTest.z = lineend.z + 2
 If lineend.z < linestart.z Then LineTest.z = lineend.z - 2
    
'Turn on collisions
        Room(CameraFloor).SetCollisionEnable True
        Buildings.SetCollisionEnable True
        Landscape.SetCollisionEnable True
        External.SetCollisionEnable True
        Shafts1(CameraFloor).SetCollisionEnable True
        Shafts2(CameraFloor).SetCollisionEnable True
        ShaftsFloor(CameraFloor).SetCollisionEnable True
        For i50 = 1 To 40
        Elevator(i50).SetCollisionEnable True
        ElevatorInsDoorL(i50).SetCollisionEnable True
        ElevatorInsDoorR(i50).SetCollisionEnable True
        ElevatorDoorL(i50).SetCollisionEnable True
        ElevatorDoorR(i50).SetCollisionEnable True
        Next i50
        Stairs(CameraFloor).SetCollisionEnable True
        
        
        
 'Elevator Collision
 For i50 = 1 To 40
 
    If Elevator(i50).Collision(linestart, LineTest, TV_TESTTYPE_ACCURATETESTING) = True Then Camera.SetPosition linestart.X, Camera.GetPosition.Y, linestart.z: GoTo CollisionEnd
    If ElevatorInsDoorL(i50).Collision(linestart, LineTest, TV_TESTTYPE_ACCURATETESTING) = True Then Camera.SetPosition linestart.X, Camera.GetPosition.Y, linestart.z: GoTo CollisionEnd
    If ElevatorInsDoorR(i50).Collision(linestart, LineTest, TV_TESTTYPE_ACCURATETESTING) = True Then Camera.SetPosition linestart.X, Camera.GetPosition.Y, linestart.z: GoTo CollisionEnd
        
 Next i50
    
 'Collision code for all other objects
    For i50 = 1 To 40
    If ElevatorDoorL(i50).Collision(linestart, LineTest, TV_TESTTYPE_ACCURATETESTING) = True Then Camera.SetPosition linestart.X, Camera.GetPosition.Y, linestart.z: GoTo CollisionEnd
    If ElevatorDoorR(i50).Collision(linestart, LineTest, TV_TESTTYPE_ACCURATETESTING) = True Then Camera.SetPosition linestart.X, Camera.GetPosition.Y, linestart.z: GoTo CollisionEnd
    Next i50
    
    If External.Collision(linestart, LineTest, TV_TESTTYPE_ACCURATETESTING) = True Then Camera.SetPosition linestart.X, Camera.GetPosition.Y, linestart.z: GoTo CollisionEnd
    If Room(CameraFloor).Collision(linestart, LineTest, TV_TESTTYPE_ACCURATETESTING) = True Then Camera.SetPosition linestart.X, Camera.GetPosition.Y, linestart.z: GoTo CollisionEnd
    If Stairs(CameraFloor).Collision(linestart, LineTest, TV_TESTTYPE_ACCURATETESTING) = True Then Camera.SetPosition linestart.X, Camera.GetPosition.Y, linestart.z: GoTo CollisionEnd
    If Buildings.Collision(linestart, LineTest, TV_TESTTYPE_ACCURATETESTING) = True Then Camera.SetPosition linestart.X, Camera.GetPosition.Y, linestart.z: GoTo CollisionEnd
    If Landscape.Collision(linestart, LineTest, TV_TESTTYPE_ACCURATETESTING) = True Then Camera.SetPosition linestart.X, Camera.GetPosition.Y, linestart.z: GoTo CollisionEnd
    If Shafts1(CameraFloor).IsMeshEnabled = True Then If Shafts1(CameraFloor).IsMeshEnabled = True Then If Shafts1(CameraFloor).Collision(linestart, LineTest, TV_TESTTYPE_ACCURATETESTING) = True Then Camera.SetPosition linestart.X, Camera.GetPosition.Y, linestart.z: GoTo CollisionEnd
    If Shafts2(CameraFloor).IsMeshEnabled = True Then If Shafts2(CameraFloor).IsMeshEnabled = True Then If Shafts2(CameraFloor).Collision(linestart, LineTest, TV_TESTTYPE_ACCURATETESTING) = True Then Camera.SetPosition linestart.X, Camera.GetPosition.Y, linestart.z: GoTo CollisionEnd
    If ShaftsFloor(CameraFloor).Collision(linestart, LineTest, TV_TESTTYPE_ACCURATETESTING) = True Then Camera.SetPosition linestart.X, Camera.GetPosition.Y, linestart.z: GoTo CollisionEnd
    
'On Error Resume Next
'For i50 = 1 To 150
'j50 = i50 + (150 * (CameraFloor - 1))
'If Objects(j50).IsMeshEnabled = True Then
'    Objects(j50).SetCollisionEnable True
'    MsgBox (j50)
'    If Objects(j50).Collision(linestart, LineTest, TV_TESTTYPE_ACCURATETESTING) = True Then Camera.SetPosition linestart.X, Camera.GetPosition.Y, linestart.z: GoTo CollisionEnd
'    Objects(j50).SetCollisionEnable False
'End If
'Next i50

CollisionEnd:

'Turn off collisions
        Room(CameraFloor).SetCollisionEnable False
        External.SetCollisionEnable False
        Buildings.SetCollisionEnable False
        Landscape.SetCollisionEnable False
        Shafts1(CameraFloor).SetCollisionEnable False
        Shafts2(CameraFloor).SetCollisionEnable False
        ShaftsFloor(CameraFloor).SetCollisionEnable False
        For i50 = 1 To 40
        Elevator(i50).SetCollisionEnable False
        ElevatorInsDoorL(i50).SetCollisionEnable False
        ElevatorInsDoorR(i50).SetCollisionEnable False
        ElevatorDoorL(i50).SetCollisionEnable False
        ElevatorDoorR(i50).SetCollisionEnable False
        Next i50
        Stairs(CameraFloor).SetCollisionEnable False

End Sub



Sub Fall()

'This detects if the user is above a hole or something (ready to fall)
Room(CameraFloor).SetCollisionEnable True
Shafts1(CameraFloor).SetCollisionEnable True
Shafts2(CameraFloor).SetCollisionEnable True
Buildings.SetCollisionEnable True
Landscape.SetCollisionEnable True

If Room(CameraFloor).Collision(Camera.GetPosition, Vector(Camera.GetPosition.X, Camera.GetPosition.Y - 12, Camera.GetPosition.z), TV_TESTTYPE_ACCURATETESTING) = False And _
    Shafts1(CameraFloor).Collision(Camera.GetPosition, Vector(Camera.GetPosition.X, Camera.GetPosition.Y - 12, Camera.GetPosition.z), TV_TESTTYPE_ACCURATETESTING) = False And _
    Shafts2(CameraFloor).Collision(Camera.GetPosition, Vector(Camera.GetPosition.X, Camera.GetPosition.Y - 12, Camera.GetPosition.z), TV_TESTTYPE_ACCURATETESTING) = False And _
    Landscape.Collision(Camera.GetPosition, Vector(Camera.GetPosition.X, Camera.GetPosition.Y - 12, Camera.GetPosition.z), TV_TESTTYPE_ACCURATETESTING) = False And _
    Buildings.Collision(Camera.GetPosition, Vector(Camera.GetPosition.X, Camera.GetPosition.Y - 12, Camera.GetPosition.z), TV_TESTTYPE_ACCURATETESTING) = False And InElevator = False And InStairwell = False Then IsFalling = True

Room(CameraFloor).SetCollisionEnable False
Shafts1(CameraFloor).SetCollisionEnable False
Shafts2(CameraFloor).SetCollisionEnable False
Buildings.SetCollisionEnable False
Landscape.SetCollisionEnable False

'*********************************
If IsFalling = False Then Exit Sub

'The gravity originally acted weird
Dim TimeRate As Single
Gravity = 5
If FallRate = 0 Then
lngOldTick = GetTickCount()
CameraOriginalPos = Camera.GetPosition.Y
End If

'MsgBox ((GetTickCount() / 1000) - (lngOldTick / 1000))

'Basically this is Fallrate=Gravity*SecondsPassed
TimeRate = ((GetTickCount() / 1000) - (lngOldTick / 1000))
FallRate = (Gravity * TimeRate) ^ 1.8
If FallRate = 0 Then FallRate = 0.1
If TimeRate = 0 Then TimeRate = 0.1
'MsgBox ("Gravity:" + Str$(Gravity) + " Time Passed:" + Str$((GetTickCount() / 1000) - (lngOldTick / 1000)))

Camera.SetPosition Camera.GetPosition.X, CameraOriginalPos - FallRate, Camera.GetPosition.z

Room(CameraFloor).SetCollisionEnable True
Shafts1(CameraFloor).SetCollisionEnable True
Shafts2(CameraFloor).SetCollisionEnable True
Buildings.SetCollisionEnable True
Landscape.SetCollisionEnable True

If Room(CameraFloor).Collision(Camera.GetPosition, Vector(Camera.GetPosition.X, Camera.GetPosition.Y - (FallRate / TimeRate), Camera.GetPosition.z), TV_TESTTYPE_ACCURATETESTING) = True Then
FallRate = 0
IsFalling = False
If CameraFloor > 1 Then Camera.SetPosition Camera.GetPosition.X, (CameraFloor * FloorHeight) + FloorHeight + 10, Camera.GetPosition.z
If CameraFloor = 1 Then Camera.SetPosition Camera.GetPosition.X, 10, Camera.GetPosition.z
End If
If Shafts1(CameraFloor).Collision(Camera.GetPosition, Vector(Camera.GetPosition.X, Camera.GetPosition.Y - (FallRate / TimeRate), Camera.GetPosition.z), TV_TESTTYPE_ACCURATETESTING) = True Then
FallRate = 0
IsFalling = False
If CameraFloor > 1 Then Camera.SetPosition Camera.GetPosition.X, (CameraFloor * FloorHeight) + FloorHeight + 10, Camera.GetPosition.z
If CameraFloor = 1 Then Camera.SetPosition Camera.GetPosition.X, 10, Camera.GetPosition.z
End If
If Shafts2(CameraFloor).Collision(Camera.GetPosition, Vector(Camera.GetPosition.X, Camera.GetPosition.Y - (FallRate / TimeRate), Camera.GetPosition.z), TV_TESTTYPE_ACCURATETESTING) = True Then
FallRate = 0
IsFalling = False
If CameraFloor > 1 Then Camera.SetPosition Camera.GetPosition.X, (CameraFloor * FloorHeight) + FloorHeight + 10, Camera.GetPosition.z
If CameraFloor = 1 Then Camera.SetPosition Camera.GetPosition.X, 10, Camera.GetPosition.z
End If
If Buildings.Collision(Camera.GetPosition, Vector(Camera.GetPosition.X, Camera.GetPosition.Y - (FallRate / TimeRate), Camera.GetPosition.z), TV_TESTTYPE_ACCURATETESTING) = True Then
FallRate = 0
IsFalling = False
If CameraFloor > 1 Then Camera.SetPosition Camera.GetPosition.X, (CameraFloor * FloorHeight) + FloorHeight + 10, Camera.GetPosition.z
If CameraFloor = 1 Then Camera.SetPosition Camera.GetPosition.X, 10, Camera.GetPosition.z
End If
If Landscape.Collision(Camera.GetPosition, Vector(Camera.GetPosition.X, Camera.GetPosition.Y - (FallRate / TimeRate), Camera.GetPosition.z), TV_TESTTYPE_ACCURATETESTING) = True Then
FallRate = 0
IsFalling = False
If CameraFloor > 1 Then Camera.SetPosition Camera.GetPosition.X, (CameraFloor * FloorHeight) + FloorHeight + 10, Camera.GetPosition.z
If CameraFloor = 1 Then Camera.SetPosition Camera.GetPosition.X, 10, Camera.GetPosition.z
End If

Room(CameraFloor).SetCollisionEnable False
Shafts1(CameraFloor).SetCollisionEnable False
Shafts2(CameraFloor).SetCollisionEnable False
Buildings.SetCollisionEnable False
Landscape.SetCollisionEnable False

End Sub

Sub OptimizeMeshes()
  External.Optimize
  Landscape.Optimize
  Buildings.Optimize
  For i = 1 To 138
  DoEvents
  Form1.Label2.Caption = "Optimizing Meshes Part 1 (of 2)... " + Str$(Int((i / 138) * 100)) + "%"
  Room(i).Optimize
  Stairs(i).Optimize
  ShaftsFloor(i).Optimize
  Shafts1(i).Optimize
  Shafts2(i).Optimize
  Shafts3(i).Optimize
  Shafts4(i).Optimize
  Next i
  For i = 1 To 40
  DoEvents
  Form1.Label2.Caption = "Optimizing Meshes Part 2 (of 2)... " + Str$(Int((i / 40) * 100)) + "%"
  Elevator(i).Optimize
  ElevatorInsDoorL(i).Optimize
  ElevatorInsDoorR(i).Optimize
  Plaque(i).Optimize
  Next i
  
End Sub

Sub ProcessFloors()
'Lobby
Call ProcessLobby
Call Process2to39
Call Process40to79
Call Process81to114
Call Process118to129
Call ProcessOtherFloors
Call ProcessOtherFloors2
Form1.Label2.Caption = "Initializing Lobby... "
Call InitRealtime(1)
Call InitObjectsForFloor(1)
 
Form1.Label2.Caption = "Processing Outside... "
Call ProcessOutside
Form1.Label2.Caption = "Processing Elevators... "
Call ProcessMisc
Call ProcessStairs
Call OptimizeMeshes
End Sub

Sub ProcessLobby()


DoEvents
Form1.Label2.Caption = "Processing Lobby..."
      i = 1
    Room(i).AddFloor GetTex("Marble4"), -160, -150, 160, 150, 0, (FloorHeight * 2), 31
    'Mezzanine Level
    Room(i).AddFloor GetTex("Granite"), -90.5, -55, 90.5, -46.25, FloorHeight, ((90.5 * 2) * 0.086), ((55 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -90.5, 0, 90.5, 55, FloorHeight, ((90.5 * 2) * 0.086), (55 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -90.5, -46.25, -52.5, 0, FloorHeight, ((90.5 - 52.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), 52.5, -46.25, 90.5, 0, FloorHeight, ((90.5 - 52.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -12.5, -46.25, 12.5, 0, FloorHeight, ((12.5 * 2) * 0.086), (46.25 * 0.08)
    
    Room(i).AddFloor GetTex("Ceiling1"), -90.5, -55, 90.5, -46.25, FloorHeight - 0.1, ((90.5 * 2) * 0.086), ((55 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Ceiling1"), -90.5, 0, 90.5, 55, FloorHeight - 0.1, ((90.5 * 2) * 0.086), (55 * 0.08)
    Room(i).AddFloor GetTex("Ceiling1"), -90.5, -46.25, -52.5, 0, FloorHeight - 0.1, ((90.5 - 52.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Ceiling1"), 52.5, -46.25, 90.5, 0, FloorHeight - 0.1, ((90.5 - 52.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Ceiling1"), -12.5, -46.25, 12.5, 0, FloorHeight - 0.1, ((12.5 * 2) * 0.086), (46.25 * 0.08)
    
    'End of Mezzanine
    
    'External.AddWall GetTex("LobbyFront"), -160, -150, 160, -150, (FloorHeight * 3), 0, 3, 1
    'External.AddWall GetTex("LobbyFront"), 160, -150, 160, 150, (FloorHeight * 3), 0, 3, 1
    'External.AddWall GetTex("LobbyFront"), 160, 150, -160, 150, (FloorHeight * 3), 0, 3, 1
    'External.AddWall GetTex("LobbyFront"), -160, 150, -160, -150, (FloorHeight * 3), 0, 3, 1
              
    Room(i).AddWall GetTex("LobbyFront"), -160 + 0.1, -150 + 0.1, 160 - 0.1, -150 + 0.1, (FloorHeight * 3), 0, 3, 1
    Room(i).AddWall GetTex("LobbyFront"), 160 - 0.1, -150 + 0.1, 160 - 0.1, 150 - 0.1, (FloorHeight * 3), 0, 3, 1
    Room(i).AddWall GetTex("LobbyFront"), 160 - 0.1, 150 - 0.1, -160 + 0.1, 150 - 0.1, (FloorHeight * 3), 0, 3, 1
    Room(i).AddWall GetTex("LobbyFront"), -160 + 0.1, 150 - 0.1, -160 + 0.1, -150 + 0.1, (FloorHeight * 3), 0, 3, 1
                  
    'always make sure this call is also in the ProcessFloors sub, but under the DrawElevatorShafts name
    Call DrawElevatorWalls(Int(i), 5, 1, True, False, True, True, True, True, False, False, False, False, False, False)
    Call DrawElevatorWalls(Int(i), 5, 2, True, False, True, True, True, True, False, False, False, False, False, False)
    Call DrawElevatorWalls(Int(i), 1, 3, True, False, True, True, True, True, True, True, True, True, True, True)
    Call DrawElevatorWalls(Int(i), 1, 4, True, False, True, True, True, True, True, True, True, True, True, True)
    
    'Stairwell Walls
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -46.25 + 0.1, -12.5 - 0.5, -40.3, (FloorHeight * 3), 0, ((46.25 - 40.3) * 0.086), ((FloorHeight * 3) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -32.5, -12.5 - 0.5, -30, (FloorHeight * 3), 0, (2.5 * 0.086), ((FloorHeight * 3) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -32.5 + 0.1, -46.25 + 0.1, -32.5 + 0.1, -30 - 1, (FloorHeight * 3), 0, (16.25 * 0.086), ((FloorHeight * 3) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -46.25 + 0.1, -32.5, -46.25 + 0.1, (FloorHeight * 3), 0, (20 * 0.086), ((FloorHeight * 3) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -30 - 1, -32.5, -30 - 1, (FloorHeight * 3), 0, (20 * 0.086), ((FloorHeight * 3) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 6, -46.25 + 7.71, -12.5 - 16, -46.25 + 7.71, (FloorHeight * 3), 0, (10 * 0.086), ((FloorHeight * 3) * 0.086)
    
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -40.3, -12.5 - 0.5, -30, (FloorHeight - 19.5), 19.5, (10.3 * 0.086), ((FloorHeight - 19.5) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -40.3, -12.5 - 0.5, -30, (FloorHeight - 19.5), 19.5 + FloorHeight, (10.3 * 0.086), ((FloorHeight - 19.5) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -40.3, -12.5 - 0.5, -30, FloorHeight, (FloorHeight * 2), (10.3 * 0.086), (FloorHeight * 0.086)
    
    'Ceiling
    Room(i).AddFloor GetTex("Ceiling1"), -160, -150, 160, -46.25, (FloorHeight * 3) - 0.5, ((160 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Ceiling1"), -160, 46.25, 160, 150, (FloorHeight * 3) - 0.5, ((160 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Ceiling1"), -90.5, -46.25, -52.5, 46.25, (FloorHeight * 3) - 0.5, ((90.5 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Ceiling1"), 52.5, -46.25, 90.5, 46.25, (FloorHeight * 3) - 0.5, ((90.5 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Ceiling1"), -12.5, -46.25, 12.5, 0, (FloorHeight * 3) - 0.5, ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Ceiling1"), -52.5, 0, 52.5, 46.25, (FloorHeight * 3) - 0.5, ((52.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Ceiling1"), -160, -46.25, -130.5, 46.25, (FloorHeight * 3) - 0.5, ((160 - 130.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Ceiling1"), 160, -46.25, 130.5, 46.25, (FloorHeight * 3) - 0.5, ((160 - 130.5) * 0.086), ((46.25 * 2) * 0.08)
            
End Sub

Sub Process2to39()
    
    'Floors 2 to 39
    For i = 2 To 39
    DoEvents
    Form1.Label2.Caption = "Processing Floors 2 to 39... " + Str$(Int((i / 39) * 100)) + "%"
    
    'Floor
    Room(i).AddFloor GetTex("Granite"), -160, -150, 160, -46.25, (i * FloorHeight) + FloorHeight, ((160 + 160) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -160, 46.25, 160, 150, (i * FloorHeight) + FloorHeight, ((160 + 160) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -90.5, -46.25, -52.5, 46.25, (i * FloorHeight) + FloorHeight, ((90.5 - 52.5) * 0.086), ((46.25 + 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), 52.5, -46.25, 90.5, 46.25, (i * FloorHeight) + FloorHeight, ((90.5 + 52.5) * 0.086), ((46.25 + 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + FloorHeight, ((12.5 + 12.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -52.5, 0, 52.5, 46.25, (i * FloorHeight) + FloorHeight, ((52.5 + 52.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -160, -46.25, -130.5, 46.25, (i * FloorHeight) + FloorHeight, ((160 - 130.5) * 0.086), ((46.25 + 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), 160, -46.25, 130.5, 46.25, (i * FloorHeight) + FloorHeight, ((160 - 130.5) * 0.086), ((46.25 + 46.25) * 0.08)
    
    'Ceiling
    Room(i).AddFloor GetTex("Marble3"), -160, -150, 160, -46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((160 + 160) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -160, 46.25, 160, 150, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((160 + 160) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -90.5, -46.25, -52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((90.5 - 52.5) * 0.086), ((46.25 + 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), 52.5, -46.25, 90.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((90.5 + 52.5) * 0.086), ((46.25 + 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((12.5 + 12.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -52.5, 0, 52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((52.5 + 52.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -160, -46.25, -130.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((160 - 130.5) * 0.086), ((46.25 + 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), 160, -46.25, 130.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((160 - 130.5) * 0.086), ((46.25 + 46.25) * 0.08)
    
    'Crawlspace bottom
    Room(i).AddFloor GetTex("BrickTexture"), -160, -150, 160, -46.25, (i * FloorHeight) + (FloorHeight + 25), ((160 + 160) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -160, 46.25, 160, 150, (i * FloorHeight) + (FloorHeight + 25), ((160 + 160) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -90.5, -46.25, -52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((90.5 - 52.5) * 0.086), ((46.25 + 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), 52.5, -46.25, 90.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((90.5 + 52.5) * 0.086), ((46.25 + 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + (FloorHeight + 25), ((12.5 + 12.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -52.5, 0, 52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((52.5 + 52.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -160, -46.25, -130.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((160 - 130.5) * 0.086), ((46.25 + 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), 160, -46.25, 130.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((160 - 130.5) * 0.086), ((46.25 + 46.25) * 0.08)
    
    'Crawlspace top
    Room(i).AddFloor GetTex("BrickTexture"), -160, -150, 160, -46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((160 + 160) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -160, 46.25, 160, 150, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((160 + 160) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -90.5, -46.25, -52.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((90.5 - 52.5) * 0.086), ((46.25 + 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), 52.5, -46.25, 90.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((90.5 + 52.5) * 0.086), ((46.25 + 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((12.5 + 12.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -52.5, 0, 52.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((52.5 + 52.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -160, -46.25, -130.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((160 - 130.5) * 0.086), ((46.25 + 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), 160, -46.25, 130.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((160 - 130.5) * 0.086), ((46.25 + 46.25) * 0.08)
    
    'Crawlspace walls
    Room(i).AddWall GetTex("BrickTexture"), -160, -150, 160, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((160 + 160) * 0.086), 1
    Room(i).AddWall GetTex("BrickTexture"), 160, -150, 160, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((160 + 160) * 0.086), 1
    Room(i).AddWall GetTex("BrickTexture"), 160, 150, -160, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((160 + 160) * 0.086), 1
    Room(i).AddWall GetTex("BrickTexture"), -160, 150, -160, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((160 + 160) * 0.086), 1

    'Stairwell Walls
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -46.25 + 0.1, -12.5 - 0.5, -40.3, (FloorHeight), (i * FloorHeight) + FloorHeight, ((46.25 - 40.3) * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -32.5, -12.5 - 0.5, -30, (FloorHeight), (i * FloorHeight) + FloorHeight, (2.5 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -32.5 + 0.1, -46.25 + 0.1, -32.5 + 0.1, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (16.25 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -46.25 + 0.1, -32.5, -46.25 + 0.1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -30 - 1, -32.5, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 6, -46.25 + 7.71, -12.5 - 16, -46.25 + 7.71, (FloorHeight), (i * FloorHeight) + FloorHeight, (10 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -40.3, -12.5 - 0.5, -30, (FloorHeight - 19.5), 19.5 + (i * FloorHeight) + FloorHeight, (10.3 * 0.086), ((FloorHeight - 19.5) * 0.08)
    
    If i = 2 Or i = 39 Then
    Call DrawElevatorWalls(Int(i), 5, 1, True, False, True, False, False, False, False, False, False, False, False, False)
    Call DrawElevatorWalls(Int(i), 5, 2, True, False, True, False, False, False, False, False, False, False, False, False)
    Call DrawElevatorWalls(Int(i), 2, 3, True, False, False, False, False, False, False, False, False, False, False, False)
    Call DrawElevatorWalls(Int(i), 2, 4, True, False, True, True, True, True, True, True, True, True, True, True)
    End If
    If i <> 2 And i <> 39 Then
    Call DrawElevatorWalls(Int(i), 5, 1, True, False, False, False, False, False, False, False, False, False, False, False)
    Call DrawElevatorWalls(Int(i), 5, 2, True, False, True, False, False, False, False, False, False, False, False, False)
    Call DrawElevatorWalls(Int(i), 2, 3, True, False, False, False, False, False, False, False, False, False, False, False)
    Call DrawElevatorWalls(Int(i), 2, 4, True, False, True, True, True, True, True, True, True, True, True, True)
    End If
    
    'Room(I) Walls
    'top walls
    Room(i).AddWall GetTex("Wall3"), -160, -71.3, -90.5, -71.3, 19.5, (i * FloorHeight) + FloorHeight, ((160 - 90.5) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, -71.3, 70, -71.3, 19.5, (i * FloorHeight) + FloorHeight, ((70 + 70) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 160, -71.3, 90.5, -71.3, 19.5, (i * FloorHeight) + FloorHeight, ((160 - 90.5) * 0.086), (19.5 * 0.08)
    
    Room(i).AddWall GetTex("Wall3"), -160, -71.3, -90.5, -71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((160 - 90.5) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, -71.3, 70, -71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((70 + 70) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 160, -71.3, 90.5, -71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((160 - 90.5) * 0.086), (5.5 * 0.08)
    
    'bottom walls
    Room(i).AddWall GetTex("Wall3"), -160, 71.3, -90.5, 71.3, 19.5, (i * FloorHeight) + FloorHeight, ((160 - 90.5) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, 71.3, 70, 71.3, 19.5, (i * FloorHeight) + FloorHeight, ((70 + 70) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 160, 71.3, 90.5, 71.3, 19.5, (i * FloorHeight) + FloorHeight, ((160 - 90.5) * 0.086), (19.5 * 0.08)
    
    Room(i).AddWall GetTex("Wall3"), -160, 71.3, -90.5, 71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((160 - 90.5) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, 71.3, 70, 71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((70 + 70) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 160, 71.3, 90.5, 71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((160 - 90.5) * 0.086), (5.5 * 0.08)
    
    'top middle walls
    Room(i).AddWall GetTex("Wall3"), -70, -46.25, -61.25 - 3.9, -46.25, 19.5, (i * FloorHeight) + FloorHeight, ((70 - 61.25 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -61.25 + 3.9, -46.25, -52.5, -46.25, 19.5, (i * FloorHeight) + FloorHeight, ((61.25 - 3.9 - 52.5) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 70, -46.25, 61.25 + 3.9, -46.25, 19.5, (i * FloorHeight) + FloorHeight, ((70 - 61.25 + 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 61.25 - 3.9, -46.25, 52.5, -46.25, 19.5, (i * FloorHeight) + FloorHeight, ((61.25 - 3.9 - 52.5) * 0.086), (19.5 * 0.08)
    
    Room(i).AddWall GetTex("Wall3"), -70, -46.25, -52.5, -46.25, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((70 - 52.5) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 52.5, -46.25, 70, -46.25, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((70 - 52.5) * 0.086), (5.5 * 0.08)
    
    'service rooms
    Room(i).AddWall GetTex("Wall3"), 70, -46.25, 70, 46.25, 25, (i * FloorHeight) + FloorHeight, ((46.25 + 46.25) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 70, -15, 52.5, -15, 25, (i * FloorHeight) + FloorHeight, ((70 - 52.5) * 0.086), 1
    
    Room(i).AddWall GetTex("Wall3"), -70, -46.25, -70, 46.25, 25, (i * FloorHeight) + FloorHeight, ((46.25 + 46.25) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), -70, -15, -52.5, -15, 25, (i * FloorHeight) + FloorHeight, ((70 - 52.5) * 0.086), 1
    
    'left hallway
    Room(i).AddWall GetTex("Wall3"), 70, -150, 70, -130 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 130 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 70, -130 + 3.9, 70, -90 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((130 - 90 - 3.9 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 70, -90 + 3.9, 70, -71.3, 19.5, (i * FloorHeight) + FloorHeight, ((90 - 71.3 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 90.5, -150, 90.5, -130 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 130 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 90.5, -130 + 3.9, 90.5, -90 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((130 - 90 - 3.9 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 90.5, -90 + 3.9, 90.5, -71.3, 19.5, (i * FloorHeight) + FloorHeight, ((90 - 71.3 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 70, 150, 70, 130 + 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 130 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 70, 130 - 3.9, 70, 90 + 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((130 - 90 - 3.9 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 70, 90 - 3.9, 70, 71.3, 19.5, (i * FloorHeight) + FloorHeight, ((90 - 71.3 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 90.5, 150, 90.5, 130 + 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 130 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 90.5, 130 - 3.9, 90.5, 90 + 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((130 - 90 - 3.9 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 90.5, 90 - 3.9, 90.5, 71.3, 19.5, (i * FloorHeight) + FloorHeight, ((90 - 71.3 - 3.9) * 0.086), (19.5 * 0.08)
    
    Room(i).AddWall GetTex("Wall3"), 70, -150, 70, -71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((150 - 71.3) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 90.5, -150, 90.5, -71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((150 - 71.3) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 70, 150, 70, 71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((150 - 71.3) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 90.5, 150, 90.5, 71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((150 - 71.3) * 0.086), (5.5 * 0.08)
    
    'right hallway
    Room(i).AddWall GetTex("Wall3"), -70, -150, -70, -130 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 130 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, -130 + 3.9, -70, -90 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((130 - 90 - 3.9 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, -90 + 3.9, -70, -71.3, 19.5, (i * FloorHeight) + FloorHeight, ((90 - 70 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -90.5, -150, -90.5, -130 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 130 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -90.5, -130 + 3.9, -90.5, -90 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((130 - 90 - 3.9 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -90.5, -90 + 3.9, -90.5, -71.3, 19.5, (i * FloorHeight) + FloorHeight, ((90 - 71.3 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, 150, -70, 130 + 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 130 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, 130 - 3.9, -70, 90 + 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((130 - 90 - 3.9 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, 90 - 3.9, -70, 71.3, 19.5, (i * FloorHeight) + FloorHeight, ((90 - 71.3 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -90.5, 150, -90.5, 130 + 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 130 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -90.5, 130 - 3.9, -90.5, 90 + 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((130 - 90 - 3.9 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -90.5, 90 - 3.9, -90.5, 71.3, 19.5, (i * FloorHeight) + FloorHeight, ((90 - 71.3 - 3.9) * 0.086), (19.5 * 0.08)
    
    Room(i).AddWall GetTex("Wall3"), -70, -150, -70, -71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((150 - 71.3) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -90.5, -150, -90.5, -71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((150 - 71.3) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, 150, -70, 71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((150 - 71.3) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -90.5, 150, -90.5, 71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((150 - 71.3) * 0.086), (5.5 * 0.08)
    
    'middle hallway extension
    Room(i).AddWall GetTex("Wall3"), -12.5, 0, -12.5, 46.25, 25, (i * FloorHeight) + FloorHeight, (46.25 * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 12.5, 0, 12.5, 46.25, 25, (i * FloorHeight) + FloorHeight, (46.25 * 0.086), (19.5 * 0.08)
    
    'bottom middle walls
    Room(i).AddWall GetTex("Wall3"), -70, 46.25, -22.5 - 3.9, 46.25, 19.5, (i * FloorHeight) + FloorHeight, ((70 - 22.5 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -22.5 + 3.9, 46.25, -12.5, 46.25, 19.5, (i * FloorHeight) + FloorHeight, ((22.5 - 12.5 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 70, 46.25, 22.5 + 3.9, 46.25, 19.5, (i * FloorHeight) + FloorHeight, ((70 - 22.5 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 22.5 - 3.9, 46.25, 12.5, 46.25, 19.5, (i * FloorHeight) + FloorHeight, ((22.5 - 12.5 - 3.9) * 0.086), (19.5 * 0.08)
    
    Room(i).AddWall GetTex("Wall3"), -70, 46.25, -12.5, 46.25, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((70 - 12.5) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 12.5, 46.25, 70, 46.25, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((70 - 12.5) * 0.086), (5.5 * 0.08)
    
    'Rooms
    Room(i).AddWall GetTex("Wall3"), -160, -110, -90.5, -110, 25, (i * FloorHeight) + FloorHeight, ((160 - 90.5) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), -160, 110, -90.5, 110, 25, (i * FloorHeight) + FloorHeight, ((160 - 90.5) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), -70, -110, 70, -110, 25, (i * FloorHeight) + FloorHeight, ((70 * 2) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), -70, 110, 70, 110, 25, (i * FloorHeight) + FloorHeight, ((70 * 2) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 160, -110, 90.5, -110, 25, (i * FloorHeight) + FloorHeight, ((160 - 90.5) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 160, 110, 90.5, 110, 25, (i * FloorHeight) + FloorHeight, ((160 - 90.5) * 0.086), 1
    
    Room(i).AddWall GetTex("Wall3"), 0, -71.3, 0, -150, 25, (i * FloorHeight) + FloorHeight, ((150 - 71.3) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 0, 71.3, 0, 150, 25, (i * FloorHeight) + FloorHeight, ((150 - 71.3) * 0.086), 1
    
    Next i

End Sub
Sub Process40to79()
    
    'Floors 40 to 79 (minus 14 feet on both sides where 20=8 feet)
    For i = 40 To 79
    DoEvents
    Form1.Label2.Caption = "Processing Floors 40 to 79... " + Str$(Int(((i - 40) / (79 - 40)) * 100)) + "%"
    
    'Floor
    Room(i).AddFloor GetTex("Granite"), -135, -150, 135, -46.25, (i * FloorHeight) + FloorHeight, ((135 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -135, 46.25, 135, 150, (i * FloorHeight) + FloorHeight, ((135 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -90.5, -46.25, -52.5, 46.25, (i * FloorHeight) + FloorHeight, ((90.5 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Granite"), 52.5, -46.25, 90.5, 46.25, (i * FloorHeight) + FloorHeight, ((90.5 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + FloorHeight, ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -52.5, 0, 52.5, 46.25, (i * FloorHeight) + FloorHeight, ((52.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -135, -46.25, -110.5, 46.25, (i * FloorHeight) + FloorHeight, ((135 - 110.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Granite"), 135, -46.25, 110.5, 46.25, (i * FloorHeight) + FloorHeight, ((135 - 110.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Ceiling
    Room(i).AddFloor GetTex("Marble3"), -135, -150, 135, -46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((135 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -135, 46.25, 135, 150, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((135 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -90.5, -46.25, -52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((90.5 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), 52.5, -46.25, 90.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((90.5 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -52.5, 0, 52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((52.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -135, -46.25, -110.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((135 - 110.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), 135, -46.25, 110.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((135 - 110.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Crawlspace bottom
    Room(i).AddFloor GetTex("BrickTexture"), -135, -150, 135, -46.25, (i * FloorHeight) + (FloorHeight + 25), ((135 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -135, 46.25, 135, 150, (i * FloorHeight) + (FloorHeight + 25), ((135 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -90.5, -46.25, -52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((90.5 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), 52.5, -46.25, 90.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((90.5 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + (FloorHeight + 25), ((12.5 * 2) * 0.086), ((46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -52.5, 0, 52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((52.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -135, -46.25, -110.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((135 - 110.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), 135, -46.25, 110.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((135 - 110.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Crawlspace top
    Room(i).AddFloor GetTex("BrickTexture"), -135, -150, 135, -46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((135 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -135, 46.25, 135, 150, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((135 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -90.5, -46.25, -52.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((90.5 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), 52.5, -46.25, 90.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((90.5 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -52.5, 0, 52.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((52.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -135, -46.25, -110.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((135 - 110.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), 135, -46.25, 110.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((135 - 110.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Crawlspace walls
    Room(i).AddWall GetTex("BrickTexture"), -135, -150, 135, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((135 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), 135, -150, 135, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((150 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), 135, 150, -135, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((135 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), -135, 150, -135, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((150 * 2) * 0.086), ((FloorHeight - 25) * 0.08)

    'Stairwell Walls
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -46.25 + 0.1, -12.5 - 0.5, -40.3, (FloorHeight), (i * FloorHeight) + FloorHeight, ((46.25 - 40.3) * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -32.5, -12.5 - 0.5, -30, (FloorHeight), (i * FloorHeight) + FloorHeight, (2.5 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -32.5 + 0.1, -46.25 + 0.1, -32.5 + 0.1, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (16.25 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -46.25 + 0.1, -32.5, -46.25 + 0.1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -30 - 1, -32.5, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 6, -46.25 + 7.71, -12.5 - 16, -46.25 + 7.71, (FloorHeight), (i * FloorHeight) + FloorHeight, (10 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -40.3, -12.5 - 0.5, -30, (FloorHeight - 19.5), 19.5 + (i * FloorHeight) + FloorHeight, (10.3 * 0.086), ((FloorHeight - 19.5) * 0.08)
    
    If i = 40 Or i = 79 Then
    Call DrawElevatorWalls(Int(i), 5, 1, True, False, True, False, False, False, False, False, False, False, False, False)
    'Call DrawElevatorWalls(Int(i), 5, 2, True, False, False, False, False, False, False, False, False, False, False, False)
    Call DrawElevatorWalls(Int(i), 2, 3, False, False, True, True, True, True, True, True, True, True, True, True)
    End If
    If i <> 40 And i <> 79 Then
    Call DrawElevatorWalls(Int(i), 5, 1, True, False, False, False, False, False, False, False, False, False, False, False)
    'Call DrawElevatorWalls(Int(i), 5, 2, True, False, False, False, False, False, False, False, False, False, False, False)
    Call DrawElevatorWalls(Int(i), 2, 3, False, False, True, True, True, True, True, True, True, True, True, True)
    End If
    If i <= 51 Then
    Call DrawElevatorWalls(Int(i), 5, 2, True, False, True, False, False, False, False, False, False, False, False, False)
    End If
    If i > 51 Then
    Call DrawElevatorWalls(Int(i), 5, 2, True, False, False, True, False, False, False, False, False, False, False, False)
    End If
    
    'Room(I) Walls
    
    'top walls
    Room(i).AddWall GetTex("Wall3"), -135, -71.3, -90.5, -71.3, 19.5, (i * FloorHeight) + FloorHeight, ((135 - 90.5) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, -71.3, 70, -71.3, 19.5, (i * FloorHeight) + FloorHeight, ((70 * 2) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 135, -71.3, 90.5, -71.3, 19.5, (i * FloorHeight) + FloorHeight, ((135 - 90.5) * 0.086), (19.5 * 0.08)
    
    Room(i).AddWall GetTex("Wall3"), -135, -71.3, -90.5, -71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((135 - 90.5) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, -71.3, 70, -71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((70 * 2) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 135, -71.3, 90.5, -71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((135 - 90.5) * 0.086), (5.5 * 0.08)
    
    'bottom walls
    Room(i).AddWall GetTex("Wall3"), -135, 71.3, -90.5, 71.3, 19.5, (i * FloorHeight) + FloorHeight, ((135 - 90.5) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, 71.3, 70, 71.3, 19.5, (i * FloorHeight) + FloorHeight, ((70 * 2) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 135, 71.3, 90.5, 71.3, 19.5, (i * FloorHeight) + FloorHeight, ((135 - 90.5) * 0.086), (19.5 * 0.08)
    
    Room(i).AddWall GetTex("Wall3"), -135, 71.3, -90.5, 71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((135 - 90.5) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, 71.3, 70, 71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((70 * 2) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 135, 71.3, 90.5, 71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((135 - 90.5) * 0.086), (5.5 * 0.08)
    
    Room(i).AddWall GetTex("Wall3"), -70, -46.25, -61.25 - 3.9, -46.25, 25, (i * FloorHeight) + FloorHeight, ((70 - 61.25 - 3.9) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), -61.25 + 3.9, -46.25, -52.5, -46.25, 25, (i * FloorHeight) + FloorHeight, ((61.25 - 52.5 - 3.9) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 70, -46.25, 61.25 + 3.9, -46.25, 25, (i * FloorHeight) + FloorHeight, ((70 - 61.25 - 3.9) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 61.25 - 3.9, -46.25, 52.5, -46.25, 25, (i * FloorHeight) + FloorHeight, ((61.25 - 52.5) * 0.086), 1
    
    Room(i).AddWall GetTex("Wall3"), -70, -46.25, -52.5, -46.25, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((70 - 52.5) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 52.5, -46.25, 70, -46.25, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((70 - 52.5) * 0.086), (5.5 * 0.08)
    
    'service rooms
    Room(i).AddWall GetTex("Wall3"), 70, -46.25, 70, 46.25, 25, (i * FloorHeight) + FloorHeight, ((46.25 - 20) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 70, -15, 52.5, -15, 25, (i * FloorHeight) + FloorHeight, ((50 - 32.5) * 0.086), 1
    
    Room(i).AddWall GetTex("Wall3"), -70, -46.25, -70, 46.25, 25, (i * FloorHeight) + FloorHeight, ((46.25 * 2) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), -70, -15, -52.5, -15, 25, (i * FloorHeight) + FloorHeight, ((70 - 52.5) * 0.086), 1
    
    'left hallway
    Room(i).AddWall GetTex("Wall3"), 70, -150, 70, -130 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 130 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 70, -130 + 3.9, 70, -90 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((130 - 3.9 - 90 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 70, -90 + 3.9, 70, -71.3, 19.5, (i * FloorHeight) + FloorHeight, ((90 - 71.3 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 90.5, -150, 90.5, -130 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 130 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 90.5, -130 + 3.9, 90.5, -90 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((130 - 3.9 - 90 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 90.5, -90 + 3.9, 90.5, -71.3, 19.5, (i * FloorHeight) + FloorHeight, ((90 - 71.3 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 70, 150, 70, 130 + 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 130 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 70, 130 - 3.9, 70, 90 + 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((130 - 90 - 3.9 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 70, 90 - 3.9, 70, 71.3, 19.5, (i * FloorHeight) + FloorHeight, ((90 - 70 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 90.5, 150, 90.5, 130 + 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 130 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 90.5, 130 - 3.9, 90.5, 90 + 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((130 - 3.9 - 90 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 90.5, 90 - 3.9, 90.5, 71.3, 19.5, (i * FloorHeight) + FloorHeight, ((90 - 71.3 - 3.9) * 0.086), (19.5 * 0.08)
    
    Room(i).AddWall GetTex("Wall3"), 70, -150, 70, -71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((150 - 71.3) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 90.5, -150, 90.5, -71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((150 - 71.3) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 70, 150, 70, 71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((150 - 71.3) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 90.5, 150, 90.5, 71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((150 - 71.3) * 0.086), (5.5 * 0.08)
    
    'right hallway
    Room(i).AddWall GetTex("Wall3"), -70, -150, -70, -130 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 130 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, -130 + 3.9, -70, -90 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((130 - 90 - 3.9 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, -90 + 3.9, -70, -71.3, 19.5, (i * FloorHeight) + FloorHeight, ((90 - 71.3 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -90.5, -150, -90.5, -130 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 130 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -90.5, -130 + 3.9, -90.5, -90 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((130 - 90 - 3.9 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -90.5, -90 + 3.9, -90.5, -71.3, 19.5, (i * FloorHeight) + FloorHeight, ((90 - 71.3 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, 150, -70, 130 + 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 130 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, 130 - 3.9, -70, 90 + 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((130 - 90 - 3.9 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, 90 - 3.9, -70, 71.3, 19.5, (i * FloorHeight) + FloorHeight, ((90 - 71.3 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -90.5, 150, -90.5, 130 + 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 130 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -90.5, 130 - 3.9, -90.5, 90 + 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((130 - 3.9 - 90 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -90.5, 90 - 3.9, -90.5, 71.3, 19.5, (i * FloorHeight) + FloorHeight, ((90 - 71.3 - 3.9) * 0.086), (19.5 * 0.08)
    
    Room(i).AddWall GetTex("Wall3"), -70, -150, -70, -71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((150 - 71.3) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -90.5, -150, -90.5, -71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((150 - 71.3) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, 150, -70, 71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((150 - 71.3) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -90.5, 150, -90.5, 71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((150 - 71.3) * 0.086), (5.5 * 0.08)
    
    'middle hallway extension
    Room(i).AddWall GetTex("Wall3"), -12.5, 0, -12.5, 46.25, 25, (i * FloorHeight) + FloorHeight, (46.25 * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 12.5, 0, 12.5, 46.25, 25, (i * FloorHeight) + FloorHeight, (46.25 * 0.086), 1
    
    'bottom middle walls
    Room(i).AddWall GetTex("Wall3"), -70, 46.25, -22.5 - 3.9, 46.25, 19.5, (i * FloorHeight) + FloorHeight, ((70 - 22.5 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -22.5 + 3.9, 46.25, -12.5, 46.25, 19.5, (i * FloorHeight) + FloorHeight, ((22.5 - 3.9 - 12.5) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 70, 46.25, 22.5 + 3.9, 46.25, 19.5, (i * FloorHeight) + FloorHeight, ((70 - 22.5 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 22.5 - 3.9, 46.25, 12.5, 46.25, 19.5, (i * FloorHeight) + FloorHeight, ((22.5 - 3.9 - 12.5) * 0.086), (19.5 * 0.08)
    
    Room(i).AddWall GetTex("Wall3"), -70, 46.25, -12.5, 46.25, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((70 - 12.5) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 12.5, 46.25, 70, 46.25, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((70 - 12.5) * 0.086), (5.5 * 0.08)
    
    'Rooms
    Room(i).AddWall GetTex("Wall3"), -135, -110, -90.5, -110, 25, (i * FloorHeight) + FloorHeight, ((135 - 90.5) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), -135, 110, -90.5, 110, 25, (i * FloorHeight) + FloorHeight, ((135 - 90.5) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), -70, -110, 70, -110, 25, (i * FloorHeight) + FloorHeight, ((70 * 2) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), -70, 110, 70, 110, 25, (i * FloorHeight) + FloorHeight, ((70 * 2) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 135, -110, 90.5, -110, 25, (i * FloorHeight) + FloorHeight, ((135 - 90.5) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 135, 110, 90.5, 110, 25, (i * FloorHeight) + FloorHeight, ((135 - 90.5) * 0.086), 1
    
    Room(i).AddWall GetTex("Wall3"), 0, -71.3, 0, -150, 25, (i * FloorHeight) + FloorHeight, ((150 - 71.3) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 0, 71.3, 0, 150, 25, (i * FloorHeight) + FloorHeight, ((150 - 71.3) * 0.086), 1
    
    Next i

End Sub
Sub Process81to114()
    
    'Floors 81 to 114
    For i = 81 To 114
    DoEvents
    Form1.Label2.Caption = "Processing Floors 81 to 114... " + Str$(Int(((i - 81) / (114 - 81)) * 100)) + "%"
    
    'Floor
    Room(i).AddFloor GetTex("Granite"), -110, -150, 110, -46.25, (i * FloorHeight) + FloorHeight, ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -110, 46.25, 110, 150, (i * FloorHeight) + FloorHeight, ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -12.5, -46.25, 12.5, 46.25, (i * FloorHeight) + FloorHeight, ((12.5 * 2) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -110, -46.25, -52.5, 46.25, (i * FloorHeight) + FloorHeight, ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Granite"), 110, -46.25, 52.5, 46.25, (i * FloorHeight) + FloorHeight, ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Ceiling
    Room(i).AddFloor GetTex("Marble3"), -110, -150, 110, -46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -110, 46.25, 110, 150, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -12.5, -46.25, 12.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((12.5 * 2) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -110, -46.25, -52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), 110, -46.25, 52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Crawlspace bottom
    Room(i).AddFloor GetTex("Granite"), -110, -150, 110, -46.25, (i * FloorHeight) + (FloorHeight + 25), ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -110, 46.25, 110, 150, (i * FloorHeight) + (FloorHeight + 25), ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -12.5, -46.25, 12.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((12.5 * 2) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -110, -46.25, -52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Granite"), 110, -46.25, 52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Crawlspace top
    Room(i).AddFloor GetTex("BrickTexture"), -110, -150, 110, -46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -110, 46.25, 110, 150, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -12.5, -46.25, 12.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((12.5 * 2) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -110, -46.25, -52.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), 110, -46.25, 52.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Crawlspace walls
    Room(i).AddWall GetTex("BrickTexture"), -110, -150, 110, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((110 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), 110, -150, 110, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((150 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), 110, 150, -110, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((110 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), -110, 150, -110, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((150 * 2) * 0.086), ((FloorHeight - 25) * 0.08)

    'Stairwell Walls
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -46.25 + 0.1, -12.5 - 0.5, -40.3, (FloorHeight), (i * FloorHeight) + FloorHeight, ((46.25 - 40.3) * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -32.5, -12.5 - 0.5, -30, (FloorHeight), (i * FloorHeight) + FloorHeight, (2.5 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -32.5 + 0.1, -46.25 + 0.1, -32.5 + 0.1, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (16.25 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -46.25 + 0.1, -32.5, -46.25 + 0.1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -30 - 1, -32.5, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 6, -46.25 + 7.71, -12.5 - 16, -46.25 + 7.71, (FloorHeight), (i * FloorHeight) + FloorHeight, (10 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -40.3, -12.5 - 0.5, -30, (FloorHeight - 19.5), 19.5 + (i * FloorHeight) + FloorHeight, (10.3 * 0.086), ((FloorHeight - 19.5) * 0.08)
       
    'If i = 80 Then
    'Call DrawElevatorWalls(Int(i), 2, 1, True, False, True, True, True, True, True, True, True, True, True, True)
    'Call DrawElevatorWalls(Int(i), 2, 2, True, False, True, True, True, True, True, True, True, True, True, True)
    'End If
    If i >= 82 And i <= 98 Then
    Call DrawElevatorWalls(Int(i), 2, 1, True, False, False, False, False, False, False, False, False, False, False, False)
    Call DrawElevatorWalls(Int(i), 2, 2, True, False, False, True, False, False, True, True, True, True, True, True)
    End If
    If i >= 102 And i < 114 Then
    Call DrawElevatorWalls(Int(i), 2, 1, True, False, True, False, False, False, True, True, True, True, True, True)
    Call DrawElevatorWalls(Int(i), 2, 2, True, False, False, False, False, False, False, False, False, False, False, False)
    End If
    If i = 81 Or i = 99 Then
    Call DrawElevatorWalls(Int(i), 2, 1, True, False, False, False, False, False, False, False, False, False, False, False)
    Call DrawElevatorWalls(Int(i), 2, 2, True, False, False, True, False, False, True, True, True, True, True, True)
    End If
    If i = 100 Then
    Call DrawElevatorWalls(Int(i), 2, 1, True, False, False, False, False, False, True, True, True, True, True, True)
    Call DrawElevatorWalls(Int(i), 2, 2, True, False, False, True, False, False, False, False, False, False, False, False)
    End If
    If i = 114 Then
    Call DrawElevatorWalls(Int(i), 2, 1, True, False, True, False, False, False, True, True, True, True, True, True)
    Call DrawElevatorWalls(Int(i), 2, 2, True, False, False, False, False, False, False, False, False, False, False, False)
    End If
    If i = 101 Then
    Call DrawElevatorWalls(Int(i), 2, 1, True, False, True, False, False, False, True, True, True, True, True, True)
    Call DrawElevatorWalls(Int(i), 2, 2, True, False, False, True, False, False, False, False, False, False, False, False)
    End If
    
    'Right Hallways, Right Wall
    Room(i).AddWall GetTex("Wall3"), -70, -150, -70, 150, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((150 * 2) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, -150, -70, -118 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 118 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, -118 + 3.9, -70, -102 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((118 - 102 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, -102 + 3.9, -70, -60 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((102 - 60 - 3.9 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, -60 + 3.9, -70, 27 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((60 - 27 - 3.9 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, 27 + 3.9, -70, 66 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((66 - 27 - 3.9 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, 66 + 3.9, -70, 102 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((102 - 66 - 3.9 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, 102 + 3.9, -70, 116 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((116 - 102 - 3.9 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -70, 116 + 3.9, -70, 150, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 116 - 3.9) * 0.086), (19.5 * 0.08)
    
    'Left Hallways, Left Wall
    Room(i).AddWall GetTex("Wall3"), 70, -150, 70, 150, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((150 * 2) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 70, -150, 70, -118 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 118 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 70, -118 + 3.9, 70, -102 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((118 - 102 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 70, -102 + 3.9, 70, -60 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((102 - 60 - 3.9 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 70, -60 + 3.9, 70, 27 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((60 - 27 - 3.9 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 70, 27 + 3.9, 70, 66 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((66 - 27 - 3.9 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 70, 66 + 3.9, 70, 102 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((102 - 66 - 3.9 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 70, 102 + 3.9, 70, 116 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((116 - 102 - 3.9 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 70, 116 + 3.9, 70, 150, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 116 - 3.9) * 0.086), (19.5 * 0.08)
    
    'center bottom hallway, right wall
    Room(i).AddWall GetTex("Wall3"), -12.5, 150, -12.5, 71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((150 - 71.3) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -12.5, 150, -12.5, 118 + 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 118 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -12.5, 118 - 3.9, -12.5, 102 + 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((118 - 102 - 3.9 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -12.5, 102 - 3.9, -12.5, 71.3, 19.5, (i * FloorHeight) + FloorHeight, ((102 - 71.3 - 3.9) * 0.086), (19.5 * 0.08)
    
    'center bottom hallway, left wall
    Room(i).AddWall GetTex("Wall3"), 12.5, 150, 12.5, 71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((150 * 2) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 12.5, 150, 12.5, 118 + 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 118 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 12.5, 118 - 3.9, 12.5, 102 + 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((118 - 102 - 3.9 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 12.5, 102 - 3.9, 12.5, 71.3, 19.5, (i * FloorHeight) + FloorHeight, ((102 - 71.3 - 3.9) * 0.086), (19.5 * 0.08)
    
    'center top hallway, right wall
    Room(i).AddWall GetTex("Wall3"), -12.5, -150, -12.5, -71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((150 - 71.3) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -12.5, -150, -12.5, -118 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 118 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -12.5, -118 + 3.9, -12.5, -102 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((118 - 102 - 3.9 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), -12.5, -102 + 3.9, -12.5, -71.3, 19.5, (i * FloorHeight) + FloorHeight, ((102 - 71.3 - 3.9) * 0.086), (19.5 * 0.08)
    
    'center top hallway, left wall
    Room(i).AddWall GetTex("Wall3"), 12.5, -150, 12.5, -71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((150 - 71.3) * 0.086), (5.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 12.5, -150, 12.5, -118 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 118 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 12.5, -118 + 3.9, 12.5, -102 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((118 - 102 - 3.9 - 3.9) * 0.086), (19.5 * 0.08)
    Room(i).AddWall GetTex("Wall3"), 12.5, -102 + 3.9, 12.5, -71.3, 19.5, (i * FloorHeight) + FloorHeight, ((102 - 71.3 - 3.9) * 0.086), (19.5 * 0.08)
    
    'Individual Rooms
    Room(i).AddWall GetTex("Wall3"), -110, 110, -70, 110, 25, (i * FloorHeight) + FloorHeight, ((110 - 70) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), -50, 110, -12.5, 110, 25, (i * FloorHeight) + FloorHeight, ((50 - 12.5) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 110, 110, 70, 110, 25, (i * FloorHeight) + FloorHeight, ((110 - 70) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 50, 110, 12.5, 110, 25, (i * FloorHeight) + FloorHeight, ((50 - 12.5) * 0.086), 1
    
    Room(i).AddWall GetTex("Wall3"), -110, 71.3, -70, 71.3, 25, (i * FloorHeight) + FloorHeight, ((110 - 70) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), -50, 71.3, -12.5, 71.3, 25, (i * FloorHeight) + FloorHeight, ((50 - 12.5) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 110, 71.3, 70, 71.3, 25, (i * FloorHeight) + FloorHeight, ((110 - 70) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 12.5, 71.3, 50, 71.3, 25, (i * FloorHeight) + FloorHeight, ((50 - 12.5) * 0.086), 1
    
    Room(i).AddWall GetTex("Wall3"), -110, -110, -70, -110, 25, (i * FloorHeight) + FloorHeight, ((110 - 70) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), -50, -110, -12.5, -110, 25, (i * FloorHeight) + FloorHeight, ((50 - 12.5) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 110, -110, 70, -110, 25, (i * FloorHeight) + FloorHeight, ((110 - 70) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 50, -110, 12.5, -110, 25, (i * FloorHeight) + FloorHeight, ((50 - 12.5) * 0.086), 1
    
    Room(i).AddWall GetTex("Wall3"), -110, -71.3, -70, -71.3, 25, (i * FloorHeight) + FloorHeight, ((110 - 70) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), -50, -71.3, -12.5, -71.3, 25, (i * FloorHeight) + FloorHeight, ((50 - 12.5) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 110, -71.3, 70, -71.3, 25, (i * FloorHeight) + FloorHeight, ((110 - 70) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 12.5, -71.3, 50, -71.3, 25, (i * FloorHeight) + FloorHeight, ((50 - 12.5) * 0.086), 1
    
    Room(i).AddWall GetTex("Wall3"), -110, 46.25, -70, 46.25, 25, (i * FloorHeight) + FloorHeight, ((110 - 70) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 110, 46.25, 70, 46.25, 25, (i * FloorHeight) + FloorHeight, ((110 - 70) * 0.086), 1
    
    'Room(i).AddWall GetTex("Wall3"), -110, 20, -70, 20, 25, (i * FloorHeight) + FloorHeight, 9, 1
    'Room(i).AddWall GetTex("Wall3"), 110, 20, 70, 20, 25, (i * FloorHeight) + FloorHeight, 2, 1
    
    Room(i).AddWall GetTex("Wall3"), -110, -5, -70, -5, 25, (i * FloorHeight) + FloorHeight, ((110 - 70) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 110, -5, 70, -5, 25, (i * FloorHeight) + FloorHeight, ((110 - 70) * 0.086), 1
    
    'Left Bottom Hallway, Right Wall (no doors)
    Room(i).AddWall GetTex("Wall3"), 50, 71.3, 50, 150, 25, (i * FloorHeight) + FloorHeight, ((150 - 71.3) * 0.086), 1
    
    'Right Bottom Hallway, Left Wall (no doors)
    Room(i).AddWall GetTex("Wall3"), -50, 71.3, -50, 150, 25, (i * FloorHeight) + FloorHeight, ((150 - 71.3) * 0.086), 1
    
    'Left Top Hallway, Right Wall (no doors)
    Room(i).AddWall GetTex("Wall3"), 50, -71.3, 50, -150, 25, (i * FloorHeight) + FloorHeight, ((150 - 71.3) * 0.086), 1
    
    'Right Top Hallway, Left Wall (no doors)
    Room(i).AddWall GetTex("Wall3"), -50, -71.3, -50, -150, 25, (i * FloorHeight) + FloorHeight, ((150 - 71.3) * 0.086), 1
    
    Next i

End Sub
Sub Process118to129()
    
    'Floors 118 to 129 (minus 10 feet)
    For i = 118 To 129
    DoEvents
    Form1.Label2.Caption = "Processing Floors 118 to 129... " + Str$(Int(((i - 118) / (129 - 118)) * 100)) + "%"
    
    'Floor
    Room(i).AddFloor GetTex("Granite"), -85, -150, 85, -46.25, (i * FloorHeight) + FloorHeight, ((85 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -85, 46.25, 85, 150, (i * FloorHeight) + FloorHeight, ((85 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -12.5, -46.25, 12.5, 46.25, (i * FloorHeight) + FloorHeight, ((12.5 * 2) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -85, -46.25, -32.5, 46.25, (i * FloorHeight) + FloorHeight, ((85 - 32.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Granite"), 85, -46.25, 32.5, 46.25, (i * FloorHeight) + FloorHeight, ((85 - 32.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Ceiling
    Room(i).AddFloor GetTex("Marble3"), -85, -150, 85, -46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((85 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -85, 46.25, 85, 150, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((85 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -12.5, -46.25, 12.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((12.5 * 2) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -85, -46.25, -32.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((85 - 32.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), 85, -46.25, 32.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((85 - 32.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Crawlspace bottom
    Room(i).AddFloor GetTex("BrickTexture"), -85, -150, 85, -46.25, (i * FloorHeight) + (FloorHeight + 25), ((85 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -85, 46.25, 85, 150, (i * FloorHeight) + (FloorHeight + 25), ((85 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -12.5, -46.25, 12.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((12.5 * 2) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -85, -46.25, -32.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((85 - 32.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), 85, -46.25, 32.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((85 - 32.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Crawlspace top
    Room(i).AddFloor GetTex("BrickTexture"), -85, -150, 85, -46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((85 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -85, 46.25, 85, 150, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((85 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -12.5, -46.25, 12.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((12.5 * 2) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -85, -46.25, -32.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((85 - 32.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), 85, -46.25, 32.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((85 - 32.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Crawlspace walls
    Room(i).AddWall GetTex("BrickTexture"), -85, -150, 85, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((85 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), 85, -150, 85, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((150 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), 85, 150, -85, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((85 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), -85, 150, -85, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((150 * 2) * 0.086), ((FloorHeight - 25) * 0.08)

    'Stairwell Walls
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -46.25 + 0.1, -12.5 - 0.5, -40.3, (FloorHeight), (i * FloorHeight) + FloorHeight, ((46.25 - 40.3) * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -32.5, -12.5 - 0.5, -30, (FloorHeight), (i * FloorHeight) + FloorHeight, (2.5 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -32.5 + 0.1, -46.25 + 0.1, -32.5 + 0.1, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (16.25 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -46.25 + 0.1, -32.5, -46.25 + 0.1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -30 - 1, -32.5, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 6, -46.25 + 7.71, -12.5 - 16, -46.25 + 7.71, (FloorHeight), (i * FloorHeight) + FloorHeight, (10 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -40.3, -12.5 - 0.5, -30, (FloorHeight - 19.5), 19.5 + (i * FloorHeight) + FloorHeight, (10.3 * 0.086), ((FloorHeight - 19.5) * 0.08)
        
    'If i = 118 Or i = 129 Then
    Call DrawElevatorWalls(Int(i), 2, 1, False, True, True, False, False, False, True, True, True, True, True, True)
    'End If
    'If i >= 119 And i <= 128 Then
    'Call DrawElevatorWalls(Int(i), 2, 1, False, True, False, False, False, False, True, True, True, True, True, True)
    'End If
    
    'Room(I) Walls
    Room(i).AddWall GetTex("Wall3"), -60, -71.3, -12.5, -71.3, 25, (i * FloorHeight) + FloorHeight, ((60 - 12.5) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 12.5, -71.3, 60, -71.3, 25, (i * FloorHeight) + FloorHeight, ((60 - 12.5) * 0.086), 1
    
    Room(i).AddWall GetTex("Wall3"), -60, 46.25, -32.5, 46.25, 25, (i * FloorHeight) + FloorHeight, ((60 - 32.5) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 32.5, 46.25, 60, 46.25, 25, (i * FloorHeight) + FloorHeight, ((60 - 32.5) * 0.086), 1
    
    'Room(i).AddWall GetTex("Wall3"), -60, 0, -32.5, 0, 25, (i * FloorHeight) + FloorHeight, 9, 1
    'Room(i).AddWall GetTex("Wall3"), 60, 0, 32.5, 0, 25, (i * FloorHeight) + FloorHeight, 2, 1
    
    Room(i).AddWall GetTex("Wall3"), -60, -46.3, -32.5, -46.3, 25, (i * FloorHeight) + FloorHeight, ((60 - 32.5) * 0.086), 1
    'This wall is cut for the service door
    Room(i).AddWall GetTex("Wall3"), 60, -46.3, 32.5, -46.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((60 - 32.5) * 0.086), 5.5 * 4
    Room(i).AddWall GetTex("Wall3"), 60, -46.3, 39 + 3.9, -46.3, 19.5, (i * FloorHeight) + FloorHeight, ((60 - 39 - 3.9) * 0.086), 19.5 * 4
    Room(i).AddWall GetTex("Wall3"), 39 - 3.9, -46.3, 32.5, -46.3, 19.5, (i * FloorHeight) + FloorHeight, ((39 - 32.5 - 3.9) * 0.086), 19.5 * 4
        
    'Top Horizontal Hallway End Walls
    Room(i).AddWall GetTex("Wall3"), -60, -71.3, -60, -46.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((71.3 - 46.3) * 0.086), 5.5 * 4
    Room(i).AddWall GetTex("Wall3"), -60, -71.3, -60, -60 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((71.3 - 60 - 3.9) * 0.086), 19.5 * 4
    Room(i).AddWall GetTex("Wall3"), -60, -60 + 3.9, -60, -46.3, 19.5, (i * FloorHeight) + FloorHeight, ((60 - 46.3 - 3.9) * 0.086), 19.5 * 4
    Room(i).AddWall GetTex("Wall3"), 60, -71.3, 60, -46.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((71.3 - 46.3) * 0.086), 5.5 * 4
    Room(i).AddWall GetTex("Wall3"), 60, -71.3, 60, -60 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((71.3 - 60 - 3.9) * 0.086), 19.5 * 4
    Room(i).AddWall GetTex("Wall3"), 60, -60 + 3.9, 60, -46.3, 19.5, (i * FloorHeight) + FloorHeight, ((60 - 46.3 - 3.9) * 0.086), 19.5 * 4
    
    'Bottom Horizontal Hallway End Walls
    Room(i).AddWall GetTex("Wall3"), -60, 71.3, -60, 46.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((71.3 - 46.3) * 0.086), 5.5 * 4
    Room(i).AddWall GetTex("Wall3"), -60, 71.3, -60, 60 + 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((71.3 - 60 - 3.9) * 0.086), 19.5 * 4
    Room(i).AddWall GetTex("Wall3"), -60, 60 - 3.9, -60, 46.3, 19.5, (i * FloorHeight) + FloorHeight, ((60 - 46.3 - 3.9) * 0.086), 19.5 * 4
    Room(i).AddWall GetTex("Wall3"), 60, 71.3, 60, 46.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((71.3 - 46.3) * 0.086), 5.5 * 4
    Room(i).AddWall GetTex("Wall3"), 60, 71.3, 60, 60 + 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((71.3 - 60 - 3.9) * 0.086), 19.5 * 4
    Room(i).AddWall GetTex("Wall3"), 60, 60 - 3.9, 60, 46.3, 19.5, (i * FloorHeight) + FloorHeight, ((60 - 46.3 - 3.9) * 0.086), 19.5 * 4
    
    'Bottom Hallway
    Room(i).AddWall GetTex("Wall3"), -12.5, 150, -12.5, 71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((150 - 71.3) * 0.086), 5.5 * 4
    Room(i).AddWall GetTex("Wall3"), -12.5, 150, -12.5, 117 + 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 117 - 3.9) * 0.086), 19.5 * 4
    Room(i).AddWall GetTex("Wall3"), -12.5, 117 - 3.9, -12.5, 101 + 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((117 - 101 - 3.9 - 3.9) * 0.086), 19.5 * 4
    Room(i).AddWall GetTex("Wall3"), -12.5, 101 - 3.9, -12.5, 71.3, 19.5, (i * FloorHeight) + FloorHeight, ((101 - 71.3 - 3.9) * 0.086), 19.5 * 4
    Room(i).AddWall GetTex("Wall3"), 12.5, 150, 12.5, 71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((150 - 71.3) * 0.086), 5.5 * 4
    Room(i).AddWall GetTex("Wall3"), 12.5, 150, 12.5, 117 + 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 117 - 3.9) * 0.086), 19.5 * 4
    Room(i).AddWall GetTex("Wall3"), 12.5, 117 - 3.9, 12.5, 101 + 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((117 - 101 - 3.9 - 3.9) * 0.086), 19.5 * 4
    Room(i).AddWall GetTex("Wall3"), 12.5, 101 - 3.9, 12.5, 71.3, 19.5, (i * FloorHeight) + FloorHeight, ((101 - 71.3 - 3.9) * 0.086), 19.5 * 4
    
    'Top Hallway
    Room(i).AddWall GetTex("Wall3"), -12.5, -150, -12.5, -71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((150 - 71.3) * 0.086), 5.5 * 4
    Room(i).AddWall GetTex("Wall3"), -12.5, -150, -12.5, -117 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 117 - 3.9) * 0.086), 19.5 * 4
    Room(i).AddWall GetTex("Wall3"), -12.5, -117 + 3.9, -12.5, -101 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((117 - 101 - 3.9 - 3.9) * 0.086), 19.5 * 4
    Room(i).AddWall GetTex("Wall3"), -12.5, -101 + 3.9, -12.5, -71.3, 19.5, (i * FloorHeight) + FloorHeight, ((101 - 71.3 - 3.9) * 0.086), 19.5 * 4
    Room(i).AddWall GetTex("Wall3"), 12.5, -150, 12.5, -71.3, 5.5, (i * FloorHeight) + FloorHeight + 19.5, ((150 - 71.3) * 0.086), 5.5 * 4
    Room(i).AddWall GetTex("Wall3"), 12.5, -150, 12.5, -117 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((150 - 117 - 3.9) * 0.086), 19.5 * 4
    Room(i).AddWall GetTex("Wall3"), 12.5, -117 + 3.9, 12.5, -101 - 3.9, 19.5, (i * FloorHeight) + FloorHeight, ((117 - 101 - 3.9 - 3.9) * 0.086), 19.5 * 4
    Room(i).AddWall GetTex("Wall3"), 12.5, -101 + 3.9, 12.5, -71.3, 19.5, (i * FloorHeight) + FloorHeight, ((101 - 71.3 - 3.9) * 0.086), 19.5 * 4
    
    'Individual Rooms
    Room(i).AddWall GetTex("Wall3"), -85, 110, -12.5, 110, 25, (i * FloorHeight) + FloorHeight, ((85 - 12.5) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 85, 110, 12.5, 110, 25, (i * FloorHeight) + FloorHeight, ((85 - 12.5) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), -85, 71.3, -12.5, 71.3, 25, (i * FloorHeight) + FloorHeight, ((85 - 12.5) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 85, 71.3, 12.5, 71.3, 25, (i * FloorHeight) + FloorHeight, ((85 - 12.5) * 0.086), 1
    
    Room(i).AddWall GetTex("Wall3"), -85, -110, -12.5, -110, 25, (i * FloorHeight) + FloorHeight, ((85 - 12.5) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 85, -110, 12.5, -110, 25, (i * FloorHeight) + FloorHeight, ((85 - 12.5) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), -85, -71.3, -60, -71.3, 25, (i * FloorHeight) + FloorHeight, ((85 - 60) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 85, -71.3, 60, -71.3, 25, (i * FloorHeight) + FloorHeight, ((85 - 60) * 0.086), 1
    
    Room(i).AddWall GetTex("Wall3"), -85, 0, -32.5, 0, 25, (i * FloorHeight) + FloorHeight, ((85 - 32.5) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 85, 0, 32.5, 0, 25, (i * FloorHeight) + FloorHeight, ((85 - 32.5) * 0.086), 1
    
    'service room
    Room(i).AddWall GetTex("Wall3"), 50, -46.25, 50, -20, 25, (i * FloorHeight) + FloorHeight, ((46.25 - 20) * 0.086), 1
    Room(i).AddWall GetTex("Wall3"), 50, -20, 32.5, -20, 25, (i * FloorHeight) + FloorHeight, ((50 - 32.5) * 0.086), 1
    
    Next i
    
End Sub

Sub DestroyObjects(Floor As Integer)
'currently, 150 objects per floor (150*138)
For i = (1 + (150 * (Floor - 1))) To (150 + (150 * (Floor - 1)))
'The destroymesh function is broken
On Error Resume Next
Objects(i).Enable False
'Sleep 2
Scene.DestroyMesh Objects(i)
Set Objects(i) = Nothing
Next i

'objectindex + (150 * (currentfloor - 1 ))

End Sub

Sub Init_Objects(Floor As Integer, ObjectIndex As Integer)
'currently, 150 objects per floor (150*138)
i53 = ObjectIndex + (150 * (Floor - 1))
Set Objects(i53) = New TVMesh
Set Objects(i53) = Scene.CreateMeshBuilder("Objects " + Str$(i53))
'MsgBox (Str$(i53))
'objectindex + (150 * (currentfloor - 1 ))
    
End Sub

Sub ProcessOtherFloors()

'Floor 80
    i = 80
    DoEvents
    Form1.Label2.Caption = "Processing Floors 80, 115 to 117 and 130 to 138... " + Str$(Int(((i - 24) / (138 - 24)) * 100)) + "%"
    
    'Floor
    Room(i).AddFloor GetTex("Granite"), -110, -150, 110, -46.25, (i * FloorHeight) + FloorHeight, ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -110, 46.25, 110, 150, (i * FloorHeight) + FloorHeight, ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -12.5, -46.25, 12.5, 46.25, (i * FloorHeight) + FloorHeight, ((12.5 * 2) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -110, -46.25, -52.5, 46.25, (i * FloorHeight) + FloorHeight, ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Granite"), 110, -46.25, 52.5, 46.25, (i * FloorHeight) + FloorHeight, ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Ceiling
    Room(i).AddFloor GetTex("Marble3"), -110, -150, 110, -46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -110, 46.25, 110, 150, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -12.5, -46.25, 12.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((12.5 * 2) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -110, -46.25, -52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), 110, -46.25, 52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Crawlspace bottom
    Room(i).AddFloor GetTex("Granite"), -110, -150, 110, -46.25, (i * FloorHeight) + (FloorHeight + 25), ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -110, 46.25, 110, 150, (i * FloorHeight) + (FloorHeight + 25), ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -12.5, -46.25, 12.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((12.5 * 2) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -110, -46.25, -52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Granite"), 110, -46.25, 52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Crawlspace top
    Room(i).AddFloor GetTex("BrickTexture"), -110, -150, 110, -46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -110, 46.25, 110, 150, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -12.5, -46.25, 12.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((12.5 * 2) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -110, -46.25, -52.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), 110, -46.25, 52.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Crawlspace walls
    Room(i).AddWall GetTex("BrickTexture"), -110, -150, 110, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((110 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), 110, -150, 110, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((150 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), 110, 150, -110, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((110 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), -110, 150, -110, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((150 * 2) * 0.086), ((FloorHeight - 25) * 0.08)

    'Stairwell Walls
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -46.25 + 0.1, -12.5 - 0.5, -40.3, (FloorHeight), (i * FloorHeight) + FloorHeight, ((46.25 - 40.3) * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -32.5, -12.5 - 0.5, -30, (FloorHeight), (i * FloorHeight) + FloorHeight, (2.5 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -32.5 + 0.1, -46.25 + 0.1, -32.5 + 0.1, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (16.25 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -46.25 + 0.1, -32.5, -46.25 + 0.1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -30 - 1, -32.5, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 6, -46.25 + 7.71, -12.5 - 16, -46.25 + 7.71, (FloorHeight), (i * FloorHeight) + FloorHeight, (10 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -40.3, -12.5 - 0.5, -30, (FloorHeight - 19.5), 19.5 + (i * FloorHeight) + FloorHeight, (10.3 * 0.086), ((FloorHeight - 19.5) * 0.08)
       
    Call DrawElevatorWalls(Int(i), 2, 1, True, False, True, True, True, True, True, True, True, True, True, True)
    Call DrawElevatorWalls(Int(i), 2, 2, True, False, True, True, True, True, True, True, True, True, True, True)


'Floor 115
    i = 115
    DoEvents
    Form1.Label2.Caption = "Processing Floors 80, 115 to 117 and 130 to 138... " + Str$(Int(((i - 24) / (138 - 24)) * 100)) + "%"
    
    'Floor
    Room(i).AddFloor GetTex("Granite"), -110, -150, 110, -46.25, (i * FloorHeight) + FloorHeight, ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -110, 46.25, 110, 150, (i * FloorHeight) + FloorHeight, ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -12.5, -46.25, 12.5, 46.25, (i * FloorHeight) + FloorHeight, ((12.5 * 2) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -110, -46.25, -52.5, 46.25, (i * FloorHeight) + FloorHeight, ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Granite"), 110, -46.25, 52.5, 46.25, (i * FloorHeight) + FloorHeight, ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Ceiling
    Room(i).AddFloor GetTex("Marble3"), -110, -150, 110, -46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -110, 46.25, 110, 150, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -12.5, -46.25, 12.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((12.5 * 2) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -110, -46.25, -52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), 110, -46.25, 52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Crawlspace bottom
    Room(i).AddFloor GetTex("Granite"), -110, -150, 110, -46.25, (i * FloorHeight) + (FloorHeight + 25), ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -110, 46.25, 110, 150, (i * FloorHeight) + (FloorHeight + 25), ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -12.5, -46.25, 12.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((12.5 * 2) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -110, -46.25, -52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Granite"), 110, -46.25, 52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Crawlspace top
    Room(i).AddFloor GetTex("BrickTexture"), -110, -150, 110, -46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -110, 46.25, 110, 150, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -12.5, -46.25, 12.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((12.5 * 2) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -110, -46.25, -52.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), 110, -46.25, 52.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Crawlspace walls
    Room(i).AddWall GetTex("BrickTexture"), -110, -150, 110, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((110 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), 110, -150, 110, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((150 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), 110, 150, -110, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((110 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), -110, 150, -110, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((150 * 2) * 0.086), ((FloorHeight - 25) * 0.08)

    'Stairwell Walls
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -46.25 + 0.1, -12.5 - 0.5, -40.3, (FloorHeight), (i * FloorHeight) + FloorHeight, ((46.25 - 40.3) * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -32.5, -12.5 - 0.5, -30, (FloorHeight), (i * FloorHeight) + FloorHeight, (2.5 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -32.5 + 0.1, -46.25 + 0.1, -32.5 + 0.1, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (16.25 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -46.25 + 0.1, -32.5, -46.25 + 0.1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -30 - 1, -32.5, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 6, -46.25 + 7.71, -12.5 - 16, -46.25 + 7.71, (FloorHeight), (i * FloorHeight) + FloorHeight, (10 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -40.3, -12.5 - 0.5, -30, (FloorHeight - 19.5), 19.5 + (i * FloorHeight) + FloorHeight, (10.3 * 0.086), ((FloorHeight - 19.5) * 0.08)
       
    Call DrawElevatorWalls(Int(i), 2, 1, True, False, True, False, False, False, False, False, False, False, False, False)
    Call DrawElevatorWalls(Int(i), 2, 2, True, False, True, True, False, False, False, False, False, False, False, False)
    
    
'Floor 116
    i = 116
    DoEvents
    Form1.Label2.Caption = "Processing Floors 80, 115 to 117 and 130 to 138... " + Str$(Int(((i - 24) / (138 - 24)) * 100)) + "%"
    
    'Floor
    Room(i).AddFloor GetTex("Granite"), -110, -150, 110, -46.25, (i * FloorHeight) + FloorHeight, ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -110, 46.25, 110, 150, (i * FloorHeight) + FloorHeight, ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -12.5, -46.25, 12.5, 46.25, (i * FloorHeight) + FloorHeight, ((12.5 * 2) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -110, -46.25, -52.5, 46.25, (i * FloorHeight) + FloorHeight, ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Granite"), 110, -46.25, 52.5, 46.25, (i * FloorHeight) + FloorHeight, ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Ceiling
    Room(i).AddFloor GetTex("Marble3"), -110, -150, 110, -46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -110, 46.25, 110, 150, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -12.5, -46.25, 12.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((12.5 * 2) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -110, -46.25, -52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), 110, -46.25, 52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Crawlspace bottom
    Room(i).AddFloor GetTex("Granite"), -110, -150, 110, -46.25, (i * FloorHeight) + (FloorHeight + 25), ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -110, 46.25, 110, 150, (i * FloorHeight) + (FloorHeight + 25), ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -12.5, -46.25, 12.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((12.5 * 2) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -110, -46.25, -52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Granite"), 110, -46.25, 52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Crawlspace top
    Room(i).AddFloor GetTex("BrickTexture"), -110, -150, 110, -46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -110, 46.25, 110, 150, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -12.5, -46.25, 12.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((12.5 * 2) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -110, -46.25, -52.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), 110, -46.25, 52.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Crawlspace walls
    Room(i).AddWall GetTex("BrickTexture"), -110, -150, 110, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((110 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), 110, -150, 110, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((150 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), 110, 150, -110, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((110 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), -110, 150, -110, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((150 * 2) * 0.086), ((FloorHeight - 25) * 0.08)

    'Stairwell Walls
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -46.25 + 0.1, -12.5 - 0.5, -40.3, (FloorHeight), (i * FloorHeight) + FloorHeight, ((46.25 - 40.3) * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -32.5, -12.5 - 0.5, -30, (FloorHeight), (i * FloorHeight) + FloorHeight, (2.5 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -32.5 + 0.1, -46.25 + 0.1, -32.5 + 0.1, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (16.25 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -46.25 + 0.1, -32.5, -46.25 + 0.1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -30 - 1, -32.5, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 6, -46.25 + 7.71, -12.5 - 16, -46.25 + 7.71, (FloorHeight), (i * FloorHeight) + FloorHeight, (10 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -40.3, -12.5 - 0.5, -30, (FloorHeight - 19.5), 19.5 + (i * FloorHeight) + FloorHeight, (10.3 * 0.086), ((FloorHeight - 19.5) * 0.08)
       
    Call DrawElevatorWalls(Int(i), 2, 1, True, False, True, False, False, False, False, False, False, False, False, False)
    Call DrawElevatorWalls(Int(i), 2, 2, True, False, True, True, False, False, False, False, False, False, False, False)
  
'Floor 117
    i = 117
    DoEvents
    Form1.Label2.Caption = "Processing Floors 80, 115 to 117 and 130 to 138... " + Str$(Int(((i - 24) / (138 - 24)) * 100)) + "%"
    
    'Floor
    Room(i).AddFloor GetTex("Granite"), -110, -150, 110, -46.25, (i * FloorHeight) + FloorHeight, ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -110, 46.25, 110, 150, (i * FloorHeight) + FloorHeight, ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -12.5, -46.25, 12.5, 46.25, (i * FloorHeight) + FloorHeight, ((12.5 * 2) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -110, -46.25, -52.5, 46.25, (i * FloorHeight) + FloorHeight, ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Granite"), 110, -46.25, 52.5, 46.25, (i * FloorHeight) + FloorHeight, ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Ceiling
    Room(i).AddFloor GetTex("Marble3"), -110, -150, 110, -46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -110, 46.25, 110, 150, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -12.5, -46.25, 12.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((12.5 * 2) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -110, -46.25, -52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), 110, -46.25, 52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Crawlspace bottom
    Room(i).AddFloor GetTex("Granite"), -110, -150, 110, -46.25, (i * FloorHeight) + (FloorHeight + 25), ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -110, 46.25, 110, 150, (i * FloorHeight) + (FloorHeight + 25), ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -12.5, -46.25, 12.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((12.5 * 2) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -110, -46.25, -52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("Granite"), 110, -46.25, 52.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Crawlspace top
    Room(i).AddFloor GetTex("BrickTexture"), -110, -150, 110, -46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -110, 46.25, 110, 150, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((110 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -12.5, -46.25, 12.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((12.5 * 2) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -110, -46.25, -52.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), 110, -46.25, 52.5, 46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((110 - 52.5) * 0.086), ((46.25 * 2) * 0.08)
    
    'Crawlspace walls
    Room(i).AddWall GetTex("BrickTexture"), -110, -150, 110, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((110 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), 110, -150, 110, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((150 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), 110, 150, -110, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((110 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), -110, 150, -110, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((150 * 2) * 0.086), ((FloorHeight - 25) * 0.08)

    'Stairwell Walls
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -46.25 + 0.1, -12.5 - 0.5, -40.3, (FloorHeight), (i * FloorHeight) + FloorHeight, ((46.25 - 40.3) * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -32.5, -12.5 - 0.5, -30, (FloorHeight), (i * FloorHeight) + FloorHeight, (2.5 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -32.5 + 0.1, -46.25 + 0.1, -32.5 + 0.1, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (16.25 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -46.25 + 0.1, -32.5, -46.25 + 0.1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -30 - 1, -32.5, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 6, -46.25 + 7.71, -12.5 - 16, -46.25 + 7.71, (FloorHeight), (i * FloorHeight) + FloorHeight, (10 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -40.3, -12.5 - 0.5, -30, (FloorHeight - 19.5), 19.5 + (i * FloorHeight) + FloorHeight, (10.3 * 0.086), ((FloorHeight - 19.5) * 0.08)
       
    Call DrawElevatorWalls(Int(i), 2, 1, True, False, True, False, False, False, False, False, False, False, False, False)
    Call DrawElevatorWalls(Int(i), 2, 2, True, False, True, True, False, False, False, False, False, False, False, False)
    

'Floor 130
    i = 130
    DoEvents
    Form1.Label2.Caption = "Processing Floors 80, 115 to 117 and 130 to 138... " + Str$(Int(((i - 24) / (138 - 24)) * 100)) + "%"
    
    'Floor
    Room(i).AddFloor GetTex("Granite"), -85, -150, 85, -46.25, (i * FloorHeight) + FloorHeight, ((85 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -85, 0, 85, 150, (i * FloorHeight) + FloorHeight, ((85 * 2) * 0.086), (150 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + FloorHeight, ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -85, -46.25, -32.5, 0, (i * FloorHeight) + FloorHeight, ((85 - 32.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), 85, -46.25, 32.5, 0, (i * FloorHeight) + FloorHeight, ((85 - 32.5) * 0.086), (46.25 * 0.08)
    
    'Ceiling
    Room(i).AddFloor GetTex("Marble3"), -85, -150, 85, -46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((85 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -85, 0, 85, 150, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((85 * 2) * 0.086), (150 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -85, -46.25, -32.5, 0, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((85 - 32.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), 85, -46.25, 32.5, 0, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((85 - 32.5) * 0.086), (46.25 * 0.08)
    
    'Crawlspace Bottom
    Room(i).AddFloor GetTex("Granite"), -85, -150, 85, -46.25, (i * FloorHeight) + (FloorHeight + 25), ((85 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -85, 0, 85, 150, (i * FloorHeight) + (FloorHeight + 25), ((85 * 2) * 0.086), (150 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + (FloorHeight + 25), ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -85, -46.25, -32.5, 0, (i * FloorHeight) + (FloorHeight + 25), ((85 - 32.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), 85, -46.25, 32.5, 0, (i * FloorHeight) + (FloorHeight + 25), ((85 - 32.5) * 0.086), (46.25 * 0.08)
    
    'Crawlspace Top
    Room(i).AddFloor GetTex("Marble3"), -85, -150, 85, -46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((85 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -85, 0, 85, 150, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((85 * 2) * 0.086), (150 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -85, -46.25, -32.5, 0, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((85 - 32.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), 85, -46.25, 32.5, 0, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((85 - 32.5) * 0.086), (46.25 * 0.08)
    
    'Crawlspace Walls
    Room(i).AddWall GetTex("BrickTexture"), -85, -150, 85, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((85 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), 85, -150, 85, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((150 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), 85, 150, -85, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((85 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), -85, 150, -85, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((150 * 2) * 0.086), ((FloorHeight - 25) * 0.08)

    'Stairwell Walls
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -46.25 + 0.1, -12.5 - 0.5, -40.3, (FloorHeight), (i * FloorHeight) + FloorHeight, ((46.25 - 40.3) * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -32.5, -12.5 - 0.5, -30, (FloorHeight), (i * FloorHeight) + FloorHeight, (2.5 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -32.5 + 0.1, -46.25 + 0.1, -32.5 + 0.1, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (16.25 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -46.25 + 0.1, -32.5, -46.25 + 0.1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -30 - 1, -32.5, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 6, -46.25 + 7.71, -12.5 - 16, -46.25 + 7.71, (FloorHeight), (i * FloorHeight) + FloorHeight, (10 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -40.3, -12.5 - 0.5, -30, (FloorHeight - 19.5), 19.5 + (i * FloorHeight) + FloorHeight, (10.3 * 0.086), ((FloorHeight - 19.5) * 0.08)
        
    Call DrawElevatorWalls(Int(i), 5, 1, False, False, True, False, False, False, False, False, False, False, False, False)
    
    
End Sub

Function GetVar(Location As Integer, Index As Integer) As Integer
'This function loads lines from a data file, and returns the desired value
Dim TempString As String
Dim CurrentIndex As Integer
Dim StringStart As Integer
Dim StringEnd As Integer
Dim GetVarTemp As String
CurrentIndex = 0
Open FileName For Random As #1
Get #1, Location, TempString
Close #1
For i = 1 To Len(TempString)
If Mid$(TempString, i, 1) = "," Then CurrentIndex = CurrentIndex + 1
If CurrentIndex = Index - 1 Then GoTo GetVar2
Next i
GetVar2:

If CurrentIndex > 0 Then StringStart = i + 1 Else StringStart = i
    For j = StringStart To Len(TempString) + 1
    If Mid$(TempString, j, 1) = "," Or j = Len(TempString) Then StringEnd = j + 1
    Next j
GetVarTemp = Mid$(TempString, StringStart, StringEnd - StringStart)
GetVar = Val(GetVarTemp)

End Function


Sub OpenDoor()
OpeningDoor = OpeningDoor + 1

'DoorRotated values:
'0 is horizontal, opens downward
'1 is vertical, opens to the left
'2 is horizontal, opens upward
'3 is vertical, opens to the right
On Error Resume Next

Objects(DoorNumber).RotateY (OpeningDoor / 110)
If DoorRotated = 0 Then Objects(DoorNumber).SetPosition Objects(DoorNumber).GetPosition.X + (OpeningDoor / 48), Objects(DoorNumber).GetPosition.Y, Objects(DoorNumber).GetPosition.z + (OpeningDoor / 38)
If DoorRotated = 1 Then Objects(DoorNumber).SetPosition Objects(DoorNumber).GetPosition.X + (OpeningDoor / 38), Objects(DoorNumber).GetPosition.Y, Objects(DoorNumber).GetPosition.z - (OpeningDoor / 48)
If DoorRotated = 2 Then Objects(DoorNumber).SetPosition Objects(DoorNumber).GetPosition.X - (OpeningDoor / 48), Objects(DoorNumber).GetPosition.Y, Objects(DoorNumber).GetPosition.z - (OpeningDoor / 38)
If DoorRotated = 3 Then Objects(DoorNumber).SetPosition Objects(DoorNumber).GetPosition.X - (OpeningDoor / 38), Objects(DoorNumber).GetPosition.Y, Objects(DoorNumber).GetPosition.z + (OpeningDoor / 48)

If OpeningDoor = 17 Then
    OpeningDoor = 0
    If DoorRotated = 0 Then Objects(DoorNumber).SetMeshName ("DoorAO " + Str$(DoorNumber))
    If DoorRotated = 1 Then Objects(DoorNumber).SetMeshName ("DoorBO " + Str$(DoorNumber))
    If DoorRotated = 2 Then Objects(DoorNumber).SetMeshName ("DoorCO " + Str$(DoorNumber))
    If DoorRotated = 3 Then Objects(DoorNumber).SetMeshName ("DoorDO " + Str$(DoorNumber))
End If
End Sub

Sub OpenStairDoor()
OpeningDoor = OpeningDoor + 1
CallingStairDoors = True

'DoorRotated values:
'0 is horizontal, opens downward
'1 is vertical, opens to the left
'2 is horizontal, opens upward
'3 is vertical, opens to the right
On Error Resume Next

If Room(CameraFloor).IsMeshEnabled = False Then
Room(CameraFloor).Enable True
      For i51 = 1 To 40
      ElevatorDoorL(i51).Enable True
      ElevatorDoorL(i51).Enable True
      Next i51
      ShaftsFloor(CameraFloor).Enable True
      For i51 = 1 To 40
      CallButtons(i51).Enable True
      Next i51
      Stairs(CameraFloor).Enable True
      Atmos.SkyBox_Enable True
      Call InitRealtime(CameraFloor)
      InitObjectsForFloor (CameraFloor)
End If

StairDoor(DoorNumber).RotateY (OpeningDoor / 110)
StairDoor(DoorNumber).SetPosition StairDoor(DoorNumber).GetPosition.X + (OpeningDoor / 38), StairDoor(DoorNumber).GetPosition.Y, StairDoor(DoorNumber).GetPosition.z - (OpeningDoor / 48)

If OpeningDoor = 17 Then
    CallingStairDoors = False
    OpeningDoor = 0
    StairDoor(DoorNumber).SetMeshName ("DoorSBO " + Str$(DoorNumber))
End If
End Sub

Sub CloseDoor()
ClosingDoor = ClosingDoor - 1
On Error Resume Next
Objects(DoorNumber).RotateY -(ClosingDoor / 110)
If DoorRotated = 0 Then Objects(DoorNumber).SetPosition Objects(DoorNumber).GetPosition.X - (ClosingDoor / 48), Objects(DoorNumber).GetPosition.Y, Objects(DoorNumber).GetPosition.z - (ClosingDoor / 38)
If DoorRotated = 1 Then Objects(DoorNumber).SetPosition Objects(DoorNumber).GetPosition.X - (ClosingDoor / 38), Objects(DoorNumber).GetPosition.Y, Objects(DoorNumber).GetPosition.z + (ClosingDoor / 48)
If DoorRotated = 2 Then Objects(DoorNumber).SetPosition Objects(DoorNumber).GetPosition.X + (ClosingDoor / 48), Objects(DoorNumber).GetPosition.Y, Objects(DoorNumber).GetPosition.z + (ClosingDoor / 38)
If DoorRotated = 3 Then Objects(DoorNumber).SetPosition Objects(DoorNumber).GetPosition.X + (ClosingDoor / 38), Objects(DoorNumber).GetPosition.Y, Objects(DoorNumber).GetPosition.z - (ClosingDoor / 48)

If ClosingDoor = 0 And DoorRotated = 0 Then Objects(DoorNumber).SetMeshName ("DoorA " + Str$(DoorNumber))
If ClosingDoor = 0 And DoorRotated = 1 Then Objects(DoorNumber).SetMeshName ("DoorB " + Str$(DoorNumber))
If ClosingDoor = 0 And DoorRotated = 2 Then Objects(DoorNumber).SetMeshName ("DoorC " + Str$(DoorNumber))
If ClosingDoor = 0 And DoorRotated = 3 Then Objects(DoorNumber).SetMeshName ("DoorD " + Str$(DoorNumber))

End Sub

Sub CloseStairDoor()
ClosingDoor = ClosingDoor - 1
CallingStairDoors = True
On Error Resume Next
StairDoor(DoorNumber).RotateY -(ClosingDoor / 110)
StairDoor(DoorNumber).SetPosition StairDoor(DoorNumber).GetPosition.X - (ClosingDoor / 38), StairDoor(DoorNumber).GetPosition.Y, StairDoor(DoorNumber).GetPosition.z + (ClosingDoor / 48)

If ClosingDoor = 0 Then
StairDoor(DoorNumber).SetMeshName ("DoorB " + Str$(DoorNumber))
CallingStairDoors = False
End If

End Sub


Sub ProcessOtherFloors2()

'Floor 131
    i = 131
    DoEvents
    Form1.Label2.Caption = "Processing Floors 80, 115 to 117 and 130 to 138... " + Str$(Int(((i - 24) / (138 - 24)) * 100)) + "%"
    
    'Floor
    Room(i).AddFloor GetTex("Granite"), -85, -150, 85, -46.25, (i * FloorHeight) + FloorHeight, ((85 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -85, 0, 85, 150, (i * FloorHeight) + FloorHeight, ((85 * 2) * 0.086), (150 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + FloorHeight, ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -85, -46.25, -32.5, 0, (i * FloorHeight) + FloorHeight, ((85 - 32.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), 85, -46.25, 32.5, 0, (i * FloorHeight) + FloorHeight, ((85 - 32.5) * 0.086), (46.25 * 0.08)
    
    'Ceiling
    Room(i).AddFloor GetTex("Marble3"), -85, -150, 85, -46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((85 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -85, 0, 85, 150, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((85 * 2) * 0.086), (150 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -85, -46.25, -32.5, 0, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((85 - 32.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), 85, -46.25, 32.5, 0, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((85 - 32.5) * 0.086), (46.25 * 0.08)
    
    'Crawlspace Bottom
    Room(i).AddFloor GetTex("Granite"), -85, -150, 85, -46.25, (i * FloorHeight) + (FloorHeight + 25), ((85 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -85, 0, 85, 150, (i * FloorHeight) + (FloorHeight + 25), ((85 * 2) * 0.086), (150 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + (FloorHeight + 25), ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -85, -46.25, -32.5, 0, (i * FloorHeight) + (FloorHeight + 25), ((85 - 32.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), 85, -46.25, 32.5, 0, (i * FloorHeight) + (FloorHeight + 25), ((85 - 32.5) * 0.086), (46.25 * 0.08)
    
    'Crawlspace Top
    Room(i).AddFloor GetTex("Marble3"), -85, -150, 85, -46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((85 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -85, 0, 85, 150, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((85 * 2) * 0.086), (150 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -85, -46.25, -32.5, 0, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((85 - 32.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), 85, -46.25, 32.5, 0, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((85 - 32.5) * 0.086), (46.25 * 0.08)
    
    'Crawlspace Walls
    Room(i).AddWall GetTex("BrickTexture"), -85, -150, 85, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((85 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), 85, -150, 85, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((150 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), 85, 150, -85, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((85 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), -85, 150, -85, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((150 * 2) * 0.086), ((FloorHeight - 25) * 0.08)

    'Stairwell Walls
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -46.25 + 0.1, -12.5 - 0.5, -40.3, (FloorHeight), (i * FloorHeight) + FloorHeight, ((46.25 - 40.3) * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -32.5, -12.5 - 0.5, -30, (FloorHeight), (i * FloorHeight) + FloorHeight, (2.5 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -32.5 + 0.1, -46.25 + 0.1, -32.5 + 0.1, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (16.25 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -46.25 + 0.1, -32.5, -46.25 + 0.1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -30 - 1, -32.5, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 6, -46.25 + 7.71, -12.5 - 16, -46.25 + 7.71, (FloorHeight), (i * FloorHeight) + FloorHeight, (10 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -40.3, -12.5 - 0.5, -30, (FloorHeight - 19.5), 19.5 + (i * FloorHeight) + FloorHeight, (10.3 * 0.086), ((FloorHeight - 19.5) * 0.08)
        
    Call DrawElevatorWalls(Int(i), 5, 1, False, False, True, False, False, False, False, False, False, False, False, False)
    
    
'Floor 132
    i = 132
    DoEvents
    Form1.Label2.Caption = "Processing Floors 80, 115 to 117 and 130 to 138... " + Str$(Int(((i - 24) / (138 - 24)) * 100)) + "%"
    
    'Floor
    Room(i).AddFloor GetTex("Granite"), -85, -150, 85, -46.25, (i * FloorHeight) + FloorHeight, ((85 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -85, 0, 85, 150, (i * FloorHeight) + FloorHeight, ((85 * 2) * 0.086), (150 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + FloorHeight, ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -85, -46.25, -32.5, 0, (i * FloorHeight) + FloorHeight, ((85 - 32.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), 85, -46.25, 32.5, 0, (i * FloorHeight) + FloorHeight, ((85 - 32.5) * 0.086), (46.25 * 0.08)
    
    'Ceiling
    Room(i).AddFloor GetTex("Marble3"), -85, -150, 85, -46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((85 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -85, 0, 85, 150, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((85 * 2) * 0.086), (150 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -85, -46.25, -32.5, 0, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((85 - 32.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), 85, -46.25, 32.5, 0, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((85 - 32.5) * 0.086), (46.25 * 0.08)
    
    'Crawlspace Bottom
    Room(i).AddFloor GetTex("Granite"), -85, -150, 85, -46.25, (i * FloorHeight) + (FloorHeight + 25), ((85 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -85, 0, 85, 150, (i * FloorHeight) + (FloorHeight + 25), ((85 * 2) * 0.086), (150 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + (FloorHeight + 25), ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -85, -46.25, -32.5, 0, (i * FloorHeight) + (FloorHeight + 25), ((85 - 32.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), 85, -46.25, 32.5, 0, (i * FloorHeight) + (FloorHeight + 25), ((85 - 32.5) * 0.086), (46.25 * 0.08)
    
    'Crawlspace Top
    Room(i).AddFloor GetTex("Marble3"), -85, -150, 85, -46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((85 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -85, 0, 85, 150, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((85 * 2) * 0.086), (150 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -85, -46.25, -32.5, 0, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((85 - 32.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), 85, -46.25, 32.5, 0, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((85 - 32.5) * 0.086), (46.25 * 0.08)
    
    'Crawlspace Walls
    Room(i).AddWall GetTex("BrickTexture"), -85, -150, 85, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((85 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), 85, -150, 85, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((150 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), 85, 150, -85, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((85 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), -85, 150, -85, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((150 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
 
    'Stairwell Walls
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -46.25 + 0.1, -12.5 - 0.5, -40.3, (FloorHeight), (i * FloorHeight) + FloorHeight, ((46.25 - 40.3) * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -32.5, -12.5 - 0.5, -30, (FloorHeight), (i * FloorHeight) + FloorHeight, (2.5 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -32.5 + 0.1, -46.25 + 0.1, -32.5 + 0.1, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (16.25 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -46.25 + 0.1, -32.5, -46.25 + 0.1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -30 - 1, -32.5, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 6, -46.25 + 7.71, -12.5 - 16, -46.25 + 7.71, (FloorHeight), (i * FloorHeight) + FloorHeight, (10 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -40.3, -12.5 - 0.5, -30, (FloorHeight - 19.5), 19.5 + (i * FloorHeight) + FloorHeight, (10.3 * 0.086), ((FloorHeight - 19.5) * 0.08)
        
    Call DrawElevatorWalls(Int(i), 5, 1, False, False, True, True, True, True, False, False, False, False, False, False)
    
    
'Floor 133
    i = 133
    DoEvents
    Form1.Label2.Caption = "Processing Floors 80, 115 to 117 and 130 to 138... " + Str$(Int(((i - 24) / (138 - 24)) * 100)) + "%"
    
    'Floor
    Room(i).AddFloor GetTex("Granite"), -85, -150, 85, -46.25, (i * FloorHeight) + FloorHeight, ((85 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -85, 0, 85, 150, (i * FloorHeight) + FloorHeight, ((85 * 2) * 0.086), (150 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + FloorHeight, ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -85, -46.25, -32.5, 0, (i * FloorHeight) + FloorHeight, ((85 - 32.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), 85, -46.25, 32.5, 0, (i * FloorHeight) + FloorHeight, ((85 - 32.5) * 0.086), (46.25 * 0.08)
    
    'Ceiling
    Room(i).AddFloor GetTex("Marble3"), -85, -150, 85, -46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((85 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -85, 0, 85, 150, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((85 * 2) * 0.086), (150 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -85, -46.25, -32.5, 0, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((85 - 32.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), 85, -46.25, 32.5, 0, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((85 - 32.5) * 0.086), (46.25 * 0.08)
    
    'Crawlspace Bottom
    Room(i).AddFloor GetTex("Granite"), -85, -150, 85, -46.25, (i * FloorHeight) + (FloorHeight + 25), ((85 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -85, 0, 85, 150, (i * FloorHeight) + (FloorHeight + 25), ((85 * 2) * 0.086), (150 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + (FloorHeight + 25), ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -85, -46.25, -32.5, 0, (i * FloorHeight) + (FloorHeight + 25), ((85 - 32.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), 85, -46.25, 32.5, 0, (i * FloorHeight) + (FloorHeight + 25), ((85 - 32.5) * 0.086), (46.25 * 0.08)
    
    'Crawlspace Top
    Room(i).AddFloor GetTex("Marble3"), -85, -150, 85, -46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((85 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -85, 0, 85, 150, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((85 * 2) * 0.086), (150 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -85, -46.25, -32.5, 0, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((85 - 32.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), 85, -46.25, 32.5, 0, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((85 - 32.5) * 0.086), (46.25 * 0.08)
    
    'Crawlspace Walls
    Room(i).AddWall GetTex("BrickTexture"), -85, -150, 85, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((85 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), 85, -150, 85, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((150 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), 85, 150, -85, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((85 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), -85, 150, -85, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((150 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
 
    'Stairwell Walls
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -46.25 + 0.1, -12.5 - 0.5, -40.3, (FloorHeight), (i * FloorHeight) + FloorHeight, ((46.25 - 40.3) * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -32.5, -12.5 - 0.5, -30, (FloorHeight), (i * FloorHeight) + FloorHeight, (2.5 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -32.5 + 0.1, -46.25 + 0.1, -32.5 + 0.1, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (16.25 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -46.25 + 0.1, -32.5, -46.25 + 0.1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -30 - 1, -32.5, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 6, -46.25 + 7.71, -12.5 - 16, -46.25 + 7.71, (FloorHeight), (i * FloorHeight) + FloorHeight, (10 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -40.3, -12.5 - 0.5, -30, (FloorHeight - 19.5), 19.5 + (i * FloorHeight) + FloorHeight, (10.3 * 0.086), ((FloorHeight - 19.5) * 0.08)
    
    Call DrawElevatorWalls(Int(i), 5, 1, False, False, True, False, False, False, False, False, False, False, False, False)
    
    'Room(I) Walls
    Room(i).AddWall GetTex("Wall3"), -85, 60, 85, 60, 25, (i * FloorHeight) + FloorHeight, 9, 1
        

'Floor 134
    i = 134
    DoEvents
    Form1.Label2.Caption = "Processing Floors 80, 115 to 117 and 130 to 138... " + Str$(Int(((i - 24) / (138 - 24)) * 100)) + "%"
    
    Room(i).AddFloor GetTex("Granite"), -85, -150, 85, -46.25, (i * FloorHeight) + FloorHeight, 10, 3
    Room(i).AddFloor GetTex("Granite"), -85, -46.25, -32.5, 0, (i * FloorHeight) + FloorHeight, 3, 3
    Room(i).AddFloor GetTex("Granite"), 32.5, -46.25, 85, 0, (i * FloorHeight) + FloorHeight, 3, 3
    Room(i).AddFloor GetTex("Granite"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + FloorHeight, 1, 3
    
    'modified floor for pool
    Room(i).AddFloor GetTex("Granite"), -50, 0, 50, 60, (i * FloorHeight) + FloorHeight, 10, 3
    Room(i).AddFloor GetTex("Granite"), -85, 0, -50, 150, (i * FloorHeight) + FloorHeight, 10, 3
    Room(i).AddFloor GetTex("Granite"), 50, 0, 85, 150, (i * FloorHeight) + FloorHeight, 10, 3
    
    Room(i).AddFloor GetTex("Marble3"), -85, -150, 85, -46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, 10, 3
    Room(i).AddFloor GetTex("Marble3"), -85, 0, 85, 150, (i * FloorHeight) + (FloorHeight + 25) - 0.5, 10, 3
    Room(i).AddFloor GetTex("Marble3"), -85, -46.25, -32.5, 0, (i * FloorHeight) + (FloorHeight + 25) - 0.5, 3, 3
    Room(i).AddFloor GetTex("Marble3"), 32.5, -46.25, 85, 0, (i * FloorHeight) + (FloorHeight + 25) - 0.5, 3, 3
    Room(i).AddFloor GetTex("Marble3"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + (FloorHeight + 25) - 0.5, 1, 3
     
    'Stairwell Walls
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -46.25 + 0.1, -12.5 - 0.5, -40.3, (FloorHeight), (i * FloorHeight) + FloorHeight, ((46.25 - 40.3) * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -32.5, -12.5 - 0.5, -30, (FloorHeight), (i * FloorHeight) + FloorHeight, (2.5 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -32.5 + 0.1, -46.25 + 0.1, -32.5 + 0.1, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (16.25 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -46.25 + 0.1, -32.5, -46.25 + 0.1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -30 - 1, -32.5, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 6, -46.25 + 7.71, -12.5 - 16, -46.25 + 7.71, (FloorHeight), (i * FloorHeight) + FloorHeight, (10 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -40.3, -12.5 - 0.5, -30, (FloorHeight - 19.5), 19.5 + (i * FloorHeight) + FloorHeight, (10.3 * 0.086), ((FloorHeight - 19.5) * 0.08)
    
    Call DrawElevatorWalls(Int(i), 5, 1, False, False, True, True, True, True, False, False, False, False, False, False)
       

'Floor 135
    i = 135
    DoEvents
    Form1.Label2.Caption = "Processing Floors 80, 115 to 117 and 130 to 138... " + Str$(Int(((i - 24) / (138 - 24)) * 100)) + "%"
    
    'Floor
    Room(i).AddFloor GetTex("Granite"), -60, -150, 60, -46.25, (i * FloorHeight) + FloorHeight, ((60 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -60, 0, 60, 150, (i * FloorHeight) + FloorHeight, ((60 * 2) * 0.086), (150 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + FloorHeight, ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -60, -46.25, -32.5, 0, (i * FloorHeight) + FloorHeight, ((60 - 32.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), 60, -46.25, 32.5, 0, (i * FloorHeight) + FloorHeight, ((60 - 32.5) * 0.086), (46.25 * 0.08)
    
    'Ceiling
    Room(i).AddFloor GetTex("Marble3"), -60, -150, 60, -46.25, (i * FloorHeight) + (FloorHeight * 2) - 0.5, ((60 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -60, 0, 60, 15, (i * FloorHeight) + (FloorHeight * 2) - 0.5, ((60 * 2) * 0.086), (15 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + (FloorHeight * 2) - 0.5, ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -60, -46.25, -32.5, 0, (i * FloorHeight) + (FloorHeight * 2) - 0.5, ((60 - 32.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), 60, -46.25, 32.5, 0, (i * FloorHeight) + (FloorHeight * 2) - 0.5, ((60 - 32.5) * 0.086), (46.25 * 0.08)
    
    'Stairwell Walls
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -46.25 + 0.1, -12.5 - 0.5, -40.3, (FloorHeight), (i * FloorHeight) + FloorHeight, ((46.25 - 40.3) * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -32.5, -12.5 - 0.5, -30, (FloorHeight), (i * FloorHeight) + FloorHeight, (2.5 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -32.5 + 0.1, -46.25 + 0.1, -32.5 + 0.1, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (16.25 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -46.25 + 0.1, -32.5, -46.25 + 0.1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -30 - 1, -32.5, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 6, -46.25 + 7.71, -12.5 - 16, -46.25 + 7.71, (FloorHeight), (i * FloorHeight) + FloorHeight, (10 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -40.3, -12.5 - 0.5, -30, (FloorHeight - 19.5), 19.5 + (i * FloorHeight) + FloorHeight, (10.3 * 0.086), ((FloorHeight - 19.5) * 0.08)
        
    Call DrawElevatorWalls(Int(i), 5, 1, False, False, True, True, True, True, False, False, False, False, False, False)
         

'Floor 136
    i = 136
    DoEvents
    Form1.Label2.Caption = "Processing Floors 80, 115 to 117 and 130 to 138... " + Str$(Int(((i - 24) / (138 - 24)) * 100)) + "%"
    
    'Floor
    Room(i).AddFloor GetTex("Granite"), -60, -150, 60, -46.25, (i * FloorHeight) + FloorHeight, ((60 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -60, 0, 60, 15, (i * FloorHeight) + FloorHeight, ((60 * 2) * 0.086), (15 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + FloorHeight, ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -60, -46.25, -32.5, 0, (i * FloorHeight) + FloorHeight, ((60 - 32.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), 60, -46.25, 32.5, 0, (i * FloorHeight) + FloorHeight, ((60 - 32.5) * 0.086), (46.25 * 0.08)
    
    'Ceiling
    Room(i).AddFloor GetTex("Marble3"), -60, -150, 60, -46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((60 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -60, 0, 60, 150, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((60 * 2) * 0.086), (150 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -60, -46.25, -32.5, 0, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((60 - 32.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), 60, -46.25, 32.5, 0, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((60 - 32.5) * 0.086), (46.25 * 0.08)
    
    'Crawlspace Bottom
    Room(i).AddFloor GetTex("Granite"), -60, -150, 60, -46.25, (i * FloorHeight) + (FloorHeight + 25), ((60 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Granite"), -60, 0, 60, 15, (i * FloorHeight) + (FloorHeight + 25), ((60 * 2) * 0.086), (15 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + (FloorHeight + 25), ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), -60, -46.25, -32.5, 0, (i * FloorHeight) + (FloorHeight + 25), ((60 - 32.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Granite"), 60, -46.25, 32.5, 0, (i * FloorHeight) + (FloorHeight + 25), ((60 - 32.5) * 0.086), (46.25 * 0.08)
    
    'Crawlspace Top
    Room(i).AddFloor GetTex("Marble3"), -60, -150, 60, -46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((60 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -60, 0, 60, 150, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((60 * 2) * 0.086), (150 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), -60, -46.25, -32.5, 0, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((60 - 32.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("Marble3"), 60, -46.25, 32.5, 0, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((60 - 32.5) * 0.086), (46.25 * 0.08)
    
    'Crawlspace Walls
    Room(i).AddWall GetTex("BrickTexture"), -60, -150, 60, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((60 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), 60, -150, 60, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((150 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), 60, 150, -60, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((60 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), -60, 150, -60, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((150 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
 
    'Stairwell Walls
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -46.25 + 0.1, -12.5 - 0.5, -40.3, (FloorHeight), (i * FloorHeight) + FloorHeight, ((46.25 - 40.3) * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -32.5, -12.5 - 0.5, -30, (FloorHeight), (i * FloorHeight) + FloorHeight, (2.5 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -32.5 + 0.1, -46.25 + 0.1, -32.5 + 0.1, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (16.25 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -46.25 + 0.1, -32.5, -46.25 + 0.1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -30 - 1, -32.5, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 6, -46.25 + 7.71, -12.5 - 16, -46.25 + 7.71, (FloorHeight), (i * FloorHeight) + FloorHeight, (10 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -40.3, -12.5 - 0.5, -30, (FloorHeight - 19.5), 19.5 + (i * FloorHeight) + FloorHeight, (10.3 * 0.086), ((FloorHeight - 19.5) * 0.08)
        
    Call DrawElevatorWalls(Int(i), 5, 1, False, False, True, True, True, True, False, False, False, False, False, False)
   
    
'Floor 137
    i = 137
    DoEvents
    Form1.Label2.Caption = "Processing Floors 80, 115 to 117 and 130 to 138... " + Str$(Int(((i - 24) / (138 - 24)) * 100)) + "%"
    
    'Floor
    Room(i).AddFloor GetTex("BrickTexture"), -60, -150, 60, -46.25, (i * FloorHeight) + FloorHeight, ((60 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -60, 0, 60, 150, (i * FloorHeight) + FloorHeight, ((60 * 2) * 0.086), (150 * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + FloorHeight, ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -52.5, 0, 12.5, 46.25, (i * FloorHeight) + FloorHeight, ((52.5 - 12.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -60, -46.25, -32.5, 0, (i * FloorHeight) + FloorHeight, ((60 - 32.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), 60, -46.25, 32.5, 0, (i * FloorHeight) + FloorHeight, ((60 - 32.5) * 0.086), (46.25 * 0.08)
    
    'Ceiling
    Room(i).AddFloor GetTex("BrickTexture"), -60, -150, 60, -46.25, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((60 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -60, 0, 60, 150, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((60 * 2) * 0.086), (150 * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -12.5, -46.25, 32.5, 0, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -60, -46.25, -32.5, 0, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((60 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), 60, -46.25, 32.5, 0, (i * FloorHeight) + (FloorHeight + 25) - 0.5, ((60 * 2) * 0.086), (46.25 * 0.08)
    
    'Crawlspace Bottom
    Room(i).AddFloor GetTex("BrickTexture"), -60, -150, 60, -46.25, (i * FloorHeight) + (FloorHeight + 25), ((60 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -60, 0, 60, 150, (i * FloorHeight) + (FloorHeight + 25), ((60 * 2) * 0.086), (150 * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -12.5, -46.25, 12.5, 0, (i * FloorHeight) + (FloorHeight + 25), ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -52.5, 0, 12.5, 46.25, (i * FloorHeight) + (FloorHeight + 25), ((52.5 - 12.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -60, -46.25, -32.5, 0, (i * FloorHeight) + (FloorHeight + 25), ((60 - 32.5) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), 60, -46.25, 32.5, 0, (i * FloorHeight) + (FloorHeight + 25), ((60 - 32.5) * 0.086), (46.25 * 0.08)
    
    'Crawlspace Top
    Room(i).AddFloor GetTex("BrickTexture"), -60, -150, 60, -46.25, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((60 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -60, 0, 60, 150, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((60 * 2) * 0.086), (150 * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -12.5, -46.25, 32.5, 0, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((12.5 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -60, -46.25, -32.5, 0, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((60 * 2) * 0.086), (46.25 * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), 60, -46.25, 32.5, 0, (i * FloorHeight) + (FloorHeight + 24.9) + (FloorHeight - 25), ((60 * 2) * 0.086), (46.25 * 0.08)
    
    'Crawlspace Walls
    Room(i).AddWall GetTex("BrickTexture"), -60, -150, 60, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((60 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), 60, -150, 60, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((150 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), 60, 150, -60, 150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((60 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
    Room(i).AddWall GetTex("BrickTexture"), -60, 150, -60, -150, (FloorHeight - 25), (i * FloorHeight) + FloorHeight + 25, ((150 * 2) * 0.086), ((FloorHeight - 25) * 0.08)
 
    Room(i).AddWall GetTex("BrickTexture"), -60 + 0.1, -150 + 0.1, 60 - 0.1, -150 + 0.1, 25, (i * FloorHeight) + FloorHeight, 3, 1
    Room(i).AddWall GetTex("BrickTexture"), 60 - 0.1, -150 + 0.1, 60 - 0.1, 150 - 0.1, 25, (i * FloorHeight) + FloorHeight, 7, 1
    Room(i).AddWall GetTex("BrickTexture"), 60 - 0.1, 150 - 0.1, -60 + 0.1, 150 - 0.1, 25, (i * FloorHeight) + FloorHeight, 3, 1
    Room(i).AddWall GetTex("BrickTexture"), -60 + 0.1, 150 - 0.1, -60 + 0.1, -150 + 0.1, 25, (i * FloorHeight) + FloorHeight, 7, 1
    
    'Stairwell Walls
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -46.25 + 0.1, -12.5 - 0.5, -40.3, (FloorHeight), (i * FloorHeight) + FloorHeight, ((46.25 - 40.3) * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -32.5, -12.5 - 0.5, -30, (FloorHeight), (i * FloorHeight) + FloorHeight, (2.5 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -32.5 + 0.1, -46.25 + 0.1, -32.5 + 0.1, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (16.25 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -46.25 + 0.1, -32.5, -46.25 + 0.1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -30 - 1, -32.5, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 6, -46.25 + 7.71, -12.5 - 16, -46.25 + 7.71, (FloorHeight), (i * FloorHeight) + FloorHeight, (10 * 0.086), ((FloorHeight) * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -40.3, -12.5 - 0.5, -30, (FloorHeight - 19.5), 19.5 + (i * FloorHeight) + FloorHeight, (10.3 * 0.086), ((FloorHeight - 19.5) * 0.08)
        
    Call DrawElevatorWalls(Int(i), 7, 1, False, False, True, False, False, False, False, False, False, False, False, False)
        

'Roof Layout
i = 138
    DoEvents
    Form1.Label2.Caption = "Processing Floors 80, 115 to 117 and 130 to 138... " + Str$(Int(((i - 24) / (138 - 24)) * 100)) + "%"
    
    Room(i).AddFloor GetTex("BrickTexture"), -60, -150, 60, -46.25, (i * FloorHeight) + FloorHeight, ((60 * 2) * 0.086), ((150 - 46.25) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -60, -15.42, 60, 150, (i * FloorHeight) + FloorHeight, ((60 * 2) * 0.086), ((150 - 15.42) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -60, -46.25, -32.5, -15.42, (i * FloorHeight) + FloorHeight, ((60 - 32.5) * 0.086), ((46.25 - 15.42) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), 12.5, -46.25, 60, -15.42, (i * FloorHeight) + FloorHeight, ((60 - 12.5) * 0.086), ((46.25 - 15.42) * 0.08)
    Room(i).AddFloor GetTex("BrickTexture"), -12.5, -46.25, 12.5, -15.42, (i * FloorHeight) + FloorHeight, ((12.5 * 2) * 0.086), ((46.25 - 15.42) * 0.08)
    
    Room(i).AddFloor GetTex("BrickTexture"), -32.5, -46.25, -12.5, -15.42, (i * FloorHeight) + (FloorHeight + 25) + 0.1, 2, 2.4
    
    'Stairwell Walls
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -46.25 + 0.1, -12.5 - 0.5, -40.3, (FloorHeight), (i * FloorHeight) + FloorHeight, ((46.25 - 40.3) * 0.086), (FloorHeight * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -32.5, -12.5 - 0.5, -30, (FloorHeight), (i * FloorHeight) + FloorHeight, (2.5 * 0.086), (FloorHeight * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -32.5 + 0.1, -46.25 + 0.1, -32.5 + 0.1, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (16.25 * 0.086), (FloorHeight * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -46.25 + 0.1, -32.5, -46.25 + 0.1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), (FloorHeight * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5, -30 - 1, -32.5, -30 - 1, (FloorHeight), (i * FloorHeight) + FloorHeight, (20 * 0.086), (FloorHeight * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 6, -46.25 + 7.71, -12.5 - 16, -46.25 + 7.71, (FloorHeight), (i * FloorHeight) + FloorHeight, (10 * 0.086), (FloorHeight * 0.086)
    Stairs(i).AddWall GetTex("Concrete"), -12.5 - 0.5, -40.3, -12.5 - 0.5, -30, (FloorHeight - 19.5), 19.5 + (i * FloorHeight) + FloorHeight, (10.3 * 0.086), ((FloorHeight - 19.5) * 0.08)
    
    Call DrawElevatorWalls(Int(i), 7, 1, False, False, True, False, False, False, False, False, False, False, False, False)

End Sub

Sub SlowToFPS(ByVal FrameRate As Long)
Dim lngTicksPerFrame As Long
Static lngOldTickCount As Long
lngTicksPerFrame = 1000 / FrameRate
While GetTickCount() < lngOldTickCount
Sleep 5
Wend
lngOldTickCount = GetTickCount() + lngTicksPerFrame
End Sub

Sub ProcessOutside()
'640 and 70
'350 and 120
DoEvents

'Outside of Building
    
    Landscape.AddFloor GetTex("Downtown"), 2290, -1140, 7000, 1140, 0, 0.5, 0.25
    Landscape.AddFloor GetTex("Downtown"), -1900, -1140, -7000, 1140, 0, 0.5, 0.25
    Landscape.AddFloor GetTex("Downtown"), -7000, -1140, 7000, -7000, 0, 1.5, 0.75
    Landscape.AddFloor GetTex("Downtown"), -7000, 1140, 7000, 7000, 0, 1.5, 0.75
    
    Landscape.AddFloor GetTex("Suburbs"), 7000, -7000, 100000, 7000, 0, 10, 1
    Landscape.AddFloor GetTex("Suburbs"), -7000, -7000, -100000, 7000, 0, 10, 1
    Landscape.AddFloor GetTex("Suburbs"), -100000, -7000, 100000, -100000, 0, 10, 10
    Landscape.AddFloor GetTex("Suburbs"), -100000, 7000, 100000, 100000, 0, 10, 10
    
    'concrete below buildings
    Landscape.AddFloor GetTex("Walkway"), 1650, -790, 2290, -1140, -0.1, 4, 4
    Landscape.AddFloor GetTex("Walkway"), 1650, -320, 2290, -670, -0.1, 4, 4
    Landscape.AddFloor GetTex("Walkway"), 1650, -200, 2290, 200, -0.1, 4, 4
    Landscape.AddFloor GetTex("Walkway"), 1650, 320, 2290, 670, -0.1, 4, 4
    Landscape.AddFloor GetTex("Walkway"), 1650, 790, 2290, 1140, -0.1, 4, 4
    
    Landscape.AddFloor GetTex("Walkway"), 940, -790, 1580, -1140, -0.1, 4, 4
    Landscape.AddFloor GetTex("Walkway"), 940, -320, 1580, -670, -0.1, 4, 4
    Landscape.AddFloor GetTex("Walkway"), 940, -200, 1580, 200, -0.1, 4, 4
    Landscape.AddFloor GetTex("Walkway"), 940, 320, 1580, 670, -0.1, 4, 4
    Landscape.AddFloor GetTex("Walkway"), 940, 790, 1580, 1140, -0.1, 4, 4
        
    Landscape.AddFloor GetTex("Walkway"), 230, -790, 870, -1140, -0.1, 4, 4
    Landscape.AddFloor GetTex("Walkway"), 230, -320, 870, -670, -0.1, 4, 4
    Landscape.AddFloor GetTex("Walkway"), 230, -200, 870, 200, -0.1, 4, 4
    Landscape.AddFloor GetTex("Walkway"), 230, 320, 870, 670, -0.1, 4, 4
    Landscape.AddFloor GetTex("Walkway"), 230, 790, 870, 1140, -0.1, 4, 4
    
    Landscape.AddFloor GetTex("Walkway"), 160, -790, -480, -1140, -0.1, 4, 4
    Landscape.AddFloor GetTex("Walkway"), 160, -320, -480, -670, -0.1, 4, 4
    Landscape.AddFloor GetTex("Walkway"), 160, -200, -480, 200, -0.1, 4, 4
    Landscape.AddFloor GetTex("Walkway"), 160, 320, -480, 670, -0.1, 4, 4
    Landscape.AddFloor GetTex("Walkway"), 160, 790, -480, 1140, -0.1, 4, 4
    
    Landscape.AddFloor GetTex("Walkway"), -550, -790, -1190, -1140, -0.1, 4, 4
    Landscape.AddFloor GetTex("Walkway"), -550, -320, -1190, -670, -0.1, 4, 4
    Landscape.AddFloor GetTex("Walkway"), -550, -200, -1190, 200, -0.1, 4, 4
    Landscape.AddFloor GetTex("Walkway"), -550, 320, -1190, 670, -0.1, 4, 4
    Landscape.AddFloor GetTex("Walkway"), -550, 790, -1190, 1140, -0.1, 4, 4
    
    Landscape.AddFloor GetTex("Walkway"), -1260, -790, -1900, -1140, -0.1, 4, 4
    Landscape.AddFloor GetTex("Walkway"), -1260, -320, -1900, -670, -0.1, 4, 4
    Landscape.AddFloor GetTex("Walkway"), -1260, -200, -1900, 200, -0.1, 4, 4
    Landscape.AddFloor GetTex("Walkway"), -1260, 320, -1900, 670, -0.1, 4, 4
    Landscape.AddFloor GetTex("Walkway"), -1260, 790, -1900, 1140, -0.1, 4, 4
    
    'Main East/West Road
    Landscape.AddFloor GetTex("Road1"), 1650, -1140, 2290, -1200, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), 1650, -1200, 2290, -1260, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), 940, -1140, 1580, -1200, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), 940, -1200, 1580, -1260, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), 230, -1140, 870, -1200, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), 230, -1200, 870, -1260, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), 160, -1140, -480, -1200, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), 160, -1200, -480, -1260, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), -550, -1140, -1190, -1200, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), -550, -1200, -1190, -1260, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), -1260, -1140, -1900, -1200, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), -1260, -1200, -1900, -1260, 0, 4, -1
    
    Landscape.AddFloor GetTex("Road1"), 1650, -670, 2290, -730, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), 1650, -730, 2290, -790, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), 940, -670, 1580, -730, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), 940, -730, 1580, -790, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), 230, -670, 870, -730, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), 230, -730, 870, -790, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), 160, -670, -480, -730, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), 160, -730, -480, -790, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), -550, -670, -1190, -730, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), -550, -730, -1190, -790, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), -1260, -670, -1900, -730, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), -1260, -730, -1900, -790, 0, 4, -1
    
    Landscape.AddFloor GetTex("Road1"), 1650, -200, 2290, -260, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), 1650, -260, 2290, -320, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), 940, -200, 1580, -260, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), 940, -260, 1580, -320, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), 230, -200, 870, -260, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), 230, -260, 870, -320, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), 160, -200, -480, -260, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), 160, -260, -480, -320, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), -550, -200, -1190, -260, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), -550, -260, -1190, -320, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), -1260, -200, -1900, -260, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), -1260, -260, -1900, -320, 0, 4, -1
    
    Landscape.AddFloor GetTex("Road1"), 1650, 200, 2290, 260, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), 1650, 260, 2290, 320, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), 940, 200, 1580, 260, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), 940, 260, 1580, 320, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), 230, 200, 870, 260, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), 230, 260, 870, 320, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), 160, 200, -480, 260, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), 160, 260, -480, 320, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), -550, 200, -1190, 260, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), -550, 260, -1190, 320, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), -1260, 200, -1900, 260, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), -1260, 260, -1900, 320, 0, 4, -1
    
    Landscape.AddFloor GetTex("Road1"), 1650, 670, 2290, 730, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), 1650, 730, 2290, 790, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), 940, 670, 1580, 730, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), 940, 730, 1580, 790, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), 230, 670, 870, 730, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), 230, 730, 870, 790, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), 160, 670, -480, 730, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), 160, 730, -480, 790, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), -550, 670, -1190, 730, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), -550, 730, -1190, 790, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), -1260, 670, -1900, 730, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), -1260, 730, -1900, 790, 0, 4, -1
    
    Landscape.AddFloor GetTex("Road1"), 1650, 1140, 2290, 1200, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), 1650, 1200, 2290, 1260, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), 940, 1140, 1580, 1200, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), 940, 1200, 1580, 1260, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), 230, 1140, 870, 1200, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), 230, 1200, 870, 1260, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), 160, 1140, -480, 1200, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), 160, 1200, -480, 1260, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), -550, 1140, -1190, 1200, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), -550, 1200, -1190, 1260, 0, 4, -1
    Landscape.AddFloor GetTex("Road1"), -1260, 1140, -1900, 1200, 0, 4, 1
    Landscape.AddFloor GetTex("Road1"), -1260, 1200, -1900, 1260, 0, 4, -1
    
    'North/South roads
    Landscape.AddFloor GetTex("Road5"), 2290, -790, 2360, -1140, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), 2290, -320, 2360, -670, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), 2290, -200, 2360, 200, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), 2290, 320, 2360, 670, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), 2290, 790, 2360, 1140, 0, 1, 5
    
    Landscape.AddFloor GetTex("Road5"), 1580, -790, 1650, -1140, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), 1580, -320, 1650, -670, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), 1580, -200, 1650, 200, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), 1580, 320, 1650, 670, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), 1580, 790, 1650, 1140, 0, 1, 5
    
    Landscape.AddFloor GetTex("Road5"), 870, -790, 940, -1140, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), 870, -320, 940, -670, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), 870, -200, 940, 200, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), 870, 320, 940, 670, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), 870, 790, 940, 1140, 0, 1, 5
    
    Landscape.AddFloor GetTex("Road5"), 160, -790, 230, -1140, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), 160, -320, 230, -670, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), 160, -200, 230, 200, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), 160, 320, 230, 670, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), 160, 790, 230, 1140, 0, 1, 5
    
    Landscape.AddFloor GetTex("Road5"), -480, -790, -550, -1140, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), -480, -320, -550, -670, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), -480, -200, -550, 200, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), -480, 320, -550, 670, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), -480, 790, -550, 1140, 0, 1, 5
    
    Landscape.AddFloor GetTex("Road5"), -1190, -790, -1260, -1140, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), -1190, -320, -1260, -670, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), -1190, -200, -1260, 200, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), -1190, 320, -1260, 670, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), -1190, 790, -1260, 1140, 0, 1, 5
    
    Landscape.AddFloor GetTex("Road5"), -1900, -790, -1970, -1140, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), -1900, -320, -1970, -670, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), -1900, -200, -1970, 200, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), -1900, 320, -1970, 670, 0, 1, 5
    Landscape.AddFloor GetTex("Road5"), -1900, 790, -1970, 1140, 0, 1, 5
    
    'Intersections
    Landscape.AddFloor GetTex("Road4"), 1580, -790, 1650, -670, 0, 1, -1
    Landscape.AddFloor GetTex("Road4"), 1580, -320, 1650, -200, 0, 1, 1
    Landscape.AddFloor GetTex("Road4"), 1580, 200, 1650, 320, 0, 1, -1
    Landscape.AddFloor GetTex("Road4"), 1580, 670, 1650, 790, 0, 1, 1
    
    Landscape.AddFloor GetTex("Road4"), 870, -790, 940, -670, 0, 1, -1
    Landscape.AddFloor GetTex("Road4"), 870, -320, 940, -200, 0, 1, 1
    Landscape.AddFloor GetTex("Road4"), 870, 200, 940, 320, 0, 1, -1
    Landscape.AddFloor GetTex("Road4"), 870, 670, 940, 790, 0, 1, 1
    
    Landscape.AddFloor GetTex("Road4"), 230, -790, 160, -670, 0, 1, -1
    Landscape.AddFloor GetTex("Road4"), 230, -320, 160, -200, 0, 1, 1
    Landscape.AddFloor GetTex("Road4"), 230, 200, 160, 320, 0, 1, -1
    Landscape.AddFloor GetTex("Road4"), 230, 670, 160, 790, 0, 1, 1
    
    Landscape.AddFloor GetTex("Road4"), -550, -790, -480, -670, 0, 1, -1
    Landscape.AddFloor GetTex("Road4"), -550, -320, -480, -200, 0, 1, 1
    Landscape.AddFloor GetTex("Road4"), -550, 200, -480, 320, 0, 1, -1
    Landscape.AddFloor GetTex("Road4"), -550, 670, -480, 790, 0, 1, 1
    
    Landscape.AddFloor GetTex("Road4"), -1260, -790, -1190, -670, 0, 1, -1
    Landscape.AddFloor GetTex("Road4"), -1260, -320, -1190, -200, 0, 1, 1
    Landscape.AddFloor GetTex("Road4"), -1260, 200, -1190, 320, 0, 1, -1
    Landscape.AddFloor GetTex("Road4"), -1260, 670, -1190, 790, 0, 1, 1
       
    
    'Other Towers
    
    '*** Building directly south of the Triton Center
    Buildings.AddWall GetTex("Windows11"), -160, 400, 160, 400, 32 * 15, 0, 10, 15
    Buildings.AddWall GetTex("Windows11"), -160, 600, 160, 600, 32 * 15, 0, 10, 15
    Buildings.AddWall GetTex("Windows11"), -160, 400, -160, 600, 32 * 15, 0, 10, 15
    Buildings.AddWall GetTex("Windows11"), 160, 400, 160, 600, 32 * 15, 0, 10, 15
    Buildings.AddFloor GetTex("Concrete"), -160, 400, 160, 600, 32 * 15, 30, 30
    
    '*** Building directly west of the Triton Center
    Buildings.AddWall GetTex("Windows11"), 470, -150, 320, -150, 30 * 36, 0, 4, 36
    Buildings.AddWall GetTex("Windows11"), 470, 150, 320, 150, 30 * 36, 0, 4, 36
    Buildings.AddWall GetTex("Windows11"), 470, -150, 470, 150, 30 * 36, 0, 4, 36
    Buildings.AddWall GetTex("Windows11"), 320, -150, 320, 150, 30 * 36, 0, 4, 36
    Buildings.AddFloor GetTex("Concrete"), 470, -150, 320, 150, 30 * 36, 30, 30
    
    '*** 2 Buildings directly west of the Triton Center
    Buildings.AddWall GetTex("Windows11"), 820, -125, 600, -125, 35 * 86, 0, 4, 86
    Buildings.AddWall GetTex("Windows11"), 820, 125, 600, 125, 35 * 86, 0, 4, 86
    Buildings.AddWall GetTex("Windows11"), 820, -125, 820, 125, 35 * 86, 0, 4, 86
    Buildings.AddWall GetTex("Windows11"), 600, -125, 600, 125, 35 * 86, 0, 4, 86
    Buildings.AddFloor GetTex("Concrete"), 820, -125, 600, 125, 35 * 86, 30, 30
    
    '*** Building directly east of the Triton Center
    Buildings.AddWall GetTex("Windows11"), -400, -100, -250, -100, 32 * 45, 0, 4, 45
    Buildings.AddWall GetTex("Windows11"), -400, 100, -250, 100, 32 * 45, 0, 4, 45
    Buildings.AddWall GetTex("Windows11"), -400, -100, -400, 100, 32 * 45, 0, 4, 45
    Buildings.AddWall GetTex("Windows11"), -250, -100, -250, 100, 32 * 45, 0, 4, 45
    Buildings.AddFloor GetTex("Concrete"), -400, -100, -250, 100, 32 * 45, 30, 30
    
    '*** 3 buildings west of the Triton Center
    
    Buildings.AddWall GetTex("Windows11"), 1300, -100, 970, -100, 32 * 25, 0, 2, 25
    Buildings.AddWall GetTex("Windows11"), 1300, 100, 970, 100, 32 * 25, 0, 2, 25
    Buildings.AddWall GetTex("Windows11"), 1300, -100, 1300, 100, 32 * 25, 0, 4, 25
    Buildings.AddWall GetTex("Windows11"), 970, -100, 970, 100, 32 * 25, 0, 4, 25
    Buildings.AddFloor GetTex("Concrete"), 1300, -100, 970, 100, 32 * 25, 30, 30
    
    '*** 2 buildings east of the Triton Center
    
    Buildings.AddWall GetTex("Windows11"), -820, -100, -650, -100, 32 * 65, 0, 2, 65
    Buildings.AddWall GetTex("Windows11"), -820, 100, -650, 100, 32 * 65, 0, 2, 65
    Buildings.AddWall GetTex("Windows11"), -820, -100, -820, 100, 32 * 65, 0, 4, 65
    Buildings.AddWall GetTex("Windows11"), -650, -100, -650, 100, 32 * 65, 0, 4, 65
    Buildings.AddFloor GetTex("Concrete"), -820, -100, -650, 100, 32 * 65, 30, 30
    
    
    External.AddWall GetTex("LobbyFront"), -160, -150, 160, -150, (FloorHeight * 3), 0, 3, 1
    External.AddWall GetTex("LobbyFront"), 160, -150, 160, 150, (FloorHeight * 3), 0, 3, 1
    External.AddWall GetTex("LobbyFront"), 160, 150, -160, 150, (FloorHeight * 3), 0, 3, 1
    External.AddWall GetTex("LobbyFront"), -160, 150, -160, -150, (FloorHeight * 3), 0, 3, 1

For i = 2 To 39
DoEvents
    External.AddWall GetTex("MainWindows"), -160, -150, 160, -150, FloorHeight, (i * FloorHeight) + FloorHeight, 7.6, 1
    External.AddWall GetTex("MainWindows"), 160, -150, 160, 150, FloorHeight, (i * FloorHeight) + FloorHeight, 7, 1
    External.AddWall GetTex("MainWindows"), 160, 150, -160, 150, FloorHeight, (i * FloorHeight) + FloorHeight, 7.6, 1
    External.AddWall GetTex("MainWindows"), -160, 150, -160, -150, FloorHeight, (i * FloorHeight) + FloorHeight, 7, 1
Next i


For i = 40 To 79
DoEvents
    External.AddWall GetTex("MainWindows"), -135, -150, 135, -150, FloorHeight, (i * FloorHeight) + FloorHeight, 6.5, 1
    External.AddWall GetTex("MainWindows"), 135, -150, 135, 150, FloorHeight, (i * FloorHeight) + FloorHeight, 7, 1
    External.AddWall GetTex("MainWindows"), 135, 150, -135, 150, FloorHeight, (i * FloorHeight) + FloorHeight, 6.5, 1
    External.AddWall GetTex("MainWindows"), -135, 150, -135, -150, FloorHeight, (i * FloorHeight) + FloorHeight, 7, 1
Next i

For i = 80 To 117
DoEvents
    External.AddWall GetTex("MainWindows"), -110, -150, 110, -150, FloorHeight, (i * FloorHeight) + FloorHeight, 5, 1
    External.AddWall GetTex("MainWindows"), 110, -150, 110, 150, FloorHeight, (i * FloorHeight) + FloorHeight, 7, 1
    External.AddWall GetTex("MainWindows"), 110, 150, -110, 150, FloorHeight, (i * FloorHeight) + FloorHeight, 5, 1
    External.AddWall GetTex("MainWindows"), -110, 150, -110, -150, FloorHeight, (i * FloorHeight) + FloorHeight, 7, 1
Next i
    
For i = 118 To 134
DoEvents
    External.AddWall GetTex("MainWindows"), -85, -150, 85, -150, FloorHeight, (i * FloorHeight) + FloorHeight, 4, 1
    External.AddWall GetTex("MainWindows"), 85, -150, 85, 150, FloorHeight, (i * FloorHeight) + FloorHeight, 7, 1
    External.AddWall GetTex("MainWindows"), 85, 150, -85, 150, FloorHeight, (i * FloorHeight) + FloorHeight, 4, 1
    External.AddWall GetTex("MainWindows"), -85, 150, -85, -150, FloorHeight, (i * FloorHeight) + FloorHeight, 7, 1
  
Next i

For i = 135 To 136
DoEvents
    External.AddWall GetTex("MainWindows"), -60, -150, 60, -150, FloorHeight, (i * FloorHeight) + FloorHeight, 3, 1
    External.AddWall GetTex("MainWindows"), 60, -150, 60, 150, FloorHeight, (i * FloorHeight) + FloorHeight, 7, 1
    External.AddWall GetTex("MainWindows"), 60, 150, -60, 150, FloorHeight, (i * FloorHeight) + FloorHeight, 3, 1
    External.AddWall GetTex("MainWindows"), -60, 150, -60, -150, FloorHeight, (i * FloorHeight) + FloorHeight, 7, 1
Next i

i = 137
    External.AddWall GetTex("Concrete"), -60, -150, 60, -150, FloorHeight, (i * FloorHeight) + FloorHeight, 3 * 4, 1 * 4
    External.AddWall GetTex("Concrete"), 60, -150, 60, 150, FloorHeight, (i * FloorHeight) + FloorHeight, 7 * 4, 1 * 4
    External.AddWall GetTex("Concrete"), 60, 150, -60, 150, FloorHeight, (i * FloorHeight) + FloorHeight, 3 * 4, 1 * 4
    External.AddWall GetTex("Concrete"), -60, 150, -60, -150, FloorHeight, (i * FloorHeight) + FloorHeight, 7 * 4, 1 * 4
    
'Landings
    Buildings.AddFloor GetTex("BrickTexture"), -160, -150, -135, 150, (40 * FloorHeight) + FloorHeight, 10, 10
    Buildings.AddFloor GetTex("BrickTexture"), 160, -150, 135, 150, (40 * FloorHeight) + FloorHeight, 10, 10

    Buildings.AddFloor GetTex("BrickTexture"), -135, -150, -110, 150, (80 * FloorHeight) + FloorHeight, 10, 10
    Buildings.AddFloor GetTex("BrickTexture"), 135, -150, 110, 150, (80 * FloorHeight) + FloorHeight, 10, 10

    Buildings.AddFloor GetTex("BrickTexture"), -110, -150, -85, 150, (118 * FloorHeight) + FloorHeight, 10, 10
    Buildings.AddFloor GetTex("BrickTexture"), 110, -150, 85, 150, (118 * FloorHeight) + FloorHeight, 10, 10

    Buildings.AddFloor GetTex("BrickTexture"), -85, -150, -60, 150, (135 * FloorHeight) + FloorHeight, 10, 10
    Buildings.AddFloor GetTex("BrickTexture"), 85, -150, 60, 150, (135 * FloorHeight) + FloorHeight, 10, 10

'Antennae
    '1
    Buildings.AddWall GetTex("Concrete"), -25, 10, -25, 15, 20 * FloorHeight, (138 * FloorHeight) + FloorHeight, 1 * 2, 20 * 4
    Buildings.AddWall GetTex("Concrete"), -20, 15, -25, 15, 20 * FloorHeight, (138 * FloorHeight) + FloorHeight, 1 * 2, 20 * 4
    Buildings.AddWall GetTex("Concrete"), -20, 10, -25, 10, 20 * FloorHeight, (138 * FloorHeight) + FloorHeight, 1 * 2, 20 * 4
    Buildings.AddWall GetTex("Concrete"), -20, 10, -20, 15, 20 * FloorHeight, (138 * FloorHeight) + FloorHeight, 1 * 2, 20 * 4
    
    '2
    Buildings.AddWall GetTex("Concrete"), 25, 10, 25, 15, 20 * FloorHeight, (138 * FloorHeight) + FloorHeight, 1 * 2, 20 * 4
    Buildings.AddWall GetTex("Concrete"), 20, 15, 25, 15, 20 * FloorHeight, (138 * FloorHeight) + FloorHeight, 1 * 2, 20 * 4
    Buildings.AddWall GetTex("Concrete"), 20, 10, 25, 10, 20 * FloorHeight, (138 * FloorHeight) + FloorHeight, 1 * 2, 20 * 4
    Buildings.AddWall GetTex("Concrete"), 20, 10, 20, 15, 20 * FloorHeight, (138 * FloorHeight) + FloorHeight, 1 * 2, 20 * 4
    
End Sub

Sub MainLoop()
On Error Resume Next

'Calls frame limiter function, which sets the max frame rate
'note - the frame rate determines elevator speed, walking speed, etc
'In order to raise it, elevator timers and walking speed must both be changed
SlowToFPS (20)

If OpeningDoor > 0 And CallingStairDoors = False Then Call OpenDoor
If ClosingDoor > 0 And CallingStairDoors = False Then Call CloseDoor
If OpeningDoor > 0 And CallingStairDoors = True Then Call OpenStairDoor
If ClosingDoor > 0 And CallingStairDoors = True Then Call CloseStairDoor

'Determine floor that the camera is on, if the camera is not in the stairwell
If InStairwell = False Then CameraFloor = (Camera.GetPosition.Y - FloorHeight - 10) / FloorHeight
If CameraFloor < 1 Then CameraFloor = 1
            
If GotoFloor(ElevatorNumber) = 0 Then ElevatorSync(ElevatorNumber) = False

'This code turns off elevator objects and elevator sync if you leave the elevator
Elevator(ElevatorNumber).SetCollisionEnable True
If Elevator(ElevatorNumber).Collision(Camera.GetPosition, Vector(Camera.GetPosition.X, Camera.GetPosition.Y - 25, Camera.GetPosition.z), TV_TESTTYPE_ACCURATETESTING) = False And ElevatorSync(ElevatorNumber) = True Then
InElevator = False
ElevatorSync(ElevatorNumber) = False
ButtonsEnabled = False
For j50 = -1 To 144
Scene.DestroyMesh Buttons(j50)
Set Buttons(j50) = Nothing
Next j50
End If
Elevator(ElevatorNumber).SetCollisionEnable False

'This code checks to see if the camera is in an elevator or not (to draw the elevator buttons, set current elevator, etc)
'It draws a testing line below the camera, to see if the line hits the floor of an elevator.
    
For i50 = 1 To 40
    
    'This code fixes a bug where the camera's height changes in the elevator if the user moves
    If ElevatorSync(i50) = True And GotoFloor(i50) <> 0 And OpenElevator(i50) = 0 Then Camera.SetPosition Camera.GetPosition.X, Elevator(i50).GetPosition.Y + 10, Camera.GetPosition.z
    
    'detects if the person is in an elevator
    Elevator(i50).SetCollisionEnable True
    If Elevator(i50).Collision(Camera.GetPosition, Vector(Camera.GetPosition.X, Camera.GetPosition.Y - 25, Camera.GetPosition.z), TV_TESTTYPE_ACCURATETESTING) = True Then
        If InElevator = False Then DrawElevatorButtons (i50)
        ElevatorNumber = i50
        InElevator = True
                
        'displays 3 floors of the inside shaft while the elevator's moving
        If ElevatorSync(i50) = True And OpenElevator(i50) = 0 And GotoFloor(i50) <> 0 Then
            If i50 = 2 Or i50 = 4 Or i50 = 6 Or i50 = 8 Or i50 = 10 Or i50 = 12 Or i50 = 14 Or i50 = 16 Or i50 = 18 Or i50 = 20 Then
                If ElevatorFloor(i50) > 1 Then Shafts2(ElevatorFloor(i50) - 1).Enable True
                If ElevatorFloor(i50) < 138 Then Shafts2(ElevatorFloor(i50) + 1).Enable True
                Shafts2(ElevatorFloor(i50)).Enable True
                If ElevatorFloor(i50) > 2 Then Shafts2(ElevatorFloor(i50) - 2).Enable False
                If ElevatorFloor(i50) < 137 Then Shafts2(ElevatorFloor(i50) + 2).Enable False
            End If
            If i50 = 1 Or i50 = 3 Or i50 = 5 Or i50 = 7 Or i50 = 9 Or i50 = 11 Or i50 = 13 Or i50 = 15 Or i50 = 17 Or i50 = 19 Then
                If ElevatorFloor(i50) > 1 Then Shafts1(ElevatorFloor(i50) - 1).Enable True
                If ElevatorFloor(i50) < 138 Then Shafts1(ElevatorFloor(i50) + 1).Enable True
                Shafts1(ElevatorFloor(i50)).Enable True
                If ElevatorFloor(i50) > 2 Then Shafts1(ElevatorFloor(i50) - 2).Enable False
                If ElevatorFloor(i50) < 137 Then Shafts1(ElevatorFloor(i50) + 2).Enable False
            End If
            If i50 = 22 Or i50 = 24 Or i50 = 26 Or i50 = 28 Or i50 = 30 Or i50 = 32 Or i50 = 34 Or i50 = 36 Or i50 = 38 Or i50 = 40 Then
                If ElevatorFloor(i50) > 1 Then Shafts4(ElevatorFloor(i50) - 1).Enable True
                If ElevatorFloor(i50) < 138 Then Shafts4(ElevatorFloor(i50) + 1).Enable True
                Shafts4(ElevatorFloor(i50)).Enable True
                If ElevatorFloor(i50) > 2 Then Shafts4(ElevatorFloor(i50) - 2).Enable False
                If ElevatorFloor(i50) < 137 Then Shafts4(ElevatorFloor(i50) + 2).Enable False
            End If
            If i50 = 21 Or i50 = 23 Or i50 = 25 Or i50 = 27 Or i50 = 29 Or i50 = 31 Or i50 = 33 Or i50 = 35 Or i50 = 37 Or i50 = 39 Then
                If ElevatorFloor(i50) > 1 Then Shafts3(ElevatorFloor(i50) - 1).Enable True
                If ElevatorFloor(i50) < 138 Then Shafts3(ElevatorFloor(i50) + 1).Enable True
                Shafts4(ElevatorFloor(i50)).Enable True
                If ElevatorFloor(i50) > 2 Then Shafts3(ElevatorFloor(i50) - 2).Enable False
                If ElevatorFloor(i50) < 137 Then Shafts3(ElevatorFloor(i50) + 2).Enable False
            End If
        Else
            If ElevatorFloor(i50) > 1 Then Shafts1(ElevatorFloor(i50) - 1).Enable False: Shafts2(ElevatorFloor(i50) - 1).Enable False
            If ElevatorFloor(i50) < 138 Then Shafts1(ElevatorFloor(i50) + 1).Enable False: Shafts2(ElevatorFloor(i50) + 1).Enable False
            Shafts1(ElevatorFloor(i50)).Enable False
            Shafts2(ElevatorFloor(i50)).Enable False
            If ElevatorFloor(i50) > 2 Then Shafts1(ElevatorFloor(i50) - 2).Enable False: Shafts2(ElevatorFloor(i50) - 2).Enable False
            If ElevatorFloor(i50) < 137 Then Shafts1(ElevatorFloor(i50) + 2).Enable False: Shafts2(ElevatorFloor(i50) + 2).Enable False
        End If
        
        If Plaque(i50).IsMeshEnabled = False Then
            Plaque(i50).Enable True
            FloorIndicator(i50).Enable True
            Plaque(i50).SetPosition Plaque(i50).GetPosition.X, Plaque(i50).GetPosition.Y + ((CurrentFloorExact(i50) - ((Plaque(i50).GetPosition.Y - FloorHeight) / FloorHeight)) * FloorHeight), Plaque(i50).GetPosition.z
            FloorIndicator(i50).SetPosition FloorIndicator(i50).GetPosition.X, FloorIndicator(i50).GetPosition.Y + ((CurrentFloorExact(i50) - ((FloorIndicator(i50).GetPosition.Y - FloorHeight) / FloorHeight)) * FloorHeight), FloorIndicator(i50).GetPosition.z
            'DrawElevatorButtons (i50)
            'For j50 = -1 To 144
            '    Buttons(j50).SetPosition Buttons(j50).GetPosition.X, Buttons(j50).GetPosition.Y + ((CurrentFloorExact(1) - ((Buttons(j50).GetPosition.Y - FloorHeight) / FloorHeight)) * FloorHeight), Buttons(j50).GetPosition.Z
            '    Buttons(j50).Enable True
            'Next j50
        End If
    Else
    
        If Plaque(i50).IsMeshEnabled = True And ElevatorSync(ElevatorNumber) = False Then
            InElevator = False
            For j50 = -1 To 144
            Scene.DestroyMesh Buttons(j50)
            Set Buttons(j50) = Nothing
            Next j50
            ButtonsEnabled = False
            Plaque(i50).Enable False
            FloorIndicator(i50).Enable False
        End If
    End If
Next i50
   
'This code changes the elevator floor indicator picture
For i50 = 1 To 40
FloorIndicatorPic(i50) = Str$(ElevatorFloor(i50))
FloorIndicatorPic(i50) = "Button" + Mid$(FloorIndicatorPic(i50), 2)
If ElevatorFloor(i50) = 1 Then FloorIndicatorPic(i50) = "ButtonL"
If ElevatorFloor(i50) = 1 And FloorIndicatorText(i50) = "M" Then FloorIndicatorPic(i50) = "ButtonM"
If ElevatorFloor(i50) = 138 Then FloorIndicatorPic(i50) = "ButtonR"
If FloorIndicatorPic(i50) <> FloorIndicatorPicOld(i50) Then
    
    'TextureFactory.DeleteTexture GetTex("FloorIndicator" + Str$(i50))
    'TextureFactory.LoadTexture App.Path + "\data\floorindicators\" + FloorIndicatorPic(i50), "FloorIndicator" + Str$(i50)
    FloorIndicator(i50).SetTexture GetTex(FloorIndicatorPic(i50))
    
End If
FloorIndicatorPicOld(i50) = FloorIndicatorPic(i50)

ElevatorFloor2(i50) = ((Elevator(i50).GetPosition.Y - 10) / FloorHeight) - 1

'Update the floor indicator
FloorIndicatorText(i50) = Str$(ElevatorFloor(i50))
If ElevatorFloor(i50) = 1 Then FloorIndicatorText(i50) = "L"
If ElevatorFloor(i50) = 138 Then FloorIndicatorText(i50) = "R"
If Elevator(i50).GetPosition.Y > FloorHeight And ElevatorFloor(i50) < 2 Then FloorIndicatorText(i50) = "M"

Next i50

'Stair doors used to speed up stairway
i50 = CameraFloor
If CameraFloor = 1 Then i50 = -1
If CameraFloor > 1 Then StairDoor(i50 - 1).Enable True
If CameraFloor < 138 Then StairDoor(i50 + 1).Enable True
StairDoor(i50).Enable True
If CameraFloor = 1 Then StairDoor(0).Enable True: StairDoor(2).Enable True
If CameraFloor > 2 Then StairDoor(i50 - 2).Enable False
If CameraFloor < 137 Then StairDoor(i50 + 2).Enable False

Form2.Label1.Caption = FloorIndicatorText(1)
Form2.Label2.Caption = FloorIndicatorText(2)
Form2.Label3.Caption = FloorIndicatorText(3)
Form2.Label4.Caption = FloorIndicatorText(4)
Form2.Label5.Caption = FloorIndicatorText(5)
Form2.Label6.Caption = FloorIndicatorText(6)
Form2.Label7.Caption = FloorIndicatorText(7)
Form2.Label8.Caption = FloorIndicatorText(8)
Form2.Label9.Caption = FloorIndicatorText(9)
Form2.Label10.Caption = FloorIndicatorText(10)
Form2.Label11.Caption = FloorIndicatorText(11)
Form2.Label12.Caption = FloorIndicatorText(12)
Form2.Label13.Caption = FloorIndicatorText(13)
Form2.Label14.Caption = FloorIndicatorText(14)
Form2.Label15.Caption = FloorIndicatorText(15)
Form2.Label16.Caption = FloorIndicatorText(16)
Form2.Label17.Caption = FloorIndicatorText(17)
Form2.Label18.Caption = FloorIndicatorText(18)
Form2.Label19.Caption = FloorIndicatorText(19)
Form2.Label20.Caption = FloorIndicatorText(20)
Form2.Label21.Caption = FloorIndicatorText(21)
Form2.Label22.Caption = FloorIndicatorText(22)
Form2.Label23.Caption = FloorIndicatorText(23)
Form2.Label24.Caption = FloorIndicatorText(24)
Form2.Label25.Caption = FloorIndicatorText(25)
Form2.Label26.Caption = FloorIndicatorText(26)
Form2.Label27.Caption = FloorIndicatorText(27)
Form2.Label28.Caption = FloorIndicatorText(28)
Form2.Label29.Caption = FloorIndicatorText(29)
Form2.Label30.Caption = FloorIndicatorText(30)
Form2.Label31.Caption = FloorIndicatorText(31)
Form2.Label32.Caption = FloorIndicatorText(32)
Form2.Label33.Caption = FloorIndicatorText(33)
Form2.Label34.Caption = FloorIndicatorText(34)
Form2.Label35.Caption = FloorIndicatorText(35)
Form2.Label36.Caption = FloorIndicatorText(36)
Form2.Label37.Caption = FloorIndicatorText(37)
Form2.Label38.Caption = FloorIndicatorText(38)
Form2.Label39.Caption = FloorIndicatorText(39)
Form2.Label40.Caption = FloorIndicatorText(40)
   

Dim A As Single
''update lights
'a = a + TV.TimeElapsed * 0.001
'      LightD.Position = Vector(0, 10, Sin(a) * 50 + 50)
'      Light.UpdateLight 1, LightD
      
      

CameraFloor2 = ((Camera.GetPosition.Y - 10) / FloorHeight) - 1

'this determines if the person is inside the stairwell shaft or not, and sets a variable accordingly.
If Camera.GetPosition.X < -12.5 And Camera.GetPosition.X > -32.5 And Camera.GetPosition.z > -46.25 And Camera.GetPosition.z < -30 Then
InStairwell = True
Else
InStairwell = False
End If

If CameraFloor = 137 Then
For i50 = 1 To 138
Shafts2(i50).Enable True
Next i50
Else
'For i50 = 1 To 138
'Shafts(i50).Enable False
'Next i50
End If

'floors 135 and 136 are combined. this simply makes sure that they are off when not in use :)

If CameraFloor <> 136 And CameraFloor <> 135 Then
Room(136).Enable False
'ElevatorDoor1L(136).Enable False
'ElevatorDoor1R(136).Enable False
'ElevatorDoor1L(135).Enable False
'ElevatorDoor1R(135).Enable False
'ElevatorDoor2L(136).Enable False
'ElevatorDoor2R(136).Enable False
'ElevatorDoor2L(135).Enable False
'ElevatorDoor2R(135).Enable False
'ElevatorDoorL(1).Enable False
'ElevatorDoorL(2).Enable False
'ElevatorDoorL(3).Enable False
'ElevatorDoorL(4).Enable False
'ElevatorDoorR(1).Enable False
'ElevatorDoorR(2).Enable False
'ElevatorDoorR(3).Enable False
'ElevatorDoorR(4).Enable False
Room(135).Enable False
ShaftsFloor(135).Enable False
ShaftsFloor(136).Enable False
Else
If CameraFloor = 136 Or CameraFloor = 135 Then
    If GotoFloor(ElevatorNumber) = 0 And InStairwell = False Then
    Room(136).Enable True
    'ElevatorDoor1L(136).Enable True
    'ElevatorDoor1R(136).Enable True
    'ElevatorDoor1L(135).Enable True
    'ElevatorDoor1R(135).Enable True
    'ElevatorDoor2L(136).Enable True
    'ElevatorDoor2R(136).Enable True
    'ElevatorDoor2L(135).Enable True
    'ElevatorDoor2R(135).Enable True
    'ElevatorDoorL(1).Enable True
    'ElevatorDoorL(2).Enable True
    'ElevatorDoorL(3).Enable True
    'ElevatorDoorL(4).Enable True
    'ElevatorDoorR(1).Enable True
    'ElevatorDoorR(2).Enable True
    'ElevatorDoorR(3).Enable True
    'ElevatorDoorR(4).Enable True
    Room(135).Enable True
    ShaftsFloor(135).Enable True
    ShaftsFloor(136).Enable True
    End If
End If
End If

''this section makes sure all the extra objects on the 1st and M floors are created
'If CameraFloor <> 1 And ElevatorDoorL(1).IsMeshEnabled = False Then
'For i50 = 1 To 40
'ElevatorDoorL(i50).Enable False
'ElevatorDoorR(i50).Enable False
'Next i50
'ElevatorDoorL(1).Enable False
'ElevatorDoorR(1).Enable False
'ElevatorDoorL(2).Enable False
'ElevatorDoorR(2).Enable False
'End If
'If CameraFloor = 1 And GotoFloor(ElevatorNumber) = 0 And ElevatorDoorL(1).IsMeshEnabled = False Then
'For i50 = 1 To 40
'ElevatorDoorL(i50).Enable True
'ElevatorDoorR(i50).Enable True
'Next i50
'ElevatorDoorL(1).Enable True
'ElevatorDoorR(1).Enable True
'ElevatorDoorL(2).Enable True
'ElevatorDoorR(2).Enable True
'End If

'This section turns on and off the external mesh (outside windows, not inside windows), based on the camera's current location
If CameraFloor >= 1 And CameraFloor <= 39 Then
    If Camera.GetPosition.X < -160 Or Camera.GetPosition.X > 160 Or Camera.GetPosition.z < -150 Or Camera.GetPosition.z > 150 Then
    If External.IsMeshEnabled = False Then
        External.Enable True
        'Buildings.Enable True
        Room(CameraFloor).Enable False
        ShaftsFloor(CameraFloor).Enable False
        DestroyObjects (CameraFloor)
    End If
    Else
    If External.IsMeshEnabled = True Then
        External.Enable False
        'Buildings.Enable False
        Room(CameraFloor).Enable True
        ShaftsFloor(CameraFloor).Enable True
        Call InitRealtime(CameraFloor)
        InitObjectsForFloor (CameraFloor)
    End If
    End If
End If
If CameraFloor >= 40 And CameraFloor <= 79 Then
    If Camera.GetPosition.X < -135 Or Camera.GetPosition.X > 135 Or Camera.GetPosition.z < -150 Or Camera.GetPosition.z > 150 Then
    If External.IsMeshEnabled = False Then
        External.Enable True
        'Buildings.Enable True
        Room(CameraFloor).Enable False
        ShaftsFloor(CameraFloor).Enable False
        DestroyObjects (CameraFloor)
    End If
    Else
    If External.IsMeshEnabled = True Then
        External.Enable False
        'Buildings.Enable False
        Room(CameraFloor).Enable True
        ShaftsFloor(CameraFloor).Enable True
        Call InitRealtime(CameraFloor)
        InitObjectsForFloor (CameraFloor)
    End If
   End If
End If
If CameraFloor >= 80 And CameraFloor <= 117 Then
    If Camera.GetPosition.X < -110 Or Camera.GetPosition.X > 110 Or Camera.GetPosition.z < -150 Or Camera.GetPosition.z > 150 Then
    If External.IsMeshEnabled = False Then
        External.Enable True
        'Buildings.Enable True
        Room(CameraFloor).Enable False
        ShaftsFloor(CameraFloor).Enable False
        DestroyObjects (CameraFloor)
    End If
    Else
    If External.IsMeshEnabled = True Then
        External.Enable False
        'Buildings.Enable False
        Room(CameraFloor).Enable True
        ShaftsFloor(CameraFloor).Enable True
        Call InitRealtime(CameraFloor)
        InitObjectsForFloor (CameraFloor)
    End If
    End If
End If
If CameraFloor >= 118 And CameraFloor <= 134 Then
    If Camera.GetPosition.X < -85 Or Camera.GetPosition.X > 85 Or Camera.GetPosition.z < -150 Or Camera.GetPosition.z > 150 Then
    If External.IsMeshEnabled = False Then
        External.Enable True
        'Buildings.Enable True
        Room(CameraFloor).Enable False
        ShaftsFloor(CameraFloor).Enable False
        DestroyObjects (CameraFloor)
    End If
    Else
    If External.IsMeshEnabled = True Then
        External.Enable False
        'Buildings.Enable False
        Room(CameraFloor).Enable True
        ShaftsFloor(CameraFloor).Enable True
        Call InitRealtime(CameraFloor)
        InitObjectsForFloor (CameraFloor)
    End If
    End If
End If
If CameraFloor >= 135 And CameraFloor <= 138 Then
    If Camera.GetPosition.X < -60 Or Camera.GetPosition.X > 60 Or Camera.GetPosition.z < -150 Or Camera.GetPosition.z > 150 Then
    If External.IsMeshEnabled = False Then
        External.Enable True
        'Buildings.Enable True
        Room(CameraFloor).Enable False
        ShaftsFloor(CameraFloor).Enable False
        DestroyObjects (CameraFloor)
    End If
    Else
    If External.IsMeshEnabled = True Then
        External.Enable False
        'Buildings.Enable False
        Room(CameraFloor).Enable True
        ShaftsFloor(CameraFloor).Enable True
        Call InitRealtime(CameraFloor)
        InitObjectsForFloor (CameraFloor)
    End If
    End If
End If

'Calls the Fall sub, and if IsFalling is true then the user falls until they hit something
If EnableCollisions = True Then Call Fall

''This section turns on and off the Shafts mesh (inside the elevator and pipe shafts) when the camera is located inside them.
'If CameraFloor = ElevatorFloor(ElevatorNumber) And Camera.GetPosition.X > -32.5 And Camera.GetPosition.X < -12.5 And Camera.GetPosition.z > -30 And Camera.GetPosition.z < -16 And CameraFloor <> 137 Then
'For i50 = 1 To 138
'Shafts(i50).Enable False
'Next i50
''Atmos.SkyBox_Enable False
'GoTo EndShafts
'Else
''Atmos.SkyBox_Enable True
'End If

If CameraFloor = 137 Then GoTo EndShafts
If GotoFloor(ElevatorNumber) <> 0 Then GoTo EndShafts
'GoTo EndShafts

'if user is in service room, turn on shaft
If CameraFloor >= 118 And CameraFloor <= 129 Then
If Camera.GetPosition.X < 50 And Camera.GetPosition.X > 32.5 And Camera.GetPosition.z > -46.25 And Camera.GetPosition.z < -20 And CameraFloor <> 1 And CameraFloor <> 132 And CameraFloor < 134 Then
For i50 = 1 To 138
Shafts2(i50).Enable True
Next i50
GoTo EndShafts
End If
'if user is outside service room, turn off shaft
If Camera.GetPosition.X < 50 And Camera.GetPosition.X > 32.5 And Camera.GetPosition.z < -46.25 And CameraFloor <> 1 And CameraFloor <> 132 And CameraFloor < 134 Then
For i50 = 1 To 138
Shafts2(i50).Enable False
Next i50
GoTo EndShafts
End If
End If

If CameraFloor >= 1 And CameraFloor <= 39 Then
    'right shaft (the one with the stairs)
    If Camera.GetPosition.X > -52.5 And Camera.GetPosition.X < -12.5 And Camera.GetPosition.z > -30 And Camera.GetPosition.z < 0 And InElevator = False Then
    For i50 = 1 To 138
    Shafts1(i50).Enable True
    Next i50
    Else
    'left shaft (the one with the pipe shaft)
    If Camera.GetPosition.X > 12.5 And Camera.GetPosition.X < 52.5 And Camera.GetPosition.z > -46.25 And Camera.GetPosition.z < 0 And InElevator = False Then
    For i50 = 1 To 138
    Shafts2(i50).Enable True
    Next i50
    Else
    If Camera.GetPosition.X > -130.5 And Camera.GetPosition.X < -90.5 And Camera.GetPosition.z > -30 And Camera.GetPosition.z < 46.25 And InElevator = False Then
    For i50 = 1 To 138
    Shafts3(i50).Enable True
    Next i50
    Else
    If Camera.GetPosition.X > 90.5 And Camera.GetPosition.X < 130.5 And Camera.GetPosition.z > -46.25 And Camera.GetPosition.z < 46.25 And InElevator = False Then
    For i50 = 1 To 138
    Shafts4(i50).Enable True
    Next i50
    Else
    For i50 = 1 To 138
    Shafts1(i50).Enable False
    Shafts2(i50).Enable False
    Shafts3(i50).Enable False
    Shafts4(i50).Enable False
    Next i50
    End If
    End If
    End If
    End If
    
End If
If CameraFloor >= 40 And CameraFloor <= 79 Then
    If Camera.GetPosition.X > -52.5 And Camera.GetPosition.X < -12.5 And Camera.GetPosition.z > -30 And Camera.GetPosition.z < 0 And InElevator = False Then
    For i50 = 1 To 138
    Shafts1(i50).Enable True
    Next i50
    Else
    If Camera.GetPosition.X > 12.5 And Camera.GetPosition.X < 52.5 And Camera.GetPosition.z > -46.25 And Camera.GetPosition.z < 0 And InElevator = False Then
    For i50 = 1 To 138
    Shafts2(i50).Enable True
    Next i50
    Else
    If Camera.GetPosition.X > -110.5 And Camera.GetPosition.X < -90.5 And Camera.GetPosition.z > -30 And Camera.GetPosition.z < 46.25 And InElevator = False Then
    For i50 = 1 To 138
    Shafts3(i50).Enable True
    Next i50
    Else
    If Camera.GetPosition.X > 90.5 And Camera.GetPosition.X < 110.5 And Camera.GetPosition.z > -46.25 And Camera.GetPosition.z < 46.25 And InElevator = False Then
    For i50 = 1 To 138
    Shafts4(i50).Enable True
    Next i50
    Else
    For i50 = 1 To 138
    Shafts1(i50).Enable False
    Shafts2(i50).Enable False
    Shafts3(i50).Enable False
    Shafts4(i50).Enable False
    Next i50
    End If
    End If
    End If
    End If
End If
If CameraFloor >= 80 And CameraFloor <= 117 Then
    If Camera.GetPosition.X > -52.5 And Camera.GetPosition.X < -12.5 And Camera.GetPosition.z > -30 And Camera.GetPosition.z < 46.25 And InElevator = False Then
    For i50 = 1 To 138
    Shafts1(i50).Enable True
    Next i50
    Else
    'left shaft (the one with the pipe shaft)
    If Camera.GetPosition.X > 12.5 And Camera.GetPosition.X < 52.5 And Camera.GetPosition.z > -46.25 And Camera.GetPosition.z < 46.25 And InElevator = False Then
    For i50 = 1 To 138
    Shafts2(i50).Enable True
    Next i50
    Else
    For i50 = 1 To 138
    Shafts1(i50).Enable False
    Shafts2(i50).Enable False
    Next i50
    End If
    End If
End If
If CameraFloor >= 118 And CameraFloor <= 130 Then
    If Camera.GetPosition.X > -32.5 And Camera.GetPosition.X < -12.5 And Camera.GetPosition.z > -30 And Camera.GetPosition.z < 46.25 And InElevator = False Then
    For i50 = 1 To 138
    Shafts1(i50).Enable True
    Next i50
    Else
    'left shaft (the one with the pipe shaft)
    If Camera.GetPosition.X > 12.5 And Camera.GetPosition.X < 32.5 And Camera.GetPosition.z > -46.25 And Camera.GetPosition.z < 46.25 And InElevator = False Then
    For i50 = 1 To 138
    Shafts2(i50).Enable True
    Next i50
    Else
    For i50 = 1 To 138
    Shafts1(i50).Enable False
    Shafts2(i50).Enable False
    Next i50
    End If
    End If
End If
If CameraFloor >= 131 And CameraFloor <= 136 Then
    If Camera.GetPosition.X > -32.5 And Camera.GetPosition.X < -12.5 And Camera.GetPosition.z > -30 And Camera.GetPosition.z < 0 And InElevator = False Then
    For i50 = 1 To 138
    Shafts1(i50).Enable True
    Next i50
    Else
    If Camera.GetPosition.X > 12.5 And Camera.GetPosition.X < 32.5 And Camera.GetPosition.z > -46.25 And Camera.GetPosition.z < 0 And InElevator = False Then
    For i50 = 1 To 138
    Shafts2(i50).Enable True
    Next i50
    Else
    For i50 = 1 To 138
    Shafts1(i50).Enable False
    Shafts2(i50).Enable False
    Next i50
    End If
    End If
End If
If CameraFloor >= 137 Then
    If Camera.GetPosition.X > -32.5 And Camera.GetPosition.X < -12.5 And Camera.GetPosition.z > -30 And Camera.GetPosition.z < -15.42 And InElevator = False Then
    For i50 = 1 To 138
    Shafts1(i50).Enable True
    Next i50
    Else
    For i50 = 1 To 138
    Shafts1(i50).Enable False
    Next i50
    'End If
    End If
End If
EndShafts:

    linestart = Camera.GetPosition

 Inp.GetAbsMouseState tmpMouseX, tmpMouseY, tmpMouseB1

'Click
 If tmpMouseB1 <> 0 Then
        'If FloorIndicator1.Collision=True
        
        StairDoor(CameraFloor).SetCollisionEnable True
        
        Room(CameraFloor).SetCollisionEnable False
        External.SetCollisionEnable False
        Buildings.SetCollisionEnable False
        Landscape.SetCollisionEnable False
        For i50 = 1 To 138
        Shafts1(i50).SetCollisionEnable False
        Shafts2(i50).SetCollisionEnable False
        Next i50
        ShaftsFloor(CameraFloor).SetCollisionEnable False
        For i50 = 1 To 40
        Elevator(i50).SetCollisionEnable False
        ElevatorInsDoorL(i50).SetCollisionEnable False
        ElevatorInsDoorR(i50).SetCollisionEnable False
        Next i50
        If CameraFloor = 1 Then
        For i50 = 1 To 40
        ElevatorDoorL(i50).SetCollisionEnable False
        ElevatorDoorR(i50).SetCollisionEnable False
        Next i50
        ElevatorDoorL(1).SetCollisionEnable False
        ElevatorDoorR(1).SetCollisionEnable False
        ElevatorDoorL(2).SetCollisionEnable False
        ElevatorDoorR(2).SetCollisionEnable False
        Else
        For i50 = 1 To 40
        ElevatorDoorL(i50).SetCollisionEnable False
        ElevatorDoorR(i50).SetCollisionEnable False
        Next i50
        End If
        Stairs(CameraFloor).SetCollisionEnable False
        If CameraFloor > 1 Then Stairs(CameraFloor - 1).SetCollisionEnable False
        If CameraFloor < 138 Then Stairs(CameraFloor + 1).SetCollisionEnable False
        If CameraFloor = 135 Then Room(136).SetCollisionEnable False
        If CameraFloor = 136 Then Room(135).SetCollisionEnable False
        
        Set CollisionResult = Scene.MousePicking(tmpMouseX, tmpMouseY, TV_COLLIDE_MESH, TV_TESTTYPE_ACCURATETESTING)
         
        
        If CollisionResult.IsCollision Then
        Call CheckElevatorButtons
            For i50 = 1 To 40
            If CollisionResult.GetCollisionMesh.GetMeshName = CallButtons(i50).GetMeshName Then
                
                'use other elevator if it's closer
                j50 = i50
                If i50 = 3 And Abs(ElevatorFloor(3) - CameraFloor) > Abs(ElevatorFloor(4) - CameraFloor) Then j50 = 4
                If i50 = 4 And Abs(ElevatorFloor(4) - CameraFloor) > Abs(ElevatorFloor(3) - CameraFloor) Then j50 = 3
                If i50 = 5 And Abs(ElevatorFloor(5) - CameraFloor) > Abs(ElevatorFloor(6) - CameraFloor) Then j50 = 6
                If i50 = 6 And Abs(ElevatorFloor(6) - CameraFloor) > Abs(ElevatorFloor(5) - CameraFloor) Then j50 = 5
                If i50 = 7 And Abs(ElevatorFloor(7) - CameraFloor) > Abs(ElevatorFloor(8) - CameraFloor) Then j50 = 8
                If i50 = 8 And Abs(ElevatorFloor(8) - CameraFloor) > Abs(ElevatorFloor(7) - CameraFloor) Then j50 = 7
                If i50 = 9 And Abs(ElevatorFloor(9) - CameraFloor) > Abs(ElevatorFloor(10) - CameraFloor) Then j50 = 10
                If i50 = 10 And Abs(ElevatorFloor(10) - CameraFloor) > Abs(ElevatorFloor(9) - CameraFloor) Then j50 = 9
                
                If ElevatorFloor(j50) <> CameraFloor Then
                ElevatorSync(j50) = False
                OpenElevator(j50) = -1
                GotoFloor(j50) = CameraFloor
                    If GotoFloor(j50) = 1 Then GotoFloor(j50) = -1
                GoTo EndCall
                End If
                If ElevatorFloor(j50) = 1 And Camera.GetPosition.Y > FloorHeight And FloorIndicatorText(j50) <> "M" Then
                ElevatorSync(j50) = False
                OpenElevator(j50) = -1
                GotoFloor(j50) = 0.1
                GoTo EndCall
                End If
                If ElevatorFloor(j50) = 1 And Camera.GetPosition.Y < FloorHeight And FloorIndicatorText(j50) = "M" Then
                ElevatorSync(j50) = False
                OpenElevator(j50) = -1
                GotoFloor(j50) = 0.1
                GoTo EndCall
                End If
                OpenElevator(j50) = 1
            End If
EndCall:
            Next i50
            'CollisionResult.GetCollisionMesh.Enable False
        If OpeningDoor = 0 And ClosingDoor = 0 Then
            
            If Left(CollisionResult.GetCollisionMesh.GetMeshName, 7) = "DoorSB " Then
            DoorNumber = Val(Mid$(CollisionResult.GetCollisionMesh.GetMeshName, 7, 20))
            DoorRotated = 0
            Call OpenStairDoor
            End If
            
            If Left(CollisionResult.GetCollisionMesh.GetMeshName, 6) = "DoorA " Then
            DoorNumber = Val(Mid$(CollisionResult.GetCollisionMesh.GetMeshName, 6, 20))
            DoorRotated = 0
            Call OpenDoor
            End If
            
            If Left(CollisionResult.GetCollisionMesh.GetMeshName, 6) = "DoorB " Then
            DoorNumber = Val(Mid$(CollisionResult.GetCollisionMesh.GetMeshName, 6, 20))
            DoorRotated = 1
            Call OpenDoor
            End If
            
            If Left(CollisionResult.GetCollisionMesh.GetMeshName, 6) = "DoorC " Then
            DoorNumber = Val(Mid$(CollisionResult.GetCollisionMesh.GetMeshName, 6, 20))
            DoorRotated = 2
            Call OpenDoor
            End If
            
            If Left(CollisionResult.GetCollisionMesh.GetMeshName, 6) = "DoorD " Then
            DoorNumber = Val(Mid$(CollisionResult.GetCollisionMesh.GetMeshName, 6, 20))
            DoorRotated = 3
            Call OpenDoor
            End If
            
            If Left(CollisionResult.GetCollisionMesh.GetMeshName, 7) = "DoorSBO" Then
            DoorNumber = Val(Mid$(CollisionResult.GetCollisionMesh.GetMeshName, 8, 20))
            DoorRotated = 0
            ClosingDoor = 18
            Call CloseStairDoor
            End If
        
            If Left(CollisionResult.GetCollisionMesh.GetMeshName, 6) = "DoorAO" Then
            DoorNumber = Val(Mid$(CollisionResult.GetCollisionMesh.GetMeshName, 7, 20))
            DoorRotated = 0
            ClosingDoor = 18
            Call CloseDoor
            End If
        
            If Left(CollisionResult.GetCollisionMesh.GetMeshName, 6) = "DoorBO" Then
            DoorNumber = Val(Mid$(CollisionResult.GetCollisionMesh.GetMeshName, 7, 20))
            DoorRotated = 1
            ClosingDoor = 18
            Call CloseDoor
            End If
            
            If Left(CollisionResult.GetCollisionMesh.GetMeshName, 6) = "DoorCO" Then
            DoorNumber = Val(Mid$(CollisionResult.GetCollisionMesh.GetMeshName, 7, 20))
            DoorRotated = 2
            ClosingDoor = 18
            Call CloseDoor
            End If
            
            If Left(CollisionResult.GetCollisionMesh.GetMeshName, 6) = "DoorDO" Then
            DoorNumber = Val(Mid$(CollisionResult.GetCollisionMesh.GetMeshName, 7, 20))
            DoorRotated = 3
            ClosingDoor = 18
            Call CloseDoor
            End If
        
        End If
            
            End If
    End If



    TV.Clear
    'Call Listener.SetPosition(Camera.GetPosition.X, Camera.GetPosition.Y, Camera.GetPosition.z)
    'Call ElevatorMusic.GetPosition(ListenerDirection.X, ListenerDirection.Y, ListenerDirection.z)
    'Call Camera.GetRotation(ListenerDirection.x, ListenerDirection.y, ListenerDirection.z)
    'Call Listener.SetOrientation(ListenerDirection.x, Camera.GetPosition.y, ListenerDirection.z, Camera.GetPosition.x, Camera.GetPosition.y, Camera.GetPosition.z)
    'Call Listener.SetOrientation(ListenerDirection.x, Camera.GetPosition.y, ListenerDirection.z, Camera.GetPosition.x, Camera.GetPosition.y, Camera.GetPosition.z)
    
      
'*** First movement system


      'If Inp.IsKeyPressed(TV_KEY_UP) = True And Focused = True Then
      If Inp.IsKeyPressed(TV_KEY_UP) = True Then
      KeepAltitude = Camera.GetPosition.Y
      If Inp.IsKeyPressed(TV_KEY_Z) = False Then Camera.MoveRelative 0.7, 0, 0
      If Inp.IsKeyPressed(TV_KEY_Z) = True Then Camera.MoveRelative 1.4, 0, 0
      If Camera.GetPosition.Y <> KeepAltitude Then Camera.SetPosition Camera.GetPosition.X, KeepAltitude, Camera.GetPosition.z
      End If
      
      'If Inp.IsKeyPressed(TV_KEY_DOWN) = True And Focused = True Then
      If Inp.IsKeyPressed(TV_KEY_DOWN) = True Then
      KeepAltitude = Camera.GetPosition.Y
      If Inp.IsKeyPressed(TV_KEY_Z) = False Then Camera.MoveRelative -0.7, 0, 0
      If Inp.IsKeyPressed(TV_KEY_Z) = True Then Camera.MoveRelative -1.4, 0, 0
      If Camera.GetPosition.Y <> KeepAltitude Then Camera.SetPosition Camera.GetPosition.X, KeepAltitude, Camera.GetPosition.z
      End If
      
      'If Inp.IsKeyPressed(TV_KEY_RIGHT) = True And Focused = True Then Camera.RotateY 0.07
      'If Inp.IsKeyPressed(TV_KEY_LEFT) = True And Focused = True Then Camera.RotateY -0.07
      If Inp.IsKeyPressed(TV_KEY_RIGHT) = True And Inp.IsKeyPressed(TV_KEY_Z) = False Then Camera.RotateY 0.07
      If Inp.IsKeyPressed(TV_KEY_LEFT) = True And Inp.IsKeyPressed(TV_KEY_Z) = False Then Camera.RotateY -0.07
      If Inp.IsKeyPressed(TV_KEY_RIGHT) = True And Inp.IsKeyPressed(TV_KEY_Z) = True Then Camera.RotateY 0.14
      If Inp.IsKeyPressed(TV_KEY_LEFT) = True And Inp.IsKeyPressed(TV_KEY_Z) = True Then Camera.RotateY -0.14
      'If Inp.IsKeyPressed(TV_KEY_PAGEUP) = True And Focused = True Then Camera.RotateX -0.006
      'If Inp.IsKeyPressed(TV_KEY_PAGEDOWN) = True And Focused = True Then Camera.RotateX 0.006
      If Inp.IsKeyPressed(TV_KEY_PAGEUP) = True And Inp.IsKeyPressed(TV_KEY_Z) = False Then Camera.RotateX -0.006
      If Inp.IsKeyPressed(TV_KEY_PAGEUP) = True And Inp.IsKeyPressed(TV_KEY_Z) = True Then Camera.RotateX -0.012
      If Inp.IsKeyPressed(TV_KEY_PAGEDOWN) = True And Inp.IsKeyPressed(TV_KEY_Z) = False Then Camera.RotateX 0.006
      If Inp.IsKeyPressed(TV_KEY_PAGEDOWN) = True And Inp.IsKeyPressed(TV_KEY_Z) = True Then Camera.RotateX 0.012
      
      'If Inp.IsKeyPressed(TV_KEY_HOME) = True And Focused = True Then Camera.MoveRelative 0, 1, 0
      'If Inp.IsKeyPressed(TV_KEY_END) = True And Focused = True Then Camera.MoveRelative 0, -1, 0
      If Inp.IsKeyPressed(TV_KEY_HOME) = True And Inp.IsKeyPressed(TV_KEY_Z) = False Then Camera.MoveRelative 0, 1, 0
      If Inp.IsKeyPressed(TV_KEY_HOME) = True And Inp.IsKeyPressed(TV_KEY_Z) = True Then Camera.MoveRelative 0, 2, 0
      If Inp.IsKeyPressed(TV_KEY_END) = True And Inp.IsKeyPressed(TV_KEY_Z) = False And EnableCollisions = False Then Camera.MoveRelative 0, -1, 0
      If Inp.IsKeyPressed(TV_KEY_END) = True And Inp.IsKeyPressed(TV_KEY_Z) = True And EnableCollisions = False Then Camera.MoveRelative 0, -2, 0
      'If Inp.IsKeyPressed(TV_KEY_1) = True And Focused = True Then ElevatorDirection = 1
      'If Inp.IsKeyPressed(TV_KEY_2) = True And Focused = True Then ElevatorDirection = -1
      'If Inp.IsKeyPressed(TV_KEY_3) = True And Focused = True Then OpenElevator(ElevatorNumber) = 1
      'If Inp.IsKeyPressed(TV_KEY_4) = True And Focused = True Then OpenElevator(ElevatorNumber) = -1
      'If Inp.IsKeyPressed(TV_KEY_5) = True And Focused = True Then Call ElevatorMusic.Play
      'If Inp.IsKeyPressed(TV_KEY_6) = True And Focused = True Then Call ElevatorMusic.Stop_
      If Inp.IsKeyPressed(TV_KEY_SPACE) = True Then Camera.SetRotation 0, 0, 0
      'If Inp.IsKeyPressed(TV_KEY_6) = True Then MsgBox (Str$(Camera.GetLookAt.X) + Str$(Camera.GetLookAt.Y) + Str$(Camera.GetLookAt.z))
      If Inp.IsKeyPressed(TV_KEY_7) = True Then IsFalling = True
      
      If Inp.IsKeyPressed(TV_KEY_F1) = True And Focused = True Then TV.ScreenShot ("c:\shot.bmp")

      
Form2.Text1.Text = "Elevator Number= " + Str$(ElevatorNumber) + vbCrLf + "Elevator Floor=" + Str$(ElevatorFloor(ElevatorNumber)) + vbCrLf + "Camera Floor=" + Str$(CameraFloor) + vbCrLf + "Current Location= " + Str$(Int(Camera.GetPosition.X)) + "," + Str$(Int(Camera.GetPosition.Y)) + "," + Str$(Int(Camera.GetPosition.z)) + vbCrLf + "GotoFloor=" + Str$(GotoFloor(ElevatorNumber)) + vbCrLf + "DistancetoDest=" + Str$(Abs(GotoFloor(ElevatorNumber) - CurrentFloor(ElevatorNumber))) + vbCrLf + "Rate=" + Str$(ElevatorEnable(ElevatorNumber) / 5)
             
      'ElevatorFloor(ElevatorNumber) = (Elevator(ElevatorNumber).GetPosition.Y - FloorHeight) / FloorHeight
      'If ElevatorFloor(ElevatorNumber) < 1 Then ElevatorFloor(ElevatorNumber) = 1
      
      If InStairwell = False Then CameraFloor = (Camera.GetPosition.Y - FloorHeight - 10) / FloorHeight
      If CameraFloor < 1 Then CameraFloor = 1
   
      lineend = Camera.GetPosition
          
If EnableCollisions = True Then Call CheckCollisions

        
    'On Error Resume Next
    Atmos.Atmosphere_Render
    Scene.RenderAllMeshes
    TV.RenderToScreen
    DoEvents
  
End Sub

Sub StairsLoop()
    Dim RiserHeight As Single
    RiserHeight = FloorHeight / 16

'Stairs Movement
      If Camera.GetPosition.X <= -12.5 And Camera.GetPosition.X > -12.5 - 6 And Camera.GetPosition.z > -46.25 And Camera.GetPosition.z < -30.85 And Camera.GetPosition.Y = (CameraFloor * FloorHeight) + FloorHeight + 10 + (RiserHeight * 15) + PartialFloor Then
      Room(CameraFloor).Enable False
      For i51 = 1 To 40
      ElevatorDoorL(i51).Enable False
      ElevatorDoorR(i51).Enable False
      Next i51
      For i51 = 1 To 40
      CallButtons(i51).Enable False
      Next i51
      ShaftsFloor(CameraFloor).Enable False
      Atmos.SkyBox_Enable False
      DestroyObjects (CameraFloor)
      
      'Stairs(CameraFloor).Enable False
      If CameraFloor < 138 Then Stairs(CameraFloor + 1).Enable False
      If CameraFloor > 1 Then Stairs(CameraFloor - 1).Enable False
    If CameraFloor >= 2 Then CameraFloor = CameraFloor + 1
    If CameraFloor = 1 Then PartialFloor = PartialFloor + FloorHeight
    If CameraFloor = 1 And PartialFloor >= FloorHeight Then PartialFloor = 0: CameraFloor = 2
      'Room(CameraFloor).Enable True
      'For i51 = 1 To 40
      'ElevatorDoorL(i51).Enable True
      'ElevatorDoorL(i51).Enable True
      'Next i51
      'ShaftsFloor(CameraFloor).Enable True
      'For i51 = 1 To 40
      'CallButtons(i51).Enable True
      'Next i51
      Stairs(CameraFloor).Enable True
      'Atmos.SkyBox_Enable True
      'Call InitRealtime(CameraFloor)
      'InitObjectsForFloor (CameraFloor)
      ''If CameraFloor = 137 Then
      ''For i51 = 1 To 138
      ''Shafts(i51).Enable True
      ''Next i51
      If CameraFloor < 138 Then Stairs(CameraFloor + 1).Enable True
      If CameraFloor > 1 Then Stairs(CameraFloor - 1).Enable True
    Camera.SetPosition Camera.GetPosition.X, (CameraFloor * FloorHeight) + FloorHeight + 10 + PartialFloor, Camera.GetPosition.z
    End If
    If Camera.GetPosition.X <= -12.5 And Camera.GetPosition.X > -12.5 - 6 And Camera.GetPosition.z > -46.25 And Camera.GetPosition.z < -30.85 And Camera.GetPosition.Y = (CameraFloor * FloorHeight) + FloorHeight + 10 + (RiserHeight * 1) + PartialFloor Then Camera.SetPosition Camera.GetPosition.X, (CameraFloor * FloorHeight) + FloorHeight + 10 + PartialFloor, Camera.GetPosition.z
   
    If Camera.GetPosition.X <= -12.5 - 6 And Camera.GetPosition.X > -12.5 - 7.5 And Camera.GetPosition.z > -46.25 And Camera.GetPosition.z < -46.25 + 7.71 And Camera.GetPosition.Y = (CameraFloor * FloorHeight) + FloorHeight + 10 + PartialFloor Then
      Room(CameraFloor).Enable False
      For i51 = 1 To 40
      ElevatorDoorL(i51).Enable False
      ElevatorDoorL(i51).Enable False
      Next i51
      ShaftsFloor(CameraFloor).Enable False
      For i51 = 1 To 40
      CallButtons(i51).Enable False
      Next i51
      Atmos.SkyBox_Enable False
      DestroyObjects (CameraFloor)
      
      'Stairs(CameraFloor).Enable False
      If CameraFloor < 138 Then Stairs(CameraFloor + 1).Enable False
      If CameraFloor > 1 Then Stairs(CameraFloor - 1).Enable False
    If CameraFloor = 1 Then PartialFloor = PartialFloor - FloorHeight
    If CameraFloor = 2 Then PartialFloor = 0: CameraFloor = 1
    If CameraFloor = 1 And PartialFloor <= -(FloorHeight * 2) Then PartialFloor = -(FloorHeight * 2)
    If CameraFloor > 2 Then CameraFloor = CameraFloor - 1
     'Room(CameraFloor).Enable True
      'For i51 = 1 To 40
      'ElevatorDoorL(i51).Enable True
      'ElevatorDoorL(i51).Enable True
      'Next i51
      'For i51 = 1 To 40
      'CallButtons(i51).Enable True
      'Next i51
      'ShaftsFloor(CameraFloor).Enable True
      Stairs(CameraFloor).Enable True
      'Atmos.SkyBox_Enable True
      'Call InitRealtime(CameraFloor)
      'InitObjectsForFloor (CameraFloor)
      ''If CameraFloor = 137 Then
      ''For i51 = 1 To 138
      ''Shafts(i51).Enable True
      ''Next i51
      If CameraFloor < 138 Then Stairs(CameraFloor + 1).Enable True
      If CameraFloor > 1 Then Stairs(CameraFloor - 1).Enable True
    Camera.SetPosition Camera.GetPosition.X, (CameraFloor * FloorHeight) + FloorHeight + 10 + (RiserHeight * 15) + PartialFloor, Camera.GetPosition.z
    End If
    If Camera.GetPosition.Y <> 10 Then
    If Camera.GetPosition.X <= -12.5 - 6 And Camera.GetPosition.X > -12.5 - 7.5 And Camera.GetPosition.z > -46.25 And Camera.GetPosition.z < -46.25 + 7.71 And Camera.GetPosition.Y = (CameraFloor * FloorHeight) + FloorHeight + 10 + (RiserHeight * 14) + PartialFloor Then Camera.SetPosition Camera.GetPosition.X, (CameraFloor * FloorHeight) + FloorHeight + 10 + (RiserHeight * 15) + PartialFloor, Camera.GetPosition.z
    If Camera.GetPosition.X <= -12.5 - 7.5 And Camera.GetPosition.X > -12.5 - 9 And Camera.GetPosition.z > -46.25 And Camera.GetPosition.z < -46.25 + 7.71 Then Camera.SetPosition Camera.GetPosition.X, (CameraFloor * FloorHeight) + FloorHeight + 10 + (RiserHeight * 14) + PartialFloor, Camera.GetPosition.z
    If Camera.GetPosition.X <= -12.5 - 9 And Camera.GetPosition.X > -12.5 - 10.5 And Camera.GetPosition.z > -46.25 And Camera.GetPosition.z < -46.25 + 7.71 Then Camera.SetPosition Camera.GetPosition.X, (CameraFloor * FloorHeight) + FloorHeight + 10 + (RiserHeight * 13) + PartialFloor, Camera.GetPosition.z
    If Camera.GetPosition.X <= -12.5 - 10.5 And Camera.GetPosition.X > -12.5 - 12 And Camera.GetPosition.z > -46.25 And Camera.GetPosition.z < -46.25 + 7.71 Then Camera.SetPosition Camera.GetPosition.X, (CameraFloor * FloorHeight) + FloorHeight + 10 + (RiserHeight * 12) + PartialFloor, Camera.GetPosition.z
    If Camera.GetPosition.X <= -12.5 - 12 And Camera.GetPosition.X > -12.5 - 13.5 And Camera.GetPosition.z > -46.25 And Camera.GetPosition.z < -46.25 + 7.71 Then Camera.SetPosition Camera.GetPosition.X, (CameraFloor * FloorHeight) + FloorHeight + 10 + (RiserHeight * 11) + PartialFloor, Camera.GetPosition.z
    If Camera.GetPosition.X <= -12.5 - 13.5 And Camera.GetPosition.X > -12.5 - 15 And Camera.GetPosition.z > -46.25 And Camera.GetPosition.z < -46.25 + 7.71 Then Camera.SetPosition Camera.GetPosition.X, (CameraFloor * FloorHeight) + FloorHeight + 10 + (RiserHeight * 10) + PartialFloor, Camera.GetPosition.z
    If Camera.GetPosition.X <= -12.5 - 15 And Camera.GetPosition.X > -12.5 - 16 And Camera.GetPosition.z > -46.25 And Camera.GetPosition.z < -46.25 + 7.71 Then Camera.SetPosition Camera.GetPosition.X, (CameraFloor * FloorHeight) + FloorHeight + 10 + (RiserHeight * 9) + PartialFloor, Camera.GetPosition.z
    End If
    If Camera.GetPosition.Y = 10 And PartialFloor = -(FloorHeight * 2) Then PartialFloor = 0
    If Camera.GetPosition.X <= -12.5 - 6 And Camera.GetPosition.X > -12.5 - 7.5 And Camera.GetPosition.z > -46.25 + 7.71 And Camera.GetPosition.z < -30.85 And PartialFloor = 0 And Camera.GetPosition.Y = 10 Then PartialFloor = -(FloorHeight * 2)
    If Camera.GetPosition.X <= -12.5 - 6 And Camera.GetPosition.X > -12.5 - 7.5 And Camera.GetPosition.z > -46.25 + 7.71 And Camera.GetPosition.z < -30.85 Then Camera.SetPosition Camera.GetPosition.X, (CameraFloor * FloorHeight) + FloorHeight + 10 + (RiserHeight * 1) + PartialFloor, Camera.GetPosition.z
    If Camera.GetPosition.X <= -12.5 - 7.5 And Camera.GetPosition.X > -12.5 - 9 And Camera.GetPosition.z > -46.25 + 7.71 And Camera.GetPosition.z < -30.85 Then Camera.SetPosition Camera.GetPosition.X, (CameraFloor * FloorHeight) + FloorHeight + 10 + (RiserHeight * 2) + PartialFloor, Camera.GetPosition.z
    If Camera.GetPosition.X <= -12.5 - 9 And Camera.GetPosition.X > -12.5 - 10.5 And Camera.GetPosition.z > -46.25 + 7.71 And Camera.GetPosition.z < -30.85 Then Camera.SetPosition Camera.GetPosition.X, (CameraFloor * FloorHeight) + FloorHeight + 10 + (RiserHeight * 3) + PartialFloor, Camera.GetPosition.z
    If Camera.GetPosition.X <= -12.5 - 10.5 And Camera.GetPosition.X > -12.5 - 12 And Camera.GetPosition.z > -46.25 + 7.71 And Camera.GetPosition.z < -30.85 Then Camera.SetPosition Camera.GetPosition.X, (CameraFloor * FloorHeight) + FloorHeight + 10 + (RiserHeight * 4) + PartialFloor, Camera.GetPosition.z
    If Camera.GetPosition.X <= -12.5 - 12 And Camera.GetPosition.X > -12.5 - 13.5 And Camera.GetPosition.z > -46.25 + 7.71 And Camera.GetPosition.z < -30.85 Then Camera.SetPosition Camera.GetPosition.X, (CameraFloor * FloorHeight) + FloorHeight + 10 + (RiserHeight * 5) + PartialFloor, Camera.GetPosition.z
    If Camera.GetPosition.X <= -12.5 - 13.5 And Camera.GetPosition.X > -12.5 - 15 And Camera.GetPosition.z > -46.25 + 7.71 And Camera.GetPosition.z < -30.85 Then Camera.SetPosition Camera.GetPosition.X, (CameraFloor * FloorHeight) + FloorHeight + 10 + (RiserHeight * 6) + PartialFloor, Camera.GetPosition.z
    If Camera.GetPosition.X <= -12.5 - 15 And Camera.GetPosition.X > -12.5 - 16 And Camera.GetPosition.z > -46.25 + 7.71 And Camera.GetPosition.z < -30.85 Then Camera.SetPosition Camera.GetPosition.X, (CameraFloor * FloorHeight) + FloorHeight + 10 + (RiserHeight * 7) + PartialFloor, Camera.GetPosition.z
    If Camera.GetPosition.X <= -12.5 - 16 And Camera.GetPosition.X > -12.5 - 20 And Camera.GetPosition.z > -46.25 + 7.71 And Camera.GetPosition.z < -30.85 Then Camera.SetPosition Camera.GetPosition.X, (CameraFloor * FloorHeight) + FloorHeight + 10 + (RiserHeight * 8) + PartialFloor, Camera.GetPosition.z
    
End Sub

Sub ProcessMisc()
DoEvents
 

    Shafts1(1).AddWall GetTex("BrickTexture"), -12.5, -30.85, -32.5, -30.85, (FloorHeight * 3), 0, 2, 2
    For i = 2 To 138
    Shafts1(i).AddWall GetTex("BrickTexture"), -12.5, -30.85, -32.5, -30.85, 25, (FloorHeight * i) + FloorHeight, 2, 2
    Next i
    For i = 2 To 136
    Shafts2(i).AddWall GetTex("BrickTexture"), 12.5, -30.85, 32.5, -30.85, 25, (FloorHeight * i) + FloorHeight, 2, 2
    Next i
    
    'Stairway Doors for other floors
    For i = -1 To 138
    If i = 1 Then i = 2
    If i < 2 Then StairDoor(i).AddWall GetTex("StairsDoor2"), -3.9, 0, 3.9, 0, 19.5, (i * FloorHeight) + FloorHeight, 1, 1
    If i >= 2 Then StairDoor(i).AddWall GetTex("StairsDoor"), -3.9, 0, 3.9, 0, 19.5, (i * FloorHeight) + FloorHeight, 1, 1
    StairDoor(i).SetMeshName ("DoorSB " + Str$(i))
    StairDoor(i).SetRotation 0, 1.56, 0
    StairDoor(i).SetPosition -12.8, 0, -36.4
    Next i
    
    'Shafts.AddWall GetTex("Ceiling1"), -12.5 - 6, -46.25 + 7.71, -12.5 - 16, -46.25 + 7.71, (FloorHeight * 138) + FloorHeight, 0, 2, 139 * 2
        
    Stairs(1).AddWall GetTex("Concrete"), -12.5 - 6, -46.25, -12.5 - 6, -46.25 + 7.71, (FloorHeight - 6), 0, (7.71 * 0.086), (FloorHeight * 0.086)
    Stairs(138).AddWall GetTex("Concrete"), -12.5 - 6, -46.25 + 7.71, -12.5 - 6, -30.5, (FloorHeight), (138 * FloorHeight) + FloorHeight, (7.71 * 0.086), (FloorHeight * 0.086)
    
    'Shafts.AddFloor GetTex("BrickTexture"), -60, -150, 60, 150, (138 * FloorHeight) + FloorHeight, 10, 10

    'Elevator1
    'Old one Elevator1.AddFloor GetTex("BrickTexture"), -32, -30, -12, -16, 1
    Dim vv As Single
    Dim xx As Single
    For i = 1 To 4
    DoEvents
    If i = 1 Then j = 1
    If i = 2 Then j = 11
    If i = 3 Then j = 21
    If i = 4 Then j = 31
    
    If i = 1 Then vv = 28: xx = 12.5
    If i = 2 Then vv = 37: xx = 52.5
    If i = 3 Then vv = 106: xx = 90.5
    If i = 4 Then vv = 115: xx = 130.5
    
    Elevator(j).AddFloor GetTex("Wood2"), -vv, -29.9, -xx, -16, 0.1, 1, 1
    Elevator(j).AddFloor GetTex("Elev1"), -vv, -29.9, -xx, -16, 19.5, 2, 2
    Elevator(j).AddWall GetTex("Wood1"), -vv, -29.9, -xx, -29.9, 19.5, 0.1, 2, 2
    Elevator(j).AddWall GetTex("Wood1"), -vv, -16, -xx, -16, 19.5, 0.1, 2, 2
    Elevator(j).AddWall GetTex("Wood1"), -vv, -16, -vv, -29.9, 19.5, 0.1, 2, 2
    
    Elevator(j + 1).AddFloor GetTex("Wood2"), vv, -30, xx, -16, 0.1, 1, 1
    Elevator(j + 1).AddFloor GetTex("Elev1"), vv, -30, xx, -16, 19.5, 2, 2
    Elevator(j + 1).AddWall GetTex("Wood1"), vv, -30, xx, -30, 19.5, 0.1, 2, 2
    Elevator(j + 1).AddWall GetTex("Wood1"), vv, -16, xx, -16, 19.5, 0.1, 2, 2
    Elevator(j + 1).AddWall GetTex("Wood1"), vv, -16, vv, -30, 19.5, 0.1, 2, 2
    
    Elevator(j + 2).AddFloor GetTex("Wood2"), -vv, -15, -xx, -1, 0.1, 1, 1
    Elevator(j + 2).AddFloor GetTex("Elev1"), -vv, -15, -xx, -1, 19.5, 2, 2
    Elevator(j + 2).AddWall GetTex("Wood1"), -vv, -15, -xx, -15, 19.5, 0.1, 2, 2
    Elevator(j + 2).AddWall GetTex("Wood1"), -vv, -1, -xx, -1, 19.5, 0.1, 2, 2
    Elevator(j + 2).AddWall GetTex("Wood1"), -vv, -1, -vv, -15, 19.5, 0.1, 2, 2
    
    Elevator(j + 3).AddFloor GetTex("Wood2"), vv, -15, xx, -1, 0.1, 1, 1
    Elevator(j + 3).AddFloor GetTex("Elev1"), vv, -15, xx, -1, 19.5, 2, 2
    Elevator(j + 3).AddWall GetTex("Wood1"), vv, -15, xx, -15, 19.5, 0.1, 2, 2
    Elevator(j + 3).AddWall GetTex("Wood1"), vv, -1, xx, -1, 19.5, 0.1, 2, 2
    Elevator(j + 3).AddWall GetTex("Wood1"), vv, -1, vv, -15, 19.5, 0.1, 2, 2
    
    Elevator(j + 4).AddFloor GetTex("Wood2"), -vv, 0, -xx, 14, 0.1, 1, 1
    Elevator(j + 4).AddFloor GetTex("Elev1"), -vv, 0, -xx, 14, 19.5, 2, 2
    Elevator(j + 4).AddWall GetTex("Wood1"), -vv, 0, -xx, 0, 19.5, 0.1, 2, 2
    Elevator(j + 4).AddWall GetTex("Wood1"), -vv, 14, -xx, 14, 19.5, 0.1, 2, 2
    Elevator(j + 4).AddWall GetTex("Wood1"), -vv, 14, -vv, 0, 19.5, 0.1, 2, 2
    
    Elevator(j + 5).AddFloor GetTex("Wood2"), vv, 0, xx, 14, 0.1, 1, 1
    Elevator(j + 5).AddFloor GetTex("Elev1"), vv, 0, xx, 14, 19.5, 2, 2
    Elevator(j + 5).AddWall GetTex("Wood1"), vv, 0, xx, 0, 19.5, 0.1, 2, 2
    Elevator(j + 5).AddWall GetTex("Wood1"), vv, 14, xx, 14, 19.5, 0.1, 2, 2
    Elevator(j + 5).AddWall GetTex("Wood1"), vv, 14, vv, 0, 19.5, 0.1, 2, 2
    
    Elevator(j + 6).AddFloor GetTex("Wood2"), -vv, 15, -xx, 29, 0.1, 1, 1
    Elevator(j + 6).AddFloor GetTex("Elev1"), -vv, 15, -xx, 29, 19.5, 2, 2
    Elevator(j + 6).AddWall GetTex("Wood1"), -vv, 15, -xx, 15, 19.5, 0.1, 2, 2
    Elevator(j + 6).AddWall GetTex("Wood1"), -vv, 29, -xx, 29, 19.5, 0.1, 2, 2
    Elevator(j + 6).AddWall GetTex("Wood1"), -vv, 29, -vv, 15, 19.5, 0.1, 2, 2
    
    Elevator(j + 7).AddFloor GetTex("Wood2"), vv, 15, xx, 29, 0.1, 1, 1
    Elevator(j + 7).AddFloor GetTex("Elev1"), vv, 15, xx, 29, 19.5, 2, 2
    Elevator(j + 7).AddWall GetTex("Wood1"), vv, 15, xx, 15, 19.5, 0.1, 2, 2
    Elevator(j + 7).AddWall GetTex("Wood1"), vv, 29, xx, 29, 19.5, 0.1, 2, 2
    Elevator(j + 7).AddWall GetTex("Wood1"), vv, 29, vv, 15, 19.5, 0.1, 2, 2
    
    Elevator(j + 8).AddFloor GetTex("Wood2"), -vv, 30, -xx, 44, 0.1, 1, 1
    Elevator(j + 8).AddFloor GetTex("Elev1"), -vv, 30, -xx, 44, 19.5, 2, 2
    Elevator(j + 8).AddWall GetTex("Wood1"), -vv, 30, -xx, 30, 19.5, 0.1, 2, 2
    Elevator(j + 8).AddWall GetTex("Wood1"), -vv, 44, -xx, 44, 19.5, 0.1, 2, 2
    Elevator(j + 8).AddWall GetTex("Wood1"), -vv, 44, -vv, 30, 19.5, 0.1, 2, 2
    
    Elevator(j + 9).AddFloor GetTex("Wood2"), vv, 30, xx, 44, 0.1, 1, 1
    Elevator(j + 9).AddFloor GetTex("Elev1"), vv, 30, xx, 44, 19.5, 2, 2
    Elevator(j + 9).AddWall GetTex("Wood1"), vv, 30, xx, 30, 19.5, 0.1, 2, 2
    Elevator(j + 9).AddWall GetTex("Wood1"), vv, 44, xx, 44, 19.5, 0.1, 2, 2
    Elevator(j + 9).AddWall GetTex("Wood1"), vv, 44, vv, 30, 19.5, 0.1, 2, 2
   
   'Floor Indicator
    If i = 1 Or i = 3 Then
    FloorIndicator(j).AddWall GetTex("ButtonL"), -(xx + 0.16), -29.5, -(xx + 0.16), -27.5, 1.5, 16, -1, 1
    FloorIndicator(j + 1).AddWall GetTex("ButtonL"), (xx + 0.16), -18.5, (xx + 0.16), -16.5, 1.5, 16, 1, 1
    FloorIndicator(j + 2).AddWall GetTex("ButtonL"), -(xx + 0.16), -29.5 + (15 * 1), -(xx + 0.16), -27.5 + (15 * 1), 1.5, 16, -1, 1
    FloorIndicator(j + 3).AddWall GetTex("ButtonL"), (xx + 0.16), -18.5 + (15 * 1), (xx + 0.16), -16.5 + (15 * 1), 1.5, 16, 1, 1
    FloorIndicator(j + 4).AddWall GetTex("ButtonL"), -(xx + 0.16), -29.5 + (15 * 2), -(xx + 0.16), -27.5 + (15 * 2), 1.5, 16, -1, 1
    FloorIndicator(j + 5).AddWall GetTex("ButtonL"), (xx + 0.16), -18.5 + (15 * 2), (xx + 0.16), -16.5 + (15 * 2), 1.5, 16, 1, 1
    FloorIndicator(j + 6).AddWall GetTex("ButtonL"), -(xx + 0.16), -29.5 + (15 * 3), -(xx + 0.16), -27.5 + (15 * 3), 1.5, 16, -1, 1
    FloorIndicator(j + 7).AddWall GetTex("ButtonL"), (xx + 0.16), -18.5 + (15 * 3), (xx + 0.16), -16.5 + (15 * 3), 1.5, 16, 1, 1
    FloorIndicator(j + 8).AddWall GetTex("ButtonL"), -(xx + 0.16), -29.5 + (15 * 4), -(xx + 0.16), -27.5 + (15 * 4), 1.5, 16, -1, 1
    FloorIndicator(j + 9).AddWall GetTex("ButtonL"), (xx + 0.16), -18.5 + (15 * 4), (xx + 0.16), -16.5 + (15 * 4), 1.5, 16, 1, 1
    End If
    If i = 2 Or i = 4 Then
    FloorIndicator(j + 1).AddWall GetTex("ButtonL"), (xx - 0.16), -29.5, (xx - 0.16), -27.5, 1.5, 16, -1, 1
    FloorIndicator(j).AddWall GetTex("ButtonL"), -(xx - 0.16), -18.5, -(xx - 0.16), -16.5, 1.5, 16, 1, 1
    FloorIndicator(j + 3).AddWall GetTex("ButtonL"), (xx - 0.16), -29.5 + (15 * 1), (xx - 0.16), -27.5 + (15 * 1), 1.5, 16, -1, 1
    FloorIndicator(j + 2).AddWall GetTex("ButtonL"), -(xx - 0.16), -18.5 + (15 * 1), -(xx - 0.16), -16.5 + (15 * 1), 1.5, 16, 1, 1
    FloorIndicator(j + 5).AddWall GetTex("ButtonL"), (xx - 0.16), -29.5 + (15 * 2), (xx - 0.16), -27.5 + (15 * 2), 1.5, 16, -1, 1
    FloorIndicator(j + 4).AddWall GetTex("ButtonL"), -(xx - 0.16), -18.5 + (15 * 2), -(xx - 0.16), -16.5 + (15 * 2), 1.5, 16, 1, 1
    FloorIndicator(j + 7).AddWall GetTex("ButtonL"), (xx - 0.16), -29.5 + (15 * 3), (xx - 0.16), -27.5 + (15 * 3), 1.5, 16, -1, 1
    FloorIndicator(j + 6).AddWall GetTex("ButtonL"), -(xx - 0.16), -18.5 + (15 * 3), -(xx - 0.16), -16.5 + (15 * 3), 1.5, 16, 1, 1
    FloorIndicator(j + 9).AddWall GetTex("ButtonL"), (xx - 0.16), -29.5 + (15 * 4), (xx - 0.16), -27.5 + (15 * 4), 1.5, 16, -1, 1
    FloorIndicator(j + 8).AddWall GetTex("ButtonL"), -(xx - 0.16), -18.5 + (15 * 4), -(xx - 0.16), -16.5 + (15 * 4), 1.5, 16, 1, 1
    End If
    
   'Button Panel
    If i = 1 Or i = 3 Then
    Elevator(j).AddWall GetTex("ElevExtPanels"), -(xx + 0.16), -29.7, -(xx + 0.16), -27.3, 7, 6, 1, 1
    Elevator(j + 1).AddWall GetTex("ElevExtPanels"), (xx + 0.16), -18.7, (xx + 0.16), -16.3, 7, 6, 1, 1
    Elevator(j + 2).AddWall GetTex("ElevExtPanels"), -(xx + 0.16), -29.7 + (15 * 1), -(xx + 0.16), -27.3 + (15 * 1), 7, 6, 1, 1
    Elevator(j + 3).AddWall GetTex("ElevExtPanels"), (xx + 0.16), -18.7 + (15 * 1), (xx + 0.16), -16.3 + (15 * 1), 7, 6, 1, 1
    Elevator(j + 4).AddWall GetTex("ElevExtPanels"), -(xx + 0.16), -29.7 + (15 * 2), -(xx + 0.16), -27.3 + (15 * 2), 7, 6, 1, 1
    Elevator(j + 5).AddWall GetTex("ElevExtPanels"), (xx + 0.16), -18.7 + (15 * 2), (xx + 0.16), -16.3 + (15 * 2), 7, 6, 1, 1
    Elevator(j + 6).AddWall GetTex("ElevExtPanels"), -(xx + 0.16), -29.7 + (15 * 3), -(xx + 0.16), -27.3 + (15 * 3), 7, 6, 1, 1
    Elevator(j + 7).AddWall GetTex("ElevExtPanels"), (xx + 0.16), -18.7 + (15 * 3), (xx + 0.16), -16.3 + (15 * 3), 7, 6, 1, 1
    Elevator(j + 8).AddWall GetTex("ElevExtPanels"), -(xx + 0.16), -29.7 + (15 * 4), -(xx + 0.16), -27.3 + (15 * 4), 7, 6, 1, 1
    Elevator(j + 9).AddWall GetTex("ElevExtPanels"), (xx + 0.16), -18.7 + (15 * 4), (xx + 0.16), -16.3 + (15 * 4), 7, 6, 1, 1
    End If
    If i = 2 Or i = 4 Then
    Elevator(j + 1).AddWall GetTex("ElevExtPanels"), (xx - 0.16), -29.7, (xx - 0.16), -27.3, 7, 6, 1, 1
    Elevator(j).AddWall GetTex("ElevExtPanels"), -(xx - 0.16), -18.7, -(xx - 0.16), -16.3, 7, 6, 1, 1
    Elevator(j + 3).AddWall GetTex("ElevExtPanels"), (xx - 0.16), -29.7 + (15 * 1), (xx - 0.16), -27.3 + (15 * 1), 7, 6, 1, 1
    Elevator(j + 2).AddWall GetTex("ElevExtPanels"), -(xx - 0.16), -18.7 + (15 * 1), -(xx - 0.16), -16.3 + (15 * 1), 7, 6, 1, 1
    Elevator(j + 5).AddWall GetTex("ElevExtPanels"), (xx - 0.16), -29.7 + (15 * 2), (xx - 0.16), -27.3 + (15 * 2), 7, 6, 1, 1
    Elevator(j + 4).AddWall GetTex("ElevExtPanels"), -(xx - 0.16), -18.7 + (15 * 2), -(xx - 0.16), -16.3 + (15 * 2), 7, 6, 1, 1
    Elevator(j + 7).AddWall GetTex("ElevExtPanels"), (xx - 0.16), -29.7 + (15 * 3), (xx - 0.16), -27.3 + (15 * 3), 7, 6, 1, 1
    Elevator(j + 6).AddWall GetTex("ElevExtPanels"), -(xx - 0.16), -18.7 + (15 * 3), -(xx - 0.16), -16.3 + (15 * 3), 7, 6, 1, 1
    Elevator(j + 9).AddWall GetTex("ElevExtPanels"), (xx - 0.16), -29.7 + (15 * 4), (xx - 0.16), -27.3 + (15 * 4), 7, 6, 1, 1
    Elevator(j + 8).AddWall GetTex("ElevExtPanels"), -(xx - 0.16), -18.7 + (15 * 4), -(xx - 0.16), -16.3 + (15 * 4), 7, 6, 1, 1
    End If
   'Plaques
    If i = 1 Or i = 3 Then
    Plaque(j).AddWall GetTex("Plaque"), -(xx + 0.16), -29.7, -(xx + 0.16), -27.3, 1, 13, -1, 1
    Plaque(j).SetBlendingMode (TV_BLEND_ALPHA)
    Plaque(j).SetColor RGBA(1, 1, 1, 0.1)
    Plaque(j + 1).AddWall GetTex("Plaque"), (xx + 0.16), -18.7, (xx + 0.16), -16.3, 1, 13, 1, 1
    Plaque(j + 1).SetBlendingMode (TV_BLEND_ALPHA)
    Plaque(j + 1).SetColor RGBA(1, 1, 1, 0.1)
    Plaque(j + 2).AddWall GetTex("Plaque"), -(xx + 0.16), -29.7 + (15 * 1), -(xx + 0.16), -27.3 + (15 * 1), 1, 13, -1, 1
    Plaque(j + 2).SetBlendingMode (TV_BLEND_ALPHA)
    Plaque(j + 2).SetColor RGBA(1, 1, 1, 0.1)
    Plaque(j + 3).AddWall GetTex("Plaque"), (xx + 0.16), -18.7 + (15 * 1), (xx + 0.16), -16.3 + (15 * 1), 1, 13, 1, 1
    Plaque(j + 3).SetBlendingMode (TV_BLEND_ALPHA)
    Plaque(j + 3).SetColor RGBA(1, 1, 1, 0.1)
    Plaque(j + 4).AddWall GetTex("Plaque"), -(xx + 0.16), -29.7 + (15 * 2), -(xx + 0.16), -27.3 + (15 * 2), 1, 13, -1, 1
    Plaque(j + 4).SetBlendingMode (TV_BLEND_ALPHA)
    Plaque(j + 4).SetColor RGBA(1, 1, 1, 0.1)
    Plaque(j + 5).AddWall GetTex("Plaque"), (xx + 0.16), -18.7 + (15 * 2), (xx + 0.16), -16.3 + (15 * 2), 1, 13, 1, 1
    Plaque(j + 5).SetBlendingMode (TV_BLEND_ALPHA)
    Plaque(j + 5).SetColor RGBA(1, 1, 1, 0.1)
    Plaque(j + 6).AddWall GetTex("Plaque"), -(xx + 0.16), -29.7 + (15 * 3), -(xx + 0.16), -27.3 + (15 * 3), 1, 13, -1, 1
    Plaque(j + 6).SetBlendingMode (TV_BLEND_ALPHA)
    Plaque(j + 6).SetColor RGBA(1, 1, 1, 0.1)
    Plaque(j + 7).AddWall GetTex("Plaque"), (xx + 0.16), -18.7 + (15 * 3), (xx + 0.16), -16.3 + (15 * 3), 1, 13, 1, 1
    Plaque(j + 7).SetBlendingMode (TV_BLEND_ALPHA)
    Plaque(j + 7).SetColor RGBA(1, 1, 1, 0.1)
    Plaque(j + 8).AddWall GetTex("Plaque"), -(xx + 0.16), -29.7 + (15 * 4), -(xx + 0.16), -27.3 + (15 * 4), 1, 13, -1, 1
    Plaque(j + 8).SetBlendingMode (TV_BLEND_ALPHA)
    Plaque(j + 8).SetColor RGBA(1, 1, 1, 0.1)
    Plaque(j + 9).AddWall GetTex("Plaque"), (xx + 0.16), -18.7 + (15 * 4), (xx + 0.16), -16.3 + (15 * 4), 1, 13, 1, 1
    Plaque(j + 9).SetBlendingMode (TV_BLEND_ALPHA)
    Plaque(j + 9).SetColor RGBA(1, 1, 1, 0.1)
    End If
    If i = 2 Or i = 4 Then
    Plaque(j + 1).AddWall GetTex("Plaque"), (xx - 0.16), -29.7, (xx - 0.16), -27.3, 1, 13, -1, 1
    Plaque(j + 1).SetBlendingMode (TV_BLEND_ALPHA)
    Plaque(j + 1).SetColor RGBA(1, 1, 1, 0.1)
    Plaque(j).AddWall GetTex("Plaque"), -(xx - 0.16), -18.7, -(xx - 0.16), -16.3, 1, 13, 1, 1
    Plaque(j).SetBlendingMode (TV_BLEND_ALPHA)
    Plaque(j).SetColor RGBA(1, 1, 1, 0.1)
    Plaque(j + 3).AddWall GetTex("Plaque"), (xx - 0.16), -29.7 + (15 * 1), (xx - 0.16), -27.3 + (15 * 1), 1, 13, -1, 1
    Plaque(j + 3).SetBlendingMode (TV_BLEND_ALPHA)
    Plaque(j + 3).SetColor RGBA(1, 1, 1, 0.1)
    Plaque(j + 2).AddWall GetTex("Plaque"), -(xx - 0.16), -18.7 + (15 * 1), -(xx - 0.16), -16.3 + (15 * 1), 1, 13, 1, 1
    Plaque(j + 2).SetBlendingMode (TV_BLEND_ALPHA)
    Plaque(j + 2).SetColor RGBA(1, 1, 1, 0.1)
    Plaque(j + 5).AddWall GetTex("Plaque"), (xx - 0.16), -29.7 + (15 * 2), (xx - 0.16), -27.3 + (15 * 2), 1, 13, -1, 1
    Plaque(j + 5).SetBlendingMode (TV_BLEND_ALPHA)
    Plaque(j + 5).SetColor RGBA(1, 1, 1, 0.1)
    Plaque(j + 4).AddWall GetTex("Plaque"), -(xx - 0.16), -18.7 + (15 * 2), -(xx - 0.16), -16.3 + (15 * 2), 1, 13, 1, 1
    Plaque(j + 4).SetBlendingMode (TV_BLEND_ALPHA)
    Plaque(j + 4).SetColor RGBA(1, 1, 1, 0.1)
    Plaque(j + 7).AddWall GetTex("Plaque"), (xx - 0.16), -29.7 + (15 * 3), (xx - 0.16), -27.3 + (15 * 3), 1, 13, -1, 1
    Plaque(j + 7).SetBlendingMode (TV_BLEND_ALPHA)
    Plaque(j + 7).SetColor RGBA(1, 1, 1, 0.1)
    Plaque(j + 6).AddWall GetTex("Plaque"), -(xx - 0.16), -18.7 + (15 * 3), -(xx - 0.16), -16.3 + (15 * 3), 1, 13, 1, 1
    Plaque(j + 6).SetBlendingMode (TV_BLEND_ALPHA)
    Plaque(j + 6).SetColor RGBA(1, 1, 1, 0.1)
    Plaque(j + 9).AddWall GetTex("Plaque"), (xx - 0.16), -29.7 + (15 * 4), (xx - 0.16), -27.3 + (15 * 4), 1, 13, -1, 1
    Plaque(j + 9).SetBlendingMode (TV_BLEND_ALPHA)
    Plaque(j + 9).SetColor RGBA(1, 1, 1, 0.1)
    Plaque(j + 8).AddWall GetTex("Plaque"), -(xx - 0.16), -18.7 + (15 * 4), -(xx - 0.16), -16.3 + (15 * 4), 1, 13, 1, 1
    Plaque(j + 8).SetBlendingMode (TV_BLEND_ALPHA)
    Plaque(j + 8).SetColor RGBA(1, 1, 1, 0.1)
    End If
    'Interior Panels
    If i = 1 Or i = 3 Then
    Elevator(j).AddWall GetTex("Marble3"), -(xx + 0.15), -16, -(xx + 0.15), -19, 19.5, 0.1, 1, 1
    Elevator(j).AddWall GetTex("Marble3"), -(xx + 0.15), -30, -(xx + 0.15), -27, 19.5, 0.1, 1, 1
    Elevator(j + 1).AddWall GetTex("Marble3"), (xx + 0.15), -16, (xx + 0.15), -19, 19.5, 0.1, 1, 1
    Elevator(j + 1).AddWall GetTex("Marble3"), (xx + 0.15), -30, (xx + 0.15), -27, 19.5, 0.1, 1, 1
    Elevator(j + 2).AddWall GetTex("Marble3"), -(xx + 0.15), -16 + (15 * 1), -(xx + 0.15), -19 + (15 * 1), 19.5, 0.1, 1, 1
    Elevator(j + 2).AddWall GetTex("Marble3"), -(xx + 0.15), -30 + (15 * 1), -(xx + 0.15), -27 + (15 * 1), 19.5, 0.1, 1, 1
    Elevator(j + 3).AddWall GetTex("Marble3"), (xx + 0.15), -16 + (15 * 1), (xx + 0.15), -19 + (15 * 1), 19.5, 0.1, 1, 1
    Elevator(j + 3).AddWall GetTex("Marble3"), (xx + 0.15), -30 + (15 * 1), (xx + 0.15), -27 + (15 * 1), 19.5, 0.1, 1, 1
    Elevator(j + 4).AddWall GetTex("Marble3"), -(xx + 0.15), -16 + (15 * 2), -(xx + 0.15), -19 + (15 * 2), 19.5, 0.1, 1, 1
    Elevator(j + 4).AddWall GetTex("Marble3"), -(xx + 0.15), -30 + (15 * 2), -(xx + 0.15), -27 + (15 * 2), 19.5, 0.1, 1, 1
    Elevator(j + 5).AddWall GetTex("Marble3"), (xx + 0.15), -16 + (15 * 2), (xx + 0.15), -19 + (15 * 2), 19.5, 0.1, 1, 1
    Elevator(j + 5).AddWall GetTex("Marble3"), (xx + 0.15), -30 + (15 * 2), (xx + 0.15), -27 + (15 * 2), 19.5, 0.1, 1, 1
    Elevator(j + 6).AddWall GetTex("Marble3"), -(xx + 0.15), -16 + (15 * 3), -(xx + 0.15), -19 + (15 * 3), 19.5, 0.1, 1, 1
    Elevator(j + 6).AddWall GetTex("Marble3"), -(xx + 0.15), -30 + (15 * 3), -(xx + 0.15), -27 + (15 * 3), 19.5, 0.1, 1, 1
    Elevator(j + 7).AddWall GetTex("Marble3"), (xx + 0.15), -16 + (15 * 3), (xx + 0.15), -19 + (15 * 3), 19.5, 0.1, 1, 1
    Elevator(j + 7).AddWall GetTex("Marble3"), (xx + 0.15), -30 + (15 * 3), (xx + 0.15), -27 + (15 * 3), 19.5, 0.1, 1, 1
    Elevator(j + 8).AddWall GetTex("Marble3"), -(xx + 0.15), -16 + (15 * 4), -(xx + 0.15), -19 + (15 * 4), 19.5, 0.1, 1, 1
    Elevator(j + 8).AddWall GetTex("Marble3"), -(xx + 0.15), -30 + (15 * 4), -(xx + 0.15), -27 + (15 * 4), 19.5, 0.1, 1, 1
    Elevator(j + 9).AddWall GetTex("Marble3"), (xx + 0.15), -16 + (15 * 4), (xx + 0.15), -19 + (15 * 4), 19.5, 0.1, 1, 1
    Elevator(j + 9).AddWall GetTex("Marble3"), (xx + 0.15), -30 + (15 * 4), (xx + 0.15), -27 + (15 * 4), 19.5, 0.1, 1, 1
    End If
    If i = 2 Or i = 4 Then
    Elevator(j + 1).AddWall GetTex("Marble3"), (xx - 0.15), -16, (xx - 0.15), -19, 19.5, 0.1, 1, 1
    Elevator(j + 1).AddWall GetTex("Marble3"), (xx - 0.15), -30, (xx - 0.15), -27, 19.5, 0.1, 1, 1
    Elevator(j).AddWall GetTex("Marble3"), -(xx - 0.15), -16, -(xx - 0.15), -19, 19.5, 0.1, 1, 1
    Elevator(j).AddWall GetTex("Marble3"), -(xx - 0.15), -30, -(xx - 0.15), -27, 19.5, 0.1, 1, 1
    Elevator(j + 3).AddWall GetTex("Marble3"), (xx - 0.15), -16 + (15 * 1), (xx - 0.15), -19 + (15 * 1), 19.5, 0.1, 1, 1
    Elevator(j + 3).AddWall GetTex("Marble3"), (xx - 0.15), -30 + (15 * 1), (xx - 0.15), -27 + (15 * 1), 19.5, 0.1, 1, 1
    Elevator(j + 2).AddWall GetTex("Marble3"), -(xx - 0.15), -16 + (15 * 1), -(xx - 0.15), -19 + (15 * 1), 19.5, 0.1, 1, 1
    Elevator(j + 2).AddWall GetTex("Marble3"), -(xx - 0.15), -30 + (15 * 1), -(xx - 0.15), -27 + (15 * 1), 19.5, 0.1, 1, 1
    Elevator(j + 5).AddWall GetTex("Marble3"), (xx - 0.15), -16 + (15 * 2), (xx - 0.15), -19 + (15 * 2), 19.5, 0.1, 1, 1
    Elevator(j + 5).AddWall GetTex("Marble3"), (xx - 0.15), -30 + (15 * 2), (xx - 0.15), -27 + (15 * 2), 19.5, 0.1, 1, 1
    Elevator(j + 4).AddWall GetTex("Marble3"), -(xx - 0.15), -16 + (15 * 2), -(xx - 0.15), -19 + (15 * 2), 19.5, 0.1, 1, 1
    Elevator(j + 4).AddWall GetTex("Marble3"), -(xx - 0.15), -30 + (15 * 2), -(xx - 0.15), -27 + (15 * 2), 19.5, 0.1, 1, 1
    Elevator(j + 7).AddWall GetTex("Marble3"), (xx - 0.15), -16 + (15 * 3), (xx - 0.15), -19 + (15 * 3), 19.5, 0.1, 1, 1
    Elevator(j + 7).AddWall GetTex("Marble3"), (xx - 0.15), -30 + (15 * 3), (xx - 0.15), -27 + (15 * 3), 19.5, 0.1, 1, 1
    Elevator(j + 6).AddWall GetTex("Marble3"), -(xx - 0.15), -16 + (15 * 3), -(xx - 0.15), -19 + (15 * 3), 19.5, 0.1, 1, 1
    Elevator(j + 6).AddWall GetTex("Marble3"), -(xx - 0.15), -30 + (15 * 3), -(xx - 0.15), -27 + (15 * 3), 19.5, 0.1, 1, 1
    Elevator(j + 9).AddWall GetTex("Marble3"), (xx - 0.15), -16 + (15 * 4), (xx - 0.15), -19 + (15 * 4), 19.5, 0.1, 1, 1
    Elevator(j + 9).AddWall GetTex("Marble3"), (xx - 0.15), -30 + (15 * 4), (xx - 0.15), -27 + (15 * 4), 19.5, 0.1, 1, 1
    Elevator(j + 8).AddWall GetTex("Marble3"), -(xx - 0.15), -16 + (15 * 4), -(xx - 0.15), -19 + (15 * 4), 19.5, 0.1, 1, 1
    Elevator(j + 8).AddWall GetTex("Marble3"), -(xx - 0.15), -30 + (15 * 4), -(xx - 0.15), -27 + (15 * 4), 19.5, 0.1, 1, 1
    End If
    'Interior Doors
    If i = 1 Or i = 3 Then
    ElevatorInsDoorL(j).AddWall GetTex("ElevDoors"), -(xx + 0.1), -19.05, -(xx + 0.1), -22.95, 19.5, 0.1, 1, 1
    ElevatorInsDoorR(j).AddWall GetTex("ElevDoors"), -(xx + 0.1), -23.05, -(xx + 0.1), -27.05, 19.5, 0.1, 1, 1
    ElevatorInsDoorL(j + 1).AddWall GetTex("ElevDoors"), (xx + 0.1), -19.05, (xx + 0.1), -22.95, 19.5, 0.1, 1, 1
    ElevatorInsDoorR(j + 1).AddWall GetTex("ElevDoors"), (xx + 0.1), -23.05, (xx + 0.1), -27.05, 19.5, 0.1, 1, 1
    ElevatorInsDoorL(j + 2).AddWall GetTex("ElevDoors"), -(xx + 0.1), -19.05 + (15 * 1), -(xx + 0.1), -22.95 + (15 * 1), 19.5, 0.1, 1, 1
    ElevatorInsDoorR(j + 2).AddWall GetTex("ElevDoors"), -(xx + 0.1), -23.05 + (15 * 1), -(xx + 0.1), -27.05 + (15 * 1), 19.5, 0.1, 1, 1
    ElevatorInsDoorL(j + 3).AddWall GetTex("ElevDoors"), (xx + 0.1), -19.05 + (15 * 1), (xx + 0.1), -22.95 + (15 * 1), 19.5, 0.1, 1, 1
    ElevatorInsDoorR(j + 3).AddWall GetTex("ElevDoors"), (xx + 0.1), -23.05 + (15 * 1), (xx + 0.1), -27.05 + (15 * 1), 19.5, 0.1, 1, 1
    ElevatorInsDoorL(j + 4).AddWall GetTex("ElevDoors"), -(xx + 0.1), -19.05 + (15 * 2), -(xx + 0.1), -22.95 + (15 * 2), 19.5, 0.1, 1, 1
    ElevatorInsDoorR(j + 4).AddWall GetTex("ElevDoors"), -(xx + 0.1), -23.05 + (15 * 2), -(xx + 0.1), -27.05 + (15 * 2), 19.5, 0.1, 1, 1
    ElevatorInsDoorL(j + 5).AddWall GetTex("ElevDoors"), (xx + 0.1), -19.05 + (15 * 2), (xx + 0.1), -22.95 + (15 * 2), 19.5, 0.1, 1, 1
    ElevatorInsDoorR(j + 5).AddWall GetTex("ElevDoors"), (xx + 0.1), -23.05 + (15 * 2), (xx + 0.1), -27.05 + (15 * 2), 19.5, 0.1, 1, 1
    ElevatorInsDoorL(j + 6).AddWall GetTex("ElevDoors"), -(xx + 0.1), -19.05 + (15 * 3), -(xx + 0.1), -22.95 + (15 * 3), 19.5, 0.1, 1, 1
    ElevatorInsDoorR(j + 6).AddWall GetTex("ElevDoors"), -(xx + 0.1), -23.05 + (15 * 3), -(xx + 0.1), -27.05 + (15 * 3), 19.5, 0.1, 1, 1
    ElevatorInsDoorL(j + 7).AddWall GetTex("ElevDoors"), (xx + 0.1), -19.05 + (15 * 3), (xx + 0.1), -22.95 + (15 * 3), 19.5, 0.1, 1, 1
    ElevatorInsDoorR(j + 7).AddWall GetTex("ElevDoors"), (xx + 0.1), -23.05 + (15 * 3), (xx + 0.1), -27.05 + (15 * 3), 19.5, 0.1, 1, 1
    ElevatorInsDoorL(j + 8).AddWall GetTex("ElevDoors"), -(xx + 0.1), -19.05 + (15 * 4), -(xx + 0.1), -22.95 + (15 * 4), 19.5, 0.1, 1, 1
    ElevatorInsDoorR(j + 8).AddWall GetTex("ElevDoors"), -(xx + 0.1), -23.05 + (15 * 4), -(xx + 0.1), -27.05 + (15 * 4), 19.5, 0.1, 1, 1
    ElevatorInsDoorL(j + 9).AddWall GetTex("ElevDoors"), (xx + 0.1), -19.05 + (15 * 4), (xx + 0.1), -22.95 + (15 * 4), 19.5, 0.1, 1, 1
    ElevatorInsDoorR(j + 9).AddWall GetTex("ElevDoors"), (xx + 0.1), -23.05 + (15 * 4), (xx + 0.1), -27.05 + (15 * 4), 19.5, 0.1, 1, 1
    End If
    If i = 2 Or i = 4 Then
    ElevatorInsDoorL(j + 1).AddWall GetTex("ElevDoors"), (xx - 0.1), -19.05, (xx - 0.1), -22.95, 19.5, 0.1, 1, 1
    ElevatorInsDoorR(j + 1).AddWall GetTex("ElevDoors"), (xx - 0.1), -23.05, (xx - 0.1), -27.05, 19.5, 0.1, 1, 1
    ElevatorInsDoorL(j).AddWall GetTex("ElevDoors"), -(xx - 0.1), -19.05, -(xx - 0.1), -22.95, 19.5, 0.1, 1, 1
    ElevatorInsDoorR(j).AddWall GetTex("ElevDoors"), -(xx - 0.1), -23.05, -(xx - 0.1), -27.05, 19.5, 0.1, 1, 1
    ElevatorInsDoorL(j + 3).AddWall GetTex("ElevDoors"), (xx - 0.1), -19.05 + (15 * 1), (xx - 0.1), -22.95 + (15 * 1), 19.5, 0.1, 1, 1
    ElevatorInsDoorR(j + 3).AddWall GetTex("ElevDoors"), (xx - 0.1), -23.05 + (15 * 1), (xx - 0.1), -27.05 + (15 * 1), 19.5, 0.1, 1, 1
    ElevatorInsDoorL(j + 2).AddWall GetTex("ElevDoors"), -(xx - 0.1), -19.05 + (15 * 1), -(xx - 0.1), -22.95 + (15 * 1), 19.5, 0.1, 1, 1
    ElevatorInsDoorR(j + 2).AddWall GetTex("ElevDoors"), -(xx - 0.1), -23.05 + (15 * 1), -(xx - 0.1), -27.05 + (15 * 1), 19.5, 0.1, 1, 1
    ElevatorInsDoorL(j + 5).AddWall GetTex("ElevDoors"), (xx - 0.1), -19.05 + (15 * 2), (xx - 0.1), -22.95 + (15 * 2), 19.5, 0.1, 1, 1
    ElevatorInsDoorR(j + 5).AddWall GetTex("ElevDoors"), (xx - 0.1), -23.05 + (15 * 2), (xx - 0.1), -27.05 + (15 * 2), 19.5, 0.1, 1, 1
    ElevatorInsDoorL(j + 4).AddWall GetTex("ElevDoors"), -(xx - 0.1), -19.05 + (15 * 2), -(xx - 0.1), -22.95 + (15 * 2), 19.5, 0.1, 1, 1
    ElevatorInsDoorR(j + 4).AddWall GetTex("ElevDoors"), -(xx - 0.1), -23.05 + (15 * 2), -(xx - 0.1), -27.05 + (15 * 2), 19.5, 0.1, 1, 1
    ElevatorInsDoorL(j + 7).AddWall GetTex("ElevDoors"), (xx - 0.1), -19.05 + (15 * 3), (xx - 0.1), -22.95 + (15 * 3), 19.5, 0.1, 1, 1
    ElevatorInsDoorR(j + 7).AddWall GetTex("ElevDoors"), (xx - 0.1), -23.05 + (15 * 3), (xx - 0.1), -27.05 + (15 * 3), 19.5, 0.1, 1, 1
    ElevatorInsDoorL(j + 6).AddWall GetTex("ElevDoors"), -(xx - 0.1), -19.05 + (15 * 3), -(xx - 0.1), -22.95 + (15 * 3), 19.5, 0.1, 1, 1
    ElevatorInsDoorR(j + 6).AddWall GetTex("ElevDoors"), -(xx - 0.1), -23.05 + (15 * 3), -(xx - 0.1), -27.05 + (15 * 3), 19.5, 0.1, 1, 1
    ElevatorInsDoorL(j + 9).AddWall GetTex("ElevDoors"), (xx - 0.1), -19.05 + (15 * 4), (xx - 0.1), -22.95 + (15 * 4), 19.5, 0.1, 1, 1
    ElevatorInsDoorR(j + 9).AddWall GetTex("ElevDoors"), (xx - 0.1), -23.05 + (15 * 4), (xx - 0.1), -27.05 + (15 * 4), 19.5, 0.1, 1, 1
    ElevatorInsDoorL(j + 8).AddWall GetTex("ElevDoors"), -(xx - 0.1), -19.05 + (15 * 4), -(xx - 0.1), -22.95 + (15 * 4), 19.5, 0.1, 1, 1
    ElevatorInsDoorR(j + 8).AddWall GetTex("ElevDoors"), -(xx - 0.1), -23.05 + (15 * 4), -(xx - 0.1), -27.05 + (15 * 4), 19.5, 0.1, 1, 1
    End If
    Next i
    
    'Move some elevators to their starting places
    Elevator(5).SetPosition Elevator(5).GetPosition.X, (80 * FloorHeight) + FloorHeight, Elevator(5).GetPosition.z
    Elevator(6).SetPosition Elevator(6).GetPosition.X, (80 * FloorHeight) + FloorHeight, Elevator(6).GetPosition.z
    Elevator(7).SetPosition Elevator(7).GetPosition.X, (80 * FloorHeight) + FloorHeight, Elevator(7).GetPosition.z
    Elevator(8).SetPosition Elevator(8).GetPosition.X, (80 * FloorHeight) + FloorHeight, Elevator(8).GetPosition.z
    Elevator(9).SetPosition Elevator(9).GetPosition.X, (80 * FloorHeight) + FloorHeight, Elevator(9).GetPosition.z
    Elevator(10).SetPosition Elevator(10).GetPosition.X, (80 * FloorHeight) + FloorHeight, Elevator(10).GetPosition.z
    Elevator(15).SetPosition Elevator(5).GetPosition.X, (80 * FloorHeight) + FloorHeight, Elevator(5).GetPosition.z
    Elevator(16).SetPosition Elevator(6).GetPosition.X, (80 * FloorHeight) + FloorHeight, Elevator(6).GetPosition.z
    Elevator(17).SetPosition Elevator(7).GetPosition.X, (80 * FloorHeight) + FloorHeight, Elevator(7).GetPosition.z
    Elevator(18).SetPosition Elevator(8).GetPosition.X, (80 * FloorHeight) + FloorHeight, Elevator(8).GetPosition.z
    Elevator(19).SetPosition Elevator(9).GetPosition.X, (80 * FloorHeight) + FloorHeight, Elevator(9).GetPosition.z
    Elevator(20).SetPosition Elevator(10).GetPosition.X, (80 * FloorHeight) + FloorHeight, Elevator(10).GetPosition.z
    ElevatorFloor(5) = 80
    ElevatorFloor(6) = 80
    ElevatorFloor(7) = 80
    ElevatorFloor(8) = 80
    ElevatorFloor(9) = 80
    ElevatorFloor(10) = 80
    ElevatorFloor(15) = 80
    ElevatorFloor(16) = 80
    ElevatorFloor(17) = 80
    ElevatorFloor(18) = 80
    ElevatorFloor(19) = 80
    ElevatorFloor(20) = 80
    
    ElevatorInsDoorL(5).SetPosition ElevatorInsDoorL(5).GetPosition.X, (80 * FloorHeight) + FloorHeight, ElevatorInsDoorL(5).GetPosition.z
    ElevatorInsDoorL(6).SetPosition ElevatorInsDoorL(6).GetPosition.X, (80 * FloorHeight) + FloorHeight, ElevatorInsDoorL(6).GetPosition.z
    ElevatorInsDoorL(7).SetPosition ElevatorInsDoorL(7).GetPosition.X, (80 * FloorHeight) + FloorHeight, ElevatorInsDoorL(7).GetPosition.z
    ElevatorInsDoorL(8).SetPosition ElevatorInsDoorL(8).GetPosition.X, (80 * FloorHeight) + FloorHeight, ElevatorInsDoorL(8).GetPosition.z
    ElevatorInsDoorL(9).SetPosition ElevatorInsDoorL(9).GetPosition.X, (80 * FloorHeight) + FloorHeight, ElevatorInsDoorL(9).GetPosition.z
    ElevatorInsDoorL(10).SetPosition ElevatorInsDoorL(10).GetPosition.X, (80 * FloorHeight) + FloorHeight, ElevatorInsDoorL(10).GetPosition.z
    ElevatorInsDoorL(15).SetPosition ElevatorInsDoorL(5).GetPosition.X, (80 * FloorHeight) + FloorHeight, ElevatorInsDoorL(5).GetPosition.z
    ElevatorInsDoorL(16).SetPosition ElevatorInsDoorL(6).GetPosition.X, (80 * FloorHeight) + FloorHeight, ElevatorInsDoorL(6).GetPosition.z
    ElevatorInsDoorL(17).SetPosition ElevatorInsDoorL(7).GetPosition.X, (80 * FloorHeight) + FloorHeight, ElevatorInsDoorL(7).GetPosition.z
    ElevatorInsDoorL(18).SetPosition ElevatorInsDoorL(8).GetPosition.X, (80 * FloorHeight) + FloorHeight, ElevatorInsDoorL(8).GetPosition.z
    ElevatorInsDoorL(19).SetPosition ElevatorInsDoorL(9).GetPosition.X, (80 * FloorHeight) + FloorHeight, ElevatorInsDoorL(9).GetPosition.z
    ElevatorInsDoorL(20).SetPosition ElevatorInsDoorL(10).GetPosition.X, (80 * FloorHeight) + FloorHeight, ElevatorInsDoorL(10).GetPosition.z
    ElevatorInsDoorR(5).SetPosition ElevatorInsDoorR(5).GetPosition.X, (80 * FloorHeight) + FloorHeight, ElevatorInsDoorR(5).GetPosition.z
    ElevatorInsDoorR(6).SetPosition ElevatorInsDoorR(6).GetPosition.X, (80 * FloorHeight) + FloorHeight, ElevatorInsDoorR(6).GetPosition.z
    ElevatorInsDoorR(7).SetPosition ElevatorInsDoorR(7).GetPosition.X, (80 * FloorHeight) + FloorHeight, ElevatorInsDoorR(7).GetPosition.z
    ElevatorInsDoorR(8).SetPosition ElevatorInsDoorR(8).GetPosition.X, (80 * FloorHeight) + FloorHeight, ElevatorInsDoorR(8).GetPosition.z
    ElevatorInsDoorR(9).SetPosition ElevatorInsDoorR(9).GetPosition.X, (80 * FloorHeight) + FloorHeight, ElevatorInsDoorR(9).GetPosition.z
    ElevatorInsDoorR(10).SetPosition ElevatorInsDoorR(10).GetPosition.X, (80 * FloorHeight) + FloorHeight, ElevatorInsDoorR(10).GetPosition.z
    ElevatorInsDoorR(15).SetPosition ElevatorInsDoorR(5).GetPosition.X, (80 * FloorHeight) + FloorHeight, ElevatorInsDoorR(5).GetPosition.z
    ElevatorInsDoorR(16).SetPosition ElevatorInsDoorR(6).GetPosition.X, (80 * FloorHeight) + FloorHeight, ElevatorInsDoorR(6).GetPosition.z
    ElevatorInsDoorR(17).SetPosition ElevatorInsDoorR(7).GetPosition.X, (80 * FloorHeight) + FloorHeight, ElevatorInsDoorR(7).GetPosition.z
    ElevatorInsDoorR(18).SetPosition ElevatorInsDoorR(8).GetPosition.X, (80 * FloorHeight) + FloorHeight, ElevatorInsDoorR(8).GetPosition.z
    ElevatorInsDoorR(19).SetPosition ElevatorInsDoorR(9).GetPosition.X, (80 * FloorHeight) + FloorHeight, ElevatorInsDoorR(9).GetPosition.z
    ElevatorInsDoorR(20).SetPosition ElevatorInsDoorR(10).GetPosition.X, (80 * FloorHeight) + FloorHeight, ElevatorInsDoorR(10).GetPosition.z
    
End Sub

Sub ProcessStairs()
    
i = 1
'Stairs on the first floor, section 1
    Dim RiserHeight As Single
    RiserHeight = FloorHeight / 16
    
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 6, -46.25 + 7.71, -12.5 - 6, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 0) - FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 7.5, -46.25 + 7.71, -12.5 - 7.5, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 1) - FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 9, -46.25 + 7.71, -12.5 - 9, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 2) - FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 10.5, -46.25 + 7.71, -12.5 - 10.5, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 3) - FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 12, -46.25 + 7.71, -12.5 - 12, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 4) - FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 13.5, -46.25 + 7.71, -12.5 - 13.5, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 5) - FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 15, -46.25 + 7.71, -12.5 - 15, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 6) - FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 16, -46.25 + 7.71, -12.5 - 16, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 7) - FloorHeight
    
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 6, -46.25 + 7.71, -12.5 - 7.5, -30.85, (i * FloorHeight) + (RiserHeight * 1) - FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 7.5, -46.25 + 7.71, -12.5 - 9, -30.85, (i * FloorHeight) + (RiserHeight * 2) - FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 9, -46.25 + 7.71, -12.5 - 10.5, -30.85, (i * FloorHeight) + (RiserHeight * 3) - FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 10.5, -46.25 + 7.71, -12.5 - 12, -30.85, (i * FloorHeight) + (RiserHeight * 4) - FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 12, -46.25 + 7.71, -12.5 - 13.5, -30.85, (i * FloorHeight) + (RiserHeight * 5) - FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 13.5, -46.25 + 7.71, -12.5 - 15, -30.85, (i * FloorHeight) + (RiserHeight * 6) - FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 15, -46.25 + 7.71, -12.5 - 16, -30.85, (i * FloorHeight) + (RiserHeight * 7) - FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 16, -46.25, -12.5 - 20, -30.85, (i * FloorHeight) + (RiserHeight * 8) - FloorHeight
    
    Stairs(i).AddFloor GetTex("stairs"), -12.5, -46.25, -12.5 - 6, -30.85, (i * FloorHeight) + FloorHeight - FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 6, -46.25 + 7.71, -12.5 - 7.5, -46.25, (i * FloorHeight) + (RiserHeight * 15) - FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 7.5, -46.25 + 7.71, -12.5 - 9, -46.25, (i * FloorHeight) + (RiserHeight * 14) - FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 9, -46.25 + 7.71, -12.5 - 10.5, -46.25, (i * FloorHeight) + (RiserHeight * 13) - FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 10.5, -46.25 + 7.71, -12.5 - 12, -46.25, (i * FloorHeight) + (RiserHeight * 12) - FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 12, -46.25 + 7.71, -12.5 - 13.5, -46.25, (i * FloorHeight) + (RiserHeight * 11) - FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 13.5, -46.25 + 7.71, -12.5 - 15, -46.25, (i * FloorHeight) + (RiserHeight * 10) - FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 15, -46.25 + 7.71, -12.5 - 16, -46.25, (i * FloorHeight) + (RiserHeight * 9) - FloorHeight
    
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 6, -46.25, -12.5 - 6, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 15) - FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 7.5, -46.25, -12.5 - 7.5, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 14) - FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 9, -46.25, -12.5 - 9, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 13) - FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 10.5, -46.25, -12.5 - 10.5, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 12) - FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 12, -46.25, -12.5 - 12, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 11) - FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 13.5, -46.25, -12.5 - 13.5, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 10) - FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 15, -46.25, -12.5 - 15, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 9) - FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 16, -46.25, -12.5 - 16, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 8) - FloorHeight

'Stairs on the first floor, section 2
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 6, -46.25 + 7.71, -12.5 - 6, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 0)
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 7.5, -46.25 + 7.71, -12.5 - 7.5, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 1)
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 9, -46.25 + 7.71, -12.5 - 9, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 2)
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 10.5, -46.25 + 7.71, -12.5 - 10.5, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 3)
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 12, -46.25 + 7.71, -12.5 - 12, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 4)
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 13.5, -46.25 + 7.71, -12.5 - 13.5, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 5)
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 15, -46.25 + 7.71, -12.5 - 15, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 6)
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 16, -46.25 + 7.71, -12.5 - 16, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 7)
    
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 6, -46.25 + 7.71, -12.5 - 7.5, -30.85, (i * FloorHeight) + (RiserHeight * 1)
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 7.5, -46.25 + 7.71, -12.5 - 9, -30.85, (i * FloorHeight) + (RiserHeight * 2)
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 9, -46.25 + 7.71, -12.5 - 10.5, -30.85, (i * FloorHeight) + (RiserHeight * 3)
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 10.5, -46.25 + 7.71, -12.5 - 12, -30.85, (i * FloorHeight) + (RiserHeight * 4)
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 12, -46.25 + 7.71, -12.5 - 13.5, -30.85, (i * FloorHeight) + (RiserHeight * 5)
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 13.5, -46.25 + 7.71, -12.5 - 15, -30.85, (i * FloorHeight) + (RiserHeight * 6)
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 15, -46.25 + 7.71, -12.5 - 16, -30.85, (i * FloorHeight) + (RiserHeight * 7)
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 16, -46.25, -12.5 - 20, -30.85, (i * FloorHeight) + (RiserHeight * 8)
    
    Stairs(i).AddFloor GetTex("stairs"), -12.5, -46.25, -12.5 - 6, -30.85, (i * FloorHeight) + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 6, -46.25 + 7.71, -12.5 - 7.5, -46.25, (i * FloorHeight) + (RiserHeight * 15)
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 7.5, -46.25 + 7.71, -12.5 - 9, -46.25, (i * FloorHeight) + (RiserHeight * 14)
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 9, -46.25 + 7.71, -12.5 - 10.5, -46.25, (i * FloorHeight) + (RiserHeight * 13)
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 10.5, -46.25 + 7.71, -12.5 - 12, -46.25, (i * FloorHeight) + (RiserHeight * 12)
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 12, -46.25 + 7.71, -12.5 - 13.5, -46.25, (i * FloorHeight) + (RiserHeight * 11)
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 13.5, -46.25 + 7.71, -12.5 - 15, -46.25, (i * FloorHeight) + (RiserHeight * 10)
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 15, -46.25 + 7.71, -12.5 - 16, -46.25, (i * FloorHeight) + (RiserHeight * 9)
    
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 6, -46.25, -12.5 - 6, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 15)
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 7.5, -46.25, -12.5 - 7.5, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 14)
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 9, -46.25, -12.5 - 9, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 13)
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 10.5, -46.25, -12.5 - 10.5, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 12)
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 12, -46.25, -12.5 - 12, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 11)
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 13.5, -46.25, -12.5 - 13.5, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 10)
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 15, -46.25, -12.5 - 15, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 9)
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 16, -46.25, -12.5 - 16, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 8)

'Stairs on the first floor, section 3
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 6, -46.25 + 7.71, -12.5 - 6, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 0) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 7.5, -46.25 + 7.71, -12.5 - 7.5, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 1) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 9, -46.25 + 7.71, -12.5 - 9, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 2) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 10.5, -46.25 + 7.71, -12.5 - 10.5, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 3) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 12, -46.25 + 7.71, -12.5 - 12, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 4) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 13.5, -46.25 + 7.71, -12.5 - 13.5, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 5) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 15, -46.25 + 7.71, -12.5 - 15, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 6) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 16, -46.25 + 7.71, -12.5 - 16, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 7) + FloorHeight
    
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 6, -46.25 + 7.71, -12.5 - 7.5, -30.85, (i * FloorHeight) + (RiserHeight * 1) + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 7.5, -46.25 + 7.71, -12.5 - 9, -30.85, (i * FloorHeight) + (RiserHeight * 2) + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 9, -46.25 + 7.71, -12.5 - 10.5, -30.85, (i * FloorHeight) + (RiserHeight * 3) + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 10.5, -46.25 + 7.71, -12.5 - 12, -30.85, (i * FloorHeight) + (RiserHeight * 4) + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 12, -46.25 + 7.71, -12.5 - 13.5, -30.85, (i * FloorHeight) + (RiserHeight * 5) + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 13.5, -46.25 + 7.71, -12.5 - 15, -30.85, (i * FloorHeight) + (RiserHeight * 6) + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 15, -46.25 + 7.71, -12.5 - 16, -30.85, (i * FloorHeight) + (RiserHeight * 7) + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 16, -46.25, -12.5 - 20, -30.85, (i * FloorHeight) + (RiserHeight * 8) + FloorHeight
    
    Stairs(i).AddFloor GetTex("stairs"), -12.5, -46.25, -12.5 - 6, -30.85, (i * FloorHeight) + FloorHeight + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 6, -46.25 + 7.71, -12.5 - 7.5, -46.25, (i * FloorHeight) + (RiserHeight * 15) + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 7.5, -46.25 + 7.71, -12.5 - 9, -46.25, (i * FloorHeight) + (RiserHeight * 14) + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 9, -46.25 + 7.71, -12.5 - 10.5, -46.25, (i * FloorHeight) + (RiserHeight * 13) + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 10.5, -46.25 + 7.71, -12.5 - 12, -46.25, (i * FloorHeight) + (RiserHeight * 12) + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 12, -46.25 + 7.71, -12.5 - 13.5, -46.25, (i * FloorHeight) + (RiserHeight * 11) + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 13.5, -46.25 + 7.71, -12.5 - 15, -46.25, (i * FloorHeight) + (RiserHeight * 10) + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 15, -46.25 + 7.71, -12.5 - 16, -46.25, (i * FloorHeight) + (RiserHeight * 9) + FloorHeight
    
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 6, -46.25, -12.5 - 6, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 15) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 7.5, -46.25, -12.5 - 7.5, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 14) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 9, -46.25, -12.5 - 9, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 13) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 10.5, -46.25, -12.5 - 10.5, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 12) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 12, -46.25, -12.5 - 12, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 11) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 13.5, -46.25, -12.5 - 13.5, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 10) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 15, -46.25, -12.5 - 15, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 9) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 16, -46.25, -12.5 - 16, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 8) + FloorHeight

    'Floor signs
    Stairs(i).AddWall GetTex("FloorSign"), -12.5 - 0.52, -42.5, -12.5 - 0.52, -44.5, 0.5, 11 - 0.4, 1, 1
    Stairs(i).AddWall GetTex("ButtonL"), -12.5 - 0.51, -42.5, -12.5 - 0.51, -44.5, 1.5, 9.5, 1, 1
    Stairs(i).AddWall GetTex("FloorSignLobby"), -12.5 - 0.52, -42.5, -12.5 - 0.52, -44.5, 0.5, 9 + 0.3, 1, 1
    
    Stairs(i).AddWall GetTex("FloorSign"), -12.5 - 0.52, -42.5, -12.5 - 0.52, -44.5, 0.5, 11 + FloorHeight - 0.4, 1, 1
    Stairs(i).AddWall GetTex("ButtonM"), -12.5 - 0.51, -42.5, -12.5 - 0.51, -44.5, 1.5, 9.5 + FloorHeight, 1, 1
    Stairs(i).AddWall GetTex("FloorSignMez"), -12.5 - 0.52, -42.5, -12.5 - 0.52, -44.5, 0.5, 9 + FloorHeight + 0.3, 1, 1
    

    For i = 2 To 137
    'Stairs
    DoEvents
    Form1.Label2.Caption = "Processing Stairs... " + Str$(Int((i / 137) * 100)) + "%"
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 6, -46.25 + 7.71, -12.5 - 6, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 0) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 7.5, -46.25 + 7.71, -12.5 - 7.5, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 1) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 9, -46.25 + 7.71, -12.5 - 9, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 2) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 10.5, -46.25 + 7.71, -12.5 - 10.5, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 3) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 12, -46.25 + 7.71, -12.5 - 12, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 4) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 13.5, -46.25 + 7.71, -12.5 - 13.5, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 5) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 15, -46.25 + 7.71, -12.5 - 15, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 6) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 16, -46.25 + 7.71, -12.5 - 16, -30.85, RiserHeight, (i * FloorHeight) + (RiserHeight * 7) + FloorHeight
    
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 6, -46.25 + 7.71, -12.5 - 7.5, -30.85, (i * FloorHeight) + (RiserHeight * 1) + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 7.5, -46.25 + 7.71, -12.5 - 9, -30.85, (i * FloorHeight) + (RiserHeight * 2) + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 9, -46.25 + 7.71, -12.5 - 10.5, -30.85, (i * FloorHeight) + (RiserHeight * 3) + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 10.5, -46.25 + 7.71, -12.5 - 12, -30.85, (i * FloorHeight) + (RiserHeight * 4) + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 12, -46.25 + 7.71, -12.5 - 13.5, -30.85, (i * FloorHeight) + (RiserHeight * 5) + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 13.5, -46.25 + 7.71, -12.5 - 15, -30.85, (i * FloorHeight) + (RiserHeight * 6) + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 15, -46.25 + 7.71, -12.5 - 16, -30.85, (i * FloorHeight) + (RiserHeight * 7) + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 16, -46.25, -12.5 - 20, -30.85, (i * FloorHeight) + (RiserHeight * 8) + FloorHeight
    
    Stairs(i).AddFloor GetTex("stairs"), -12.5, -46.25, -12.5 - 6, -30.85, (i * FloorHeight) + FloorHeight + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 6, -46.25 + 7.71, -12.5 - 7.5, -46.25, (i * FloorHeight) + (RiserHeight * 15) + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 7.5, -46.25 + 7.71, -12.5 - 9, -46.25, (i * FloorHeight) + (RiserHeight * 14) + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 9, -46.25 + 7.71, -12.5 - 10.5, -46.25, (i * FloorHeight) + (RiserHeight * 13) + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 10.5, -46.25 + 7.71, -12.5 - 12, -46.25, (i * FloorHeight) + (RiserHeight * 12) + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 12, -46.25 + 7.71, -12.5 - 13.5, -46.25, (i * FloorHeight) + (RiserHeight * 11) + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 13.5, -46.25 + 7.71, -12.5 - 15, -46.25, (i * FloorHeight) + (RiserHeight * 10) + FloorHeight
    Stairs(i).AddFloor GetTex("stairs"), -12.5 - 15, -46.25 + 7.71, -12.5 - 16, -46.25, (i * FloorHeight) + (RiserHeight * 9) + FloorHeight
    
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 6, -46.25, -12.5 - 6, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 15) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 7.5, -46.25, -12.5 - 7.5, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 14) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 9, -46.25, -12.5 - 9, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 13) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 10.5, -46.25, -12.5 - 10.5, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 12) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 12, -46.25, -12.5 - 12, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 11) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 13.5, -46.25, -12.5 - 13.5, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 10) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 15, -46.25, -12.5 - 15, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 9) + FloorHeight
    Stairs(i).AddWall GetTex("stairs"), -12.5 - 16, -46.25, -12.5 - 16, -46.25 + 7.71, RiserHeight, (i * FloorHeight) + (RiserHeight * 8) + FloorHeight
    
    'Floor Signs
    Stairs(i).AddWall GetTex("FloorSign"), -12.5 - 0.52, -42.5, -12.5 - 0.52, -44.5, 0.5, ((i * FloorHeight) + FloorHeight) + 11 - 0.4, 1, 1
    Stairs(i).AddWall GetTex("Button" + Mid$(Str$(i), 2)), -12.5 - 0.51, -42.5, -12.5 - 0.51, -44.5, 1.5, ((i * FloorHeight) + FloorHeight) + 9.5, 1, 1
    If i >= 2 And i <= 79 Then Stairs(i).AddWall GetTex("FloorSignOffices"), -12.5 - 0.52, -42.5, -12.5 - 0.52, -44.5, 0.5, ((i * FloorHeight) + FloorHeight) + 9 + 0.3, 1, 1
    If i = 80 Then Stairs(i).AddWall GetTex("FloorSignSkylobby"), -12.5 - 0.52, -42.5, -12.5 - 0.52, -44.5, 0.5, ((i * FloorHeight) + FloorHeight) + 9 + 0.3, 1, 1
    If i >= 81 And i <= 99 Then Stairs(i).AddWall GetTex("FloorSignHotel"), -12.5 - 0.52, -42.5, -12.5 - 0.52, -44.5, 0.5, ((i * FloorHeight) + FloorHeight) + 9 + 0.3, 1, 1
    If i >= 100 And i <= 114 Then Stairs(i).AddWall GetTex("FloorSignResidential"), -12.5 - 0.52, -42.5, -12.5 - 0.52, -44.5, 0.5, ((i * FloorHeight) + FloorHeight) + 9 + 0.3, 1, 1
    If i >= 115 And i <= 117 Then Stairs(i).AddWall GetTex("FloorSignMaint"), -12.5 - 0.52, -42.5, -12.5 - 0.52, -44.5, 0.5, ((i * FloorHeight) + FloorHeight) + 9 + 0.3, 1, 1
    If i >= 118 And i <= 129 Then Stairs(i).AddWall GetTex("FloorSignResidential"), -12.5 - 0.52, -42.5, -12.5 - 0.52, -44.5, 0.5, ((i * FloorHeight) + FloorHeight) + 9 + 0.3, 1, 1
    If i = 130 Or i = 131 Then Stairs(i).AddWall GetTex("FloorSignMaint"), -12.5 - 0.52, -42.5, -12.5 - 0.52, -44.5, 0.5, ((i * FloorHeight) + FloorHeight) + 9 + 0.3, 1, 1
    If i = 132 Then Stairs(i).AddWall GetTex("FloorSignObservatory"), -12.5 - 0.52, -42.5, -12.5 - 0.52, -44.5, 0.5, ((i * FloorHeight) + FloorHeight) + 9 + 0.3, 1, 1
    If i = 133 Then Stairs(i).AddWall GetTex("FloorSignMaint"), -12.5 - 0.52, -42.5, -12.5 - 0.52, -44.5, 0.5, ((i * FloorHeight) + FloorHeight) + 9 + 0.3, 1, 1
    If i = 134 Then Stairs(i).AddWall GetTex("FloorSignPool"), -12.5 - 0.52, -42.5, -12.5 - 0.52, -44.5, 0.5, ((i * FloorHeight) + FloorHeight) + 9 + 0.3, 1, 1
    If i = 135 Then Stairs(i).AddWall GetTex("FloorSignBallroom"), -12.5 - 0.52, -42.5, -12.5 - 0.52, -44.5, 0.5, ((i * FloorHeight) + FloorHeight) + 9 + 0.3, 1, 1
    If i = 136 Then Stairs(i).AddWall GetTex("FloorSignBalcony"), -12.5 - 0.52, -42.5, -12.5 - 0.52, -44.5, 0.5, ((i * FloorHeight) + FloorHeight) + 9 + 0.3, 1, 1
    If i = 137 Then Stairs(i).AddWall GetTex("FloorSignMechanical"), -12.5 - 0.52, -42.5, -12.5 - 0.52, -44.5, 0.5, ((i * FloorHeight) + FloorHeight) + 9 + 0.3, 1, 1
    
    Next i
    i = 138
    Stairs(i).AddWall GetTex("FloorSign"), -12.5 - 0.52, -42.5, -12.5 - 0.52, -44.5, 0.5, ((i * FloorHeight) + FloorHeight) + 11 - 0.4, 1, 1
    Stairs(i).AddWall GetTex("Button" + Mid$(Str$(i), 2)), -12.5 - 0.51, -42.5, -12.5 - 0.51, -44.5, 1.5, ((i * FloorHeight) + FloorHeight) + 9.5, 1, 1
    Stairs(i).AddWall GetTex("FloorSignRoof"), -12.5 - 0.52, -42.5, -12.5 - 0.52, -44.5, 0.5, ((i * FloorHeight) + FloorHeight) + 9 + 0.3, 1, 1
    
End Sub

