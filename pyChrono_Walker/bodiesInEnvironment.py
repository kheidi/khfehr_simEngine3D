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
from scipy.spatial.transform import Rotation as R

print (" Practice of placing and connecting shapes with Irrlicht visualization")

# Create a Chrono::Engine physical system
mphysicalSystem = chrono.ChSystemNSC()

# Set the global collision margins. This is expecially important for very large or
# very small objects. Set this before creating shapes. Not before creating mysystem.
chrono.ChCollisionModel.SetDefaultSuggestedEnvelope(0.001);
chrono.ChCollisionModel.SetDefaultSuggestedMargin(0.001);

# Create the Irrlicht visualization (open the Irrlicht device, bind a simple UI, etc, etc)
application = chronoirr.ChIrrApp(mphysicalSystem, "Assets for Irrlicht visualization", chronoirr.dimension2du(1024, 768))

# Easy shorcuts to add camera, lights, logo, and sky in Irrlicht scene
application.AddTypicalSky()
application.AddTypicalLogo(chrono.GetChronoDataFile('logo_pychrono_alpha.png'))
application.AddTypicalCamera(chronoirr.vector3df(0, 4, -6))
application.AddTypicalLights()

# Contact material
material = chrono.ChMaterialSurfaceNSC()
material.SetFriction(0.8)
material.SetCompliance(0)

# Create a rigid body as usual, and add it
# to the physical system:
mfloor = chrono.ChBody()
mfloor.SetBodyFixed(True)
mfloor.SetPos( chrono.ChVectorD(0,0,0) )
# Tilt the floor 10 degrees
mfloor.SetRot( chrono.ChQuaternionD(0.996,0,0,-0.087) )





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
mbody.SetMass(60)
mbody.SetName('Hip')
mbody.GetCollisionModel().ClearModel()
mbody.GetCollisionModel().AddSphere(material, 0.05)
mbody.GetCollisionModel().BuildModel()
mbody.SetInertiaXX(chrono.ChVectorD(0.001, 0.001, 0.001))
mbody.SetCollide(True)
mphysicalSystem.Add(mbody)


# ==Hip==
# hip = chrono.ChBody()
# hip.SetMass(60)

# ==Asset== Attach a 'sphere' (hip)
hip = chrono.ChSphereShape()
hip.GetSphereGeometry().rad = 0.2
hip.GetSphereGeometry().center = chrono.ChVectorD(0,1,0)
mbody.AddAsset(hip)

# # ==Asset== Attach also a 'cylinder' shape (thigh)
# thigh = chrono.ChCylinderShape()
# thigh.GetCylinderGeometry().p1 = chrono.ChVectorD(0, 1, 0)
# thigh.GetCylinderGeometry().p2 = chrono.ChVectorD(0, 0.4, 0.3)
# thigh.GetCylinderGeometry().rad = 0.05
# mbody.AddAsset(thigh)

# # ==Asset== Attach also a 'cylinder' shape (Shank)
# shank = chrono.ChCylinderShape()
# shank.GetCylinderGeometry().p1 = chrono.ChVectorD(0, 0.4, 0.3)
# shank.GetCylinderGeometry().p2 = chrono.ChVectorD(0, 0, 0.3)
# shank.GetCylinderGeometry().rad = 0.05
# mbody.AddAsset(shank)


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
application.SetTimestep(0.001)
application.SetTryRealtime(True)

while application.GetDevice().run():
    application.BeginScene()
    application.DrawAll()
    application.DoStep()
    application.EndScene()


