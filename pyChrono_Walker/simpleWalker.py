
#------------------------------------------------------------------------------
# Name:        Simple Walker Attempt 2
# Purpose:     Implementing the simpliest walking model in 2D 
#
# Author:      Katherine Heidi Fehr
#
# Created:     12/8/2020
#------------------------------------------------------------------------------

import pychrono.core as chrono
import pychrono.irrlicht as chronoirr
import numpy as np
import math
from scipy.spatial.transform import Rotation as R

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
floor_thickness = 0.3
mfloor = chrono.ChBodyEasyBox(20, floor_thickness, 6, 100000,True,True, contact_material)
mfloor.SetPos(chrono.ChVectorD(0, 0, 0))
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
mymass = 60 #kg
foot_mass = mymass*0.0133 #https://exrx.net/Kinesiology/Segments
leg_mass = mymass*0.0535
initial_hipPos = chrono.ChVectorD(0,2,0)
leg_length = 0.85
leg_radius = 0.05
leg_volume = math.pi*pow(leg_radius,2)*leg_length
leg_density = leg_mass/leg_volume
incline = np.radians(7)
theta = 0.3
phi = 0.4
leg_inertia = chrono.ChVectorD(0.5*leg_mass*pow(leg_radius,2), (leg_mass/12)*(3*pow(leg_radius,2)+pow(leg_length,2)),(leg_mass/12)*(3*pow(leg_radius,2)+pow(leg_length,2)))
foot_length = 0.1
foot_radius = 0.05
foot_volume = math.pi*pow(foot_radius,2)*foot_length
foot_density = foot_mass/foot_volume

# Create hip
hipBody = chrono.ChBodyEasyEllipsoid(chrono.ChVectorD(.2,.2,.2 ),leg_density,True,False,contact_material)
hipBody.SetPos(initial_hipPos)
#hipBody.SetBodyFixed(True)
mysystem.Add(hipBody)


# Hip Joint locations
left_hipJoint_P = chrono.ChMarker()
h = hipBody.GetPos()
left_hipJoint_P.SetPos(chrono.ChVectorD(h.x,h.y,h.z+0.1))
hipBody.AddMarker(left_hipJoint_P)
print('Left hip', left_hipJoint_P.GetPos())

right_hipJoint_P = chrono.ChMarker()
right_hipJoint_P.SetPos(chrono.ChVectorD(h.x,h.y,(h.z-0.1)))
hipBody.AddMarker(right_hipJoint_P)
print('Right hip', right_hipJoint_P.GetPos())

# Make a reference frame where the leg connects to the hip
left_hip_frame = chrono.ChFrameD()
left_hip_frame.SetCoord(left_hipJoint_P.GetCoord())

right_hip_frame = chrono.ChFrameD()
right_hip_frame.SetCoord(right_hipJoint_P.GetCoord())

# Create left leg
leg_left = chrono.ChBodyEasyCylinder(leg_radius, leg_length, leg_density,True,True,contact_material)
center_leg_left= left_hip_frame*chrono.ChVectorD(-(leg_length/2)*np.sin(-theta),-(leg_length/2)*np.cos(-theta),0)
print(center_leg_left)
q = chrono.ChQuaternionD()
q.Q_from_AngAxis(-theta, chrono.ChVectorD(0,0,-1))
print('q',q)
leg_left.SetPos(center_leg_left)
leg_left.SetRot(q)
# leg_left.SetBodyFixed(True)
mysystem.Add(leg_left)

# Create right leg
leg_right = chrono.ChBodyEasyCylinder(leg_radius, leg_length, leg_density,True,True,contact_material)
center_leg_right= right_hip_frame*chrono.ChVectorD(-(leg_length/2)*np.sin(phi-theta),-(leg_length/2)*np.cos(phi-theta),0)
print(center_leg_right)
q = chrono.ChQuaternionD()
q.Q_from_AngAxis((phi-theta), chrono.ChVectorD(0,0,-1))
print('q',q)
leg_right.SetPos(center_leg_right)
leg_right.SetRot(q)
# leg_right.SetBodyFixed(True)
mysystem.Add(leg_right)

# Create feet
foot_left = chrono.ChBodyEasyCylinder(foot_radius, foot_length, foot_density,True,True,contact_material)
end_leg_left= left_hip_frame*chrono.ChVectorD(-(leg_length+foot_radius)*np.sin(-theta),-(leg_length+foot_radius)*np.cos(-theta),0)
print(end_leg_left)
q1 = chrono.ChQuaternionD()
q1.Q_from_AngAxis(-theta, chrono.ChVectorD(0,0,-1))
q2 = chrono.ChQuaternionD()
q2.Q_from_AngAxis(np.radians(90), chrono.ChVectorD(1,0,0))
print('q',q1*q2)
foot_left.SetPos(end_leg_left)
foot_left.SetRot(q1*q2)
# foot_left.SetBodyFixed(True)
mysystem.Add(foot_left)

