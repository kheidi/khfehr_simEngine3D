
#------------------------------------------------------------------------------
# Name:        Simple Walker Attempt
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
from scipy.spatial.transform import Rotation as R

# ---------------------------------------------------------------------
#
#  Create the simulation system and add items
#

mysystem      = chrono.ChSystemNSC()


# Set the global collision margins. This is expecially important for very large or
# very small objects. Set this before creating shapes. Not before creating mysystem.
chrono.ChCollisionModel.SetDefaultSuggestedEnvelope(0.001);
chrono.ChCollisionModel.SetDefaultSuggestedMargin(0.0005);

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
initial_hipPos = chrono.ChVectorD(0,1.15,0)
mymass = 60 #kg
foot_mass = mymass*0.0133 #https://exrx.net/Kinesiology/Segments
leg_mass = mymass*0.0535
leg_length = 0.85
leg_radius = 0.05
leg_volume = math.pi*pow(leg_radius,2)*leg_length
leg_density = leg_mass/leg_volume
incline = np.radians(7)
theta = 0.8
phi = 0.05
leg_inertia = chrono.ChVectorD(0.5*leg_mass*pow(leg_radius,2), (leg_mass/12)*(3*pow(leg_radius,2)+pow(leg_length,2)),(leg_mass/12)*(3*pow(leg_radius,2)+pow(leg_length,2)))
foot_length = 0.1
foot_radius = 0.05
foot_volume = math.pi*pow(foot_radius,2)*foot_length
foot_density = foot_mass/foot_volume

# Create hip
hipBody = chrono.ChBodyEasyEllipsoid(chrono.ChVectorD(.2,.2,.2 ),leg_density,True,False,contact_material)
hipBody.SetPos(initial_hipPos)
# hipBody.SetBodyFixed(True)
mysystem.Add(hipBody)

# Hip Joint locations
swing_hipJoint_P = chrono.ChMarker()
h = hipBody.GetPos()
swing_hipJoint_P.SetPos(chrono.ChVectorD(h.x,h.y,h.z+0.1))
hipBody.AddMarker(swing_hipJoint_P)
print('swing hip', swing_hipJoint_P.GetPos())

stance_hipJoint_P = chrono.ChMarker()
stance_hipJoint_P.SetPos(chrono.ChVectorD(h.x,h.y,(h.z-0.1)))
hipBody.AddMarker(stance_hipJoint_P)
print('stance hip', stance_hipJoint_P.GetPos())

# Make a reference frame where the leg connects to the hip
swing_hip_frame = chrono.ChFrameD()
swing_hip_frame.SetCoord(swing_hipJoint_P.GetCoord())

stance_hip_frame = chrono.ChFrameD()
stance_hip_frame.SetCoord(stance_hipJoint_P.GetCoord())

# Create swing leg
leg_swing = chrono.ChBodyEasyCylinder(leg_radius, leg_length, leg_density,True,True,contact_material)
center_leg_swing= swing_hip_frame*chrono.ChVectorD(-(leg_length/2)*np.sin(-theta),-(leg_length/2)*np.cos(-theta),0)
print(center_leg_swing)
q = chrono.ChQuaternionD()
q.Q_from_AngAxis(-theta, chrono.ChVectorD(0,0,-1))
print('q',q)
leg_swing.SetPos(center_leg_swing)
leg_swing.SetRot(q)
# leg_swing.SetBodyFixed(True)
mysystem.Add(leg_swing)

# Create stance leg
leg_stance = chrono.ChBodyEasyCylinder(leg_radius, leg_length, leg_density,True,True,contact_material)
center_leg_stance= stance_hip_frame*chrono.ChVectorD(-(leg_length/2)*np.sin(phi-theta),-(leg_length/2)*np.cos(phi-theta),0)
print(center_leg_stance)
q = chrono.ChQuaternionD()
q.Q_from_AngAxis((phi-theta), chrono.ChVectorD(0,0,-1))
print('q',q)
leg_stance.SetPos(center_leg_stance)
leg_stance.SetRot(q)
# leg_stance.SetBodyFixed(True)
mysystem.Add(leg_stance)

# Create feet
foot_swing = chrono.ChBodyEasyCylinder(foot_radius, foot_length, foot_density,True,True,contact_material)
end_leg_swing= swing_hip_frame*chrono.ChVectorD(-(leg_length+foot_radius)*np.sin(-theta),-(leg_length+foot_radius)*np.cos(-theta),0)
print(end_leg_swing)
q1 = chrono.ChQuaternionD()
q1.Q_from_AngAxis(-theta, chrono.ChVectorD(0,0,-1))
q2 = chrono.ChQuaternionD()
q2.Q_from_AngAxis(np.radians(90), chrono.ChVectorD(1,0,0))
print('q',q1*q2)
foot_swing.SetPos(end_leg_swing)
foot_swing.SetRot(q1*q2)
# foot_swing.SetBodyFixed(True)
mysystem.Add(foot_swing)

