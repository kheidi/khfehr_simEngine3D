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

mysystem = chrono.ChSystemNSC()


# Set the global collision margins.
chrono.ChCollisionModel.SetDefaultSuggestedEnvelope(0.001);
chrono.ChCollisionModel.SetDefaultSuggestedMargin(0.001);

# ---------------------------------------------------------------------
#
#  Create the simulation system and add items

# Create a contact material (with default properties, shared by all collision shapes)
contact_material = chrono.ChMaterialSurfaceNSC()

# Create a floor
mfloor = chrono.ChBody()
mfloor.SetPos( chrono.ChVectorD(0,0,0) )
# Tilt the floor 10 degrees
mfloor.SetRot( chrono.ChQuaternionD(0.996,0,0,-0.087) )
mfloor.SetBodyFixed(True)
mysystem.Add(mfloor)

# ---------------------------------------------------------------------
#
#  Create body

body_A = chrono.ChBodyAuxRef() #body that has an auxiliary frame that is not necessarily coincident with the COG frame
body_A.SetPos(chrono.ChVectorD(0,1,0))
body_A.SetMass(30)
body_A.SetInertiaXX(chrono.ChVectorD(3,3,3))
body_A.SetInertiaXY(chrono.ChVectorD(0,0,0))
body_A.SetFrame_COG_to_REF(chrono.ChFrameD(
            chrono.ChVectorD( 0,0.0,0),
            chrono.ChQuaternionD(0,0,0,0))) #Here you would define the relationship bw COG to REF

# ---------------------------------------------------------------------
#
#  Add visualization of sphere

sphere = chrono.ChSphereShape()
sphere.GetSphereGeometry().rad = 0.25
sphere.GetSphereGeometry().center = chrono.ChVectorD(0,1,0)
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
#  Create an Irrlicht application to visualize the system

myapplication = chronoirr.ChIrrApp(mysystem, 'PyChrono example', chronoirr.dimension2du(1024,768))

myapplication.AddTypicalSky()
myapplication.AddTypicalLogo(chrono.GetChronoDataFile('logo_pychrono_alpha.png'))
myapplication.AddTypicalCamera(chronoirr.vector3df(0.5,0.5,1), chronoirr.vector3df(0,0,0))
#myapplication.AddTypicalLights()
myapplication.AddLightWithShadow(chronoirr.vector3df(3,6,2),    # point
                                 chronoirr.vector3df(0,0,0),    # aimpoint
                                 12,                 # radius (power)
                                 1,11,              # near, far
                                 55)                # angle of FOV

            # ==IMPORTANT!== Use this function for adding a ChIrrNodeAsset to all items
			# in the system. These ChIrrNodeAsset assets are 'proxies' to the Irrlicht meshes.
			# If you need a finer control on which item really needs a visualization proxy in
			# Irrlicht, just use application.AssetBind(myitem); on a per-item basis.

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
















