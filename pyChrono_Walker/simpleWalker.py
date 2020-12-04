#------------------------------------------------------------------------------
# Name:        Simple Walker 2D
# Purpose:     Implementing the simpliest walking model in 2D 
#
# Author:      Katherine Heidi Fehr
#
# Created:     12/1/2020
#------------------------------------------------------------------------------

import pychrono.core as chrono
import pychrono.irrlicht as chronoirr
import numpy as np
import math

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
contact_material.SetFriction(.1)
contact_material.SetDampingF(0.2)
contact_material.SetCompliance (0.0005)
contact_material.SetComplianceT(0.0005)

# Create floor
mfloor = chrono.ChBodyEasyBox(20, 0.3, 6, 100000,True,True, contact_material)
mfloor.SetRot( chrono.ChQuaternionD(  -0.0610485, 0, 0, 0.9981348  )) # Tilt the floor -7 degrees
mfloor.SetBodyFixed(True)
mysystem.Add(mfloor)

# Attach color asset
mfloorcolor = chrono.ChColorAsset()
mfloorcolor.SetColor(chrono.ChColor(0.3, 0.3, 0.6))
mfloor.AddAsset(mfloorcolor)

# Create wall to simulate in 2D
mwall = chrono.ChBodyEasyBox(20,6,0.3,10000,True,True,contact_material)
mwall.SetPos(chrono.ChVectorD(0,3,2.85))
mwall.SetRot( chrono.ChQuaternionD(  -0.0610485, 0, 0, 0.9981348  )) # Tilt the floor -7 degrees
mwall.SetBodyFixed(True)
mysystem.Add(mwall)
mwall.AddAsset(mfloorcolor)

# ---------------------------------------------------------------------
#
#  Create bodies
#

# Define Properties
initial_hipPos = chrono.ChVectorD(0,3,0)
leg_length = 0.85
leg_radius = 0.05
leg_density = 250
incline = np.radians(7)
theta = np.radians(30)
phi = np.radians(30)
leg_mass = leg_density * leg_length * math.pi* pow (leg_radius,2)
leg_inertia = chrono.ChVectorD(0.5*leg_mass*pow(leg_radius,2), (leg_mass/12)*(3*pow(leg_radius,2)+pow(leg_length,2)),(leg_mass/12)*(3*pow(leg_radius,2)+pow(leg_length,2)))

# Initial Conditions
# Right Leg
xR = (leg_length/2)*np.sin(theta)
yR = (leg_length/2)*np.cos(theta)
# Left Leg
xL = xR+np.cos(incline)
yL = yR-np.sin(incline)

# Create left leg
leg_left = chrono.ChBodyEasyCylinder(leg_radius, leg_length, 1000,True,True,contact_material)
leg_left.SetPos(chrono.ChVectorD(xL,yL, 0))
mysystem.Add(leg_left)

# Create right leg
leg_right = chrono.ChBodyEasyCylinder(leg_radius, leg_length, 1000,True,True,contact_material)
leg_right.SetPos(chrono.ChVectorD(xR,yR, 0))
mysystem.Add(leg_right)


# ---------------------------------------------------------------------
#
#  Create Markers
#

floor_contactP = chrono.ChMarker()
floor_contactP.Impose_Rel_Coord(chrono.ChCoordsysD(chrono.ChVectorD(0,0,0), chrono.ChQuaternionD(1, 0, 0, 0)))
mfloor.AddMarker(floor_contactP)

proximal_left = chrono.ChMarker()
proximal_left.Impose_Rel_Coord(chrono.ChCoordsysD(chrono.ChVectorD(0,leg_length/2,0), chrono.ChQuaternionD(1, 0, 0, 0)))
leg_left.AddMarker(proximal_left)

proximal_right = chrono.ChMarker()
proximal_right.Impose_Rel_Coord(chrono.ChCoordsysD(chrono.ChVectorD(0,leg_length/2,0), chrono.ChQuaternionD(1, 0, 0, 0)))
leg_right.AddMarker(proximal_right)

distal_left = chrono.ChMarker()
distal_left.Impose_Rel_Coord(chrono.ChCoordsysD(chrono.ChVectorD(0,-leg_length/2,0), chrono.ChQuaternionD(1, 0, 0, 0)))
leg_left.AddMarker(distal_left)

distal_right = chrono.ChMarker()
distal_right.Impose_Rel_Coord(chrono.ChCoordsysD(chrono.ChVectorD(0,-leg_length/2,0), chrono.ChQuaternionD(1, 0, 0, 0)))
leg_right.AddMarker(distal_right)


# ---------------------------------------------------------------------
#
#  Add Constraints
#

# Add a revolute joint 
hipJoint = chrono.ChLinkLockRevolute()
hipJoint.SetName('Revolute')
hipJoint.Initialize(proximal_left,proximal_right)
#hipJoint.Initialize(leg_left, leg_right, True, chrono.ChCoordsysD(chrono.ChVectorD(0,0,0), chrono.ChQuaternionD(1, 0, 0, 0)),chrono.ChCoordsysD(chrono.ChVectorD(0,0,0), chrono.ChQuaternionD(1, 0, 0, 0)))
mysystem.AddLink(hipJoint)


# sticky_heel_contact = chrono.ChLinkDistance()
# sticky_heel_contact.SetName('Sticky Heel Contact')
# sticky_heel_contact.Initialize(leg_right, mfloor, True, chrono.ChVectorD(0,-leg_length/2,0), chrono.ChCoordsysD(chrono.ChVectorD(0,0,0)))
# mysystem.AddLink(sticky_heel_contact)


sticky_heel_right = chrono.ChLinkLockRevolute()
sticky_heel_right.SetName('Floor Revolute')
sticky_heel_right.Initialize(distal_right,floor_contactP)
#sticky_heel_right.Initialize(leg_left, leg_right, True, chrono.ChCoordsysD(chrono.ChVectorD(0,0,0), chrono.ChQuaternionD(1, 0, 0, 0)),chrono.ChCoordsysD(chrono.ChVectorD(0,0,0), chrono.ChQuaternionD(1, 0, 0, 0)))
mysystem.AddLink(sticky_heel_right)







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