foot_stance = chrono.ChBodyEasyCylinder(foot_radius, foot_length, foot_density,True,True,contact_material)
end_leg_stance=  stance_hip_frame*chrono.ChVectorD(-(leg_length+foot_radius)*np.sin(phi-theta),-(leg_length+foot_radius)*np.cos(phi-theta),0)
print(end_leg_stance)
q1 = chrono.ChQuaternionD()
q1.Q_from_AngAxis(-theta, chrono.ChVectorD(0,0,-1))
q2 = chrono.ChQuaternionD()
q2.Q_from_AngAxis(np.radians(90), chrono.ChVectorD(1,0,0))
print('q',q1*q2)
foot_stance.SetPos(end_leg_stance)
foot_stance.SetRot(q1*q2)
# foot_stance.SetBodyFixed(True)
mysystem.Add(foot_stance)



# ---------------------------------------------------------------------
#
#  Add Constraints
#

# Add a revolute joint where the leg connects to the hip 
hipJoint_swing = chrono.ChLinkLockRevolute()
hipJoint_swing.SetName('Revolute')
hipJoint_swing.Initialize(leg_swing,hipBody,True,chrono.ChCoordsysD(chrono.ChVectorD(0,leg_length/2,0),chrono.ChQuaternionD(1, 0, 0, 0)),chrono.ChCoordsysD(chrono.ChVectorD(0,0,0.1),chrono.ChQuaternionD(1, 0, 0, 0)))
mysystem.AddLink(hipJoint_swing)

hipJoint_stance = chrono.ChLinkLockRevolute()
hipJoint_stance.SetName('Revolute2')
hipJoint_stance.Initialize(leg_stance,hipBody,True,chrono.ChCoordsysD(chrono.ChVectorD(0,leg_length/2,0),chrono.ChQuaternionD(1, 0, 0, 0)),chrono.ChCoordsysD(chrono.ChVectorD(0,0,-0.1),chrono.ChQuaternionD(1, 0, 0, 0)))
mysystem.AddLink(hipJoint_stance)


# Add some limits since we don't want the walker to do the splits

# hipJoint_swing.GetLimit_Rz().SetActive(True)
# hipJoint_swing.GetLimit_Rz().SetMin((math.pi)/3)
# hipJoint_swing.GetLimit_Rz().SetMax(-(math.pi)/3)

# hipJoint_stance.GetLimit_Rz().SetActive(True)
# hipJoint_stance.GetLimit_Rz().SetMin((math.pi)/3)
# hipJoint_stance.GetLimit_Rz().SetMax(-(math.pi)/3)

# Constraint to fix the feet to the bottom of the legs

ankleJoint_swing = chrono.ChLinkMateFix()
ankleJoint_swing.Initialize(leg_swing, foot_swing)
mysystem.AddLink(ankleJoint_swing)

ankleJoint_stance = chrono.ChLinkMateFix()
ankleJoint_stance.Initialize(leg_stance, foot_stance)
mysystem.AddLink(ankleJoint_stance)

# alignhip = chrono.ChLinkLockParallel()
# alignhip.Initialize(mfloor,hipBody,True,chrono.ChCoordsysD(chrono.ChVectorD(0,1,0),chrono.ChQuaternionD(1, 0, 0, 0)),chrono.ChCoordsysD(chrono.ChVectorD(0,1,0),chrono.ChQuaternionD(1, 0, 0, 0)))
# mysystem.AddLink(alignhip)

plane_plane_swing = chrono.ChLinkLockPlanePlane()
plane_plane_swing.Initialize(mfloor, 
                        leg_swing, 
                        chrono.ChCoordsysD(chrono.ChVectorD(-1.25, -0.75, 0), chrono.ChQuaternionD(1, 0, 0, 0)))
mysystem.AddLink(plane_plane_swing)

plane_plane_stance = chrono.ChLinkLockPlanePlane()
plane_plane_stance.Initialize(mfloor, 
                        leg_stance, 
                        chrono.ChCoordsysD(chrono.ChVectorD(-1.25, -0.75, 0), chrono.ChQuaternionD(1, 0, 0, 0)))
mysystem.AddLink(plane_plane_stance)


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

sticky_stance = chrono.ChLinkRevolute()
sticky_stance.Initialize(foot_stance,mfloor,foot_stance.GetFrame_REF_to_abs())
mysystem.AddLink(sticky_stance)

sticky_swing = chrono.ChLinkRevolute()
sticky_swing.Initialize(foot_swing,mfloor,foot_swing.GetFrame_REF_to_abs())
mysystem.AddLink(sticky_swing)

# sticky_stance.SetDisabled(False)
myapplication.SetTimestep(0.0005)

while(myapplication.GetDevice().run()):
    myapplication.BeginScene()
    chronoirr.ChIrrTools.drawAllCOGs(mysystem, myapplication.GetVideoDriver(), 2)
    myapplication.DrawAll()
    t = mysystem.GetChTime()
    print('time: ',mysystem.GetChTime())
    if t<0.4:
        sticky_stance.SetDisabled(False)
        sticky_swing.SetDisabled(True)
        # print(sticky_stance.GetLeftDOF())
    else:
        sticky_stance.SetDisabled(True)
        sticky_swing.SetDisabled(False)
        # print(sticky_stance.GetLeftDOF())
        # print(sticky_stance.IsActive())
    myapplication.DoStep()
    myapplication.EndScene()