foot_right = chrono.ChBodyEasyCylinder(foot_radius, foot_length, foot_density,True,True,contact_material)
end_leg_right=  right_hip_frame*chrono.ChVectorD(-(leg_length+foot_radius)*np.sin(phi-theta),-(leg_length+foot_radius)*np.cos(phi-theta),0)
print(end_leg_right)
q1 = chrono.ChQuaternionD()
q1.Q_from_AngAxis(-theta, chrono.ChVectorD(0,0,-1))
q2 = chrono.ChQuaternionD()
q2.Q_from_AngAxis(np.radians(90), chrono.ChVectorD(1,0,0))
print('q',q1*q2)
foot_right.SetPos(end_leg_right)
foot_right.SetRot(q1*q2)
# foot_right.SetBodyFixed(True)
mysystem.Add(foot_right)



# ---------------------------------------------------------------------
#
#  Add Constraints
#

# Add a revolute joint 
hipJoint_L = chrono.ChLinkLockRevolute()
hipJoint_L.SetName('Revolute')
hipJoint_L.Initialize(leg_left,hipBody,True,chrono.ChCoordsysD(chrono.ChVectorD(0,leg_length/2,0),chrono.ChQuaternionD(1, 0, 0, 0)),chrono.ChCoordsysD(chrono.ChVectorD(0,0,0.1),chrono.ChQuaternionD(1, 0, 0, 0)))
mysystem.AddLink(hipJoint_L)

hipJoint_R = chrono.ChLinkLockRevolute()
hipJoint_R.SetName('Revolute2')
hipJoint_R.Initialize(leg_right,hipBody,True,chrono.ChCoordsysD(chrono.ChVectorD(0,leg_length/2,0),chrono.ChQuaternionD(1, 0, 0, 0)),chrono.ChCoordsysD(chrono.ChVectorD(0,0,-0.1),chrono.ChQuaternionD(1, 0, 0, 0)))
mysystem.AddLink(hipJoint_R)

ankleJoint_L = chrono.ChLinkMateFix()
ankleJoint_L.Initialize(leg_left, foot_left)
mysystem.AddLink(ankleJoint_L)

ankleJoint_R = chrono.ChLinkMateFix()
ankleJoint_R.Initialize(leg_right, foot_right)
mysystem.AddLink(ankleJoint_R)

hipJoint_L.GetLimit_Rz().SetActive(True)
hipJoint_L.GetLimit_Rz().SetMin(math.pi/3)
hipJoint_L.GetLimit_Rz().SetMax(-math.pi/3)

hipJoint_R.GetLimit_Rz().SetActive(True)
hipJoint_R.GetLimit_Rz().SetMin(math.pi/3)
hipJoint_R.GetLimit_Rz().SetMax(-math.pi/3)

# sticky_heel_contact = chrono.ChLinkDistance()
# sticky_heel_contact.SetName('Sticky Heel Contact')
# sticky_heel_contact.Initialize(leg_right, mfloor, True, chrono.ChVectorD(0,-leg_length/2,0), chrono.ChCoordsysD(chrono.ChVectorD(0,0,0)))
# mysystem.AddLink(sticky_heel_contact)


# sticky_heel_right = chrono.ChLinkLockRevolute()
# sticky_heel_right.SetName('Floor Revolute')
# sticky_heel_right.Initialize(distal_left,floor_contactP)
# #sticky_heel_right.Initialize(leg_left, leg_right, True, chrono.ChCoordsysD(chrono.ChVectorD(0,0,0), chrono.ChQuaternionD(1, 0, 0, 0)),chrono.ChCoordsysD(chrono.ChVectorD(0,0,0), chrono.ChQuaternionD(1, 0, 0, 0)))
# mysystem.AddLink(sticky_heel_right)

# plane_plane_left = chrono.ChLinkLockPlanePlane()
# plane_plane_left.Initialize(mfloor, 
#                        leg_left, 
#                        chrono.ChCoordsysD(chrono.ChVectorD(-1.25, -0.75, 0), chrono.ChQuaternionD(1, 0, 0, 0)))
# mysystem.AddLink(plane_plane_left)

# plane_plane_right = chrono.ChLinkLockPlanePlane()
# plane_plane_right.Initialize(mfloor, 
#                        leg_right, 
#                        chrono.ChCoordsysD(chrono.ChVectorD(-1.25, -0.75, 0), chrono.ChQuaternionD(1, 0, 0, 0)))
# mysystem.AddLink(plane_plane_right)





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


myapplication.SetTimestep(0.0005)

while(myapplication.GetDevice().run()):
    myapplication.BeginScene()
    chronoirr.ChIrrTools.drawAllCOGs(mysystem, myapplication.GetVideoDriver(), 2)
    myapplication.DrawAll()
    myapplication.DoStep()
    myapplication.EndScene()


