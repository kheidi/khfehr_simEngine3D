#------------------------------------------------------------------------------
# Name:        Sphere Rolling Down Ramp
# Purpose:     Praciting howto make object move due to gravity down an 
#              inclined plane
#
# Author:      Katherine Heidi Fehr
#
# Created:     12/1/2020
#------------------------------------------------------------------------------

import pychrono.core as chrono
import pychrono.irrlicht as chronoirr

# ---------------------------------------------------------------------
#
#  Create the simulation system and add items
#

mysystem      = chrono.ChSystemNSC()



# Set the global collision margins. This is expecially important for very large or
# very small objects. Set this before creating shapes. Not before creating mysystem.
chrono.ChCollisionModel.SetDefaultSuggestedEnvelope(0.001);
chrono.ChCollisionModel.SetDefaultSuggestedMargin(0.001);

# ---------------------------------------------------------------------
#
#  Create the simulation system and add items
#

# Create a contact material (with default properties, shared by all collision shapes)
contact_material = chrono.ChMaterialSurfaceNSC()
contact_material.SetFriction(.7)
contact_material.SetDampingF(0.2)
contact_material.SetCompliance (0.0005)
contact_material.SetComplianceT(0.0005)

# Create floor
mfloor = chrono.ChBodyEasyBox(5, 0.3, 5, 100000,True,True, contact_material)
mfloor.SetRot( chrono.ChQuaternionD(  -0.0610485, 0, 0, 0.9981348  )) # Tilt the floor -7 degrees
mfloor.SetBodyFixed(True)
mysystem.Add(mfloor)

# Attach color asset
mfloorcolor = chrono.ChColorAsset()
mfloorcolor.SetColor(chrono.ChColor(0.3, 0.3, 0.6))
mfloor.AddAsset(mfloorcolor)

# ---------------------------------------------------------------------
#
#  Create body

body_A = chrono.ChBody() #body that has an auxiliary frame that is not necessarily coincident with the COG frame
body_A.SetPos(chrono.ChVectorD(0,2,0))
body_A.SetMass(1)
body_A.SetInertiaXX(chrono.ChVectorD(.3,.3,.3))
body_A.SetInertiaXY(chrono.ChVectorD(0,0,0))

# ---------------------------------------------------------------------
#
#  Add visualization of sphere

sphere = chrono.ChSphereShape()
sphere.GetSphereGeometry().rad = 0.25
sphere.GetSphereGeometry().center = chrono.ChVectorD(0,0,0)
body_A.AddAsset(sphere)

# ---------------------------------------------------------------------
#
#  Add the collision shape

body_A.GetCollisionModel().ClearModel()
body_A.GetCollisionModel().AddSphere(contact_material, 0.25)
body_A.GetCollisionModel().BuildModel()
body_A.SetCollide(True)
mysystem.Add(body_A)


# ---------------------------------------------------------------------
#
#  Create body

body_B = chrono.ChBody() #body that has an auxiliary frame that is not necessarily coincident with the COG frame
body_B.SetPos(chrono.ChVectorD(.07,4,0))
body_B.SetMass(1)
body_B.SetInertiaXX(chrono.ChVectorD(.3,.3,.3))
body_B.SetInertiaXY(chrono.ChVectorD(0,0,0))

# ---------------------------------------------------------------------
#
#  Add visualization of sphere

sphere = chrono.ChSphereShape()
sphere.GetSphereGeometry().rad = 0.25
sphere.GetSphereGeometry().center = chrono.ChVectorD(0,0,0)
body_B.AddAsset(sphere)

# ---------------------------------------------------------------------
#
#  Add the collision shape

body_B.GetCollisionModel().ClearModel()
body_B.GetCollisionModel().AddSphere(contact_material, 0.25)
body_B.GetCollisionModel().BuildModel()
body_B.SetCollide(True)
mysystem.Add(body_B)

# ---------------------------------------------------------------------
#
#  Create body

body_C = chrono.ChBody() #body that has an auxiliary frame that is not necessarily coincident with the COG frame
body_C.SetPos(chrono.ChVectorD(0,5,1))
body_C.SetMass(5)
body_C.SetInertiaXX(chrono.ChVectorD(0.02,0.02,0.02))
body_C.SetInertiaXY(chrono.ChVectorD(0,0,0))

# ---------------------------------------------------------------------
#
#  Add visualization of sphere

sphere = chrono.ChSphereShape()
sphere.GetSphereGeometry().rad = 0.1
sphere.GetSphereGeometry().center = chrono.ChVectorD(0,0,0)
body_C.AddAsset(sphere)

# ---------------------------------------------------------------------
#
#  Add the collision shape

body_C.GetCollisionModel().ClearModel()
body_C.GetCollisionModel().AddSphere(contact_material, 0.1)
body_C.GetCollisionModel().BuildModel()
body_C.SetCollide(True)
mysystem.Add(body_C)

# ---------------------------------------------------------------------
#
#  Create an Irrlicht application to visualize the system

myapplication = chronoirr.ChIrrApp(mysystem, 'PyChrono example', chronoirr.dimension2du(1024,768))

myapplication.AddTypicalSky()
myapplication.AddTypicalLogo(chrono.GetChronoDataFile('logo_pychrono_alpha.png'))
myapplication.AddTypicalCamera(chronoirr.vector3df(0,5,-6), chronoirr.vector3df(0,0,0))
myapplication.AddTypicalCamera(chronoirr.vector3df(0, 4, -6))
myapplication.AddTypicalLights()

myapplication.AssetBindAll();

			# ==IMPORTANT!== Use this function for 'converting' into Irrlicht meshes the assets
			# that you added to the bodies into 3D shapes, they can be visualized by Irrlicht!

myapplication.AssetUpdateAll();

            # If you want to show shadows because you used "AddLightWithShadow()'
            # you must remember this:
myapplication.AddShadowAll();


# ---------------------------------------------------------------------
#
#  Run the simulation
#


myapplication.SetTimestep(0.005)

while(myapplication.GetDevice().run()):
    myapplication.BeginScene()
    myapplication.DrawAll()
    myapplication.DoStep()
    myapplication.EndScene()
















