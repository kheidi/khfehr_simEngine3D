#------------------------------------------------------------------------------
# Name:        bodiesInEnvironment
# Purpose:     Praciting how to add bodies into an environment
#              Based off demo by projectChrono, demo_IRR_assets
#
# Author:      Katherine Heidi Fehr
#
# Created:     11/21/2020
#------------------------------------------------------------------------------


import pychrono.core as chrono
import pychrono.irrlicht as chronoirr
import math as m


print (" Practice of placing and connecting shapes with Irrlicht visualization")

# Create a Chrono::Engine physical system
mphysicalSystem = chrono.ChSystemNSC()

# Create the Irrlicht visualization (open the Irrlicht device, bind a simple UI, etc, etc)
application = chronoirr.ChIrrApp(mphysicalSystem, "Assets for Irrlicht visualization", chronoirr.dimension2du(1024, 768))

# Easy shorcuts to add camera, lights, logo, and sky in Irrlicht scene
application.AddTypicalSky()
application.AddTypicalLogo(chrono.GetChronoDataFile('logo_pychrono_alpha.png'))
application.AddTypicalCamera(chronoirr.vector3df(0, 4, -6))
application.AddTypicalLights()

# Create a rigid body as usual, and add it
# to the physical system:
mfloor = chrono.ChBody()
mfloor.SetBodyFixed(True)


# Contact material
floor_mat = chrono.ChMaterialSurfaceNSC()

# Add body to system
mphysicalSystem.Add(mfloor)


# ==Asset== attach a 'box' shape.
# This is the floor!
mboxfloor = chrono.ChBoxShape()
mboxfloor.GetBoxGeometry().Size = chrono.ChVectorD(10, 0.5, 10)
mboxfloor.GetBoxGeometry().Pos = chrono.ChVectorD(0, -0.5, 0)
mfloor.AddAsset(mboxfloor)


# ==Asset== attach color asset
mfloorcolor = chrono.ChColorAsset()
mfloorcolor.SetColor(chrono.ChColor(0.3, 0.3, 0.6))
mfloor.AddAsset(mfloorcolor)


mbody = chrono.ChBody()
mbody.SetBodyFixed(True)
mphysicalSystem.Add(mbody)

# ==Asset== Attach a 'sphere' (hip)
hip = chrono.ChSphereShape()
hip.GetSphereGeometry().rad = 0.2
hip.GetSphereGeometry().center = chrono.ChVectorD(0,1,0)
mbody.AddAsset(hip)

# ==Asset== Attach also a 'cylinder' shape (thigh)
thigh = chrono.ChCylinderShape()
thigh.GetCylinderGeometry().p1 = chrono.ChVectorD(0, 1, 0)
thigh.GetCylinderGeometry().p2 = chrono.ChVectorD(0, 0.4, 0.3)
thigh.GetCylinderGeometry().rad = 0.05
mbody.AddAsset(thigh)

# ==Asset== Attach also a 'cylinder' shape
shank = chrono.ChCylinderShape()
shank.GetCylinderGeometry().p1 = chrono.ChVectorD(0, 0.4, 0.3)
shank.GetCylinderGeometry().p2 = chrono.ChVectorD(0, 0, 0.3)
shank.GetCylinderGeometry().rad = 0.05
mbody.AddAsset(shank)


# ==Asset== Attach a video camera. This will be used by Irrlicht, 
# or POVray postprocessing, etc. Note that a camera can also be 
# put in a moving object
mcamera = chrono.ChCamera()
mcamera.SetAngle(50)
mcamera.SetPosition(chrono.ChVectorD(-3, 4, -5))
mcamera.SetAimPoint(chrono.ChVectorD(0, 1, 0))
mbody.AddAsset(mcamera)



#####################################


application.AssetBindAll()
application.AssetUpdateAll()

#
# THE SOFT-REAL-TIME CYCLE
#
application.SetTimestep(0.01)
application.SetTryRealtime(True)

while application.GetDevice().run():
    application.BeginScene()
    application.DrawAll()
    application.DoStep()
    application.EndScene()

