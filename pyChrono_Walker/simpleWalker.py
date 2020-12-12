
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
import matplotlib.pyplot as plt
import pandas as pd

# ---------------------------------------------------------------------
#
#  Create the simulation system and add items
#

incline = np.radians(1)
mysystem  = chrono.ChSystemNSC()
mysystem.Set_G_acc(chrono.ChVectorD(-9.810*np.sin(incline),-9.810*np.cos(incline),0))


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
# contact_material.SetCompliance (0.0005)
# contact_material.SetComplianceT(0.0005)

# Create floor
floor_thickness = 0.3
mfloor = chrono.ChBodyEasyBox(20, floor_thickness, 6, 100000,True,True, contact_material)
mfloor.SetPos(chrono.ChVectorD(0, -floor_thickness/2, 0))
# mfloor.SetRot( chrono.ChQuaternionD(  -0.0610485, 0, 0, 0.9981348  )) # Tilt the floor -7 degrees
mfloor.SetBodyFixed(True)
mysystem.Add(mfloor)

# Attach color asset
mfloorcolor = chrono.ChColorAsset()
mfloorcolor.SetColor(chrono.ChColor(0.3, 0.3, 0.95))
mfloor.AddAsset(mfloorcolor)

# Create wall to simulate in 2D
mwall = chrono.ChBodyEasyBox(20,6,0.3,10000,True,True,contact_material)
mwall.SetPos(chrono.ChVectorD(0,3,2.85))
# mwall.SetRot( chrono.ChQuaternionD(  -0.0610485, 0, 0, 0.9981348  )) # Tilt the floor -7 degrees
mwall.SetBodyFixed(True)
mysystem.Add(mwall)
mwall.AddAsset(mfloorcolor)


# ---------------------------------------------------------------------
#
#  Create bodies
#

# Define Properties

mymass = 10 #kg
foot_mass = mymass*0.00133 #https://exrx.net/Kinesiology/Segments
leg_mass = mymass*0.0535
leg_mass = 0.01
leg_length = .1
leg_radius = 0.005
leg_volume = math.pi*pow(leg_radius,2)*leg_length
leg_density = leg_mass/leg_volume
theta1 = np.radians(11.5)
theta2 = np.radians(7)
leg_inertia = chrono.ChVectorD(0.5*leg_mass*pow(leg_radius,2), (leg_mass/12)*(3*pow(leg_radius,2)+pow(leg_length,2)),(leg_mass/12)*(3*pow(leg_radius,2)+pow(leg_length,2)))
foot_length = 0.005
foot_radius = 0.03
foot_volume = math.pi*pow(foot_radius,2)*foot_length
foot_density = foot_mass/foot_volume

initial_hipPos = chrono.ChVectorD(0,0.1,0)
print('hipPos',initial_hipPos)

# Create hip
hipBody = chrono.ChBodyEasyEllipsoid(chrono.ChVectorD(.02,.02,.02 ),leg_density,True,False,contact_material)
hipBody.SetPos(initial_hipPos)
# hipBody.SetBodyFixed(True)
mysystem.Add(hipBody)

# Hip Joint locations
swing_hipJoint_P = chrono.ChMarker()
h = hipBody.GetPos()
swing_hipJoint_P.SetPos(chrono.ChVectorD(h.x,h.y,h.z+0.001))
hipBody.AddMarker(swing_hipJoint_P)
print('swing hip', swing_hipJoint_P.GetPos())

stance_hipJoint_P = chrono.ChMarker()
stance_hipJoint_P.SetPos(chrono.ChVectorD(h.x,h.y,(h.z-0.001)))
hipBody.AddMarker(stance_hipJoint_P)
print('stance hip', stance_hipJoint_P.GetPos())

# Make a reference frame where the leg connects to the hip
swing_hip_frame = chrono.ChFrameD()
swing_hip_frame.SetCoord(swing_hipJoint_P.GetCoord())

stance_hip_frame = chrono.ChFrameD()
stance_hip_frame.SetCoord(stance_hipJoint_P.GetCoord())

# Create swing leg
leg_swing = chrono.ChBodyEasyCylinder(leg_radius, leg_length, leg_density,True,False,contact_material)
center_leg_swing= swing_hip_frame*chrono.ChVectorD(-(leg_length/2)*np.sin(-theta2),-(leg_length/2)*np.cos(-theta2),0)
print(center_leg_swing)
q = chrono.ChQuaternionD()
q.Q_from_AngAxis(-theta2, chrono.ChVectorD(0,0,-1))
print('q',q)
leg_swing.SetPos(center_leg_swing)
leg_swing.SetRot(q)
# leg_swing.SetBodyFixed(True)
mysystem.Add(leg_swing)

# Create stance leg
leg_stance = chrono.ChBodyEasyCylinder(leg_radius, leg_length, leg_density,True,False,contact_material)
center_leg_stance= stance_hip_frame*chrono.ChVectorD(-(leg_length/2)*np.sin(theta1),-(leg_length/2)*np.cos(theta1),0)
print(center_leg_stance)
q = chrono.ChQuaternionD()
q.Q_from_AngAxis((theta1), chrono.ChVectorD(0,0,-1))
print('q',q)
leg_stance.SetPos(center_leg_stance)
leg_stance.SetRot(q)
# leg_stance.SetBodyFixed(True)
mysystem.Add(leg_stance)

# Create feet
foot_swing = chrono.ChBodyEasyCylinder(foot_radius, foot_length, foot_density,True,True,contact_material)
end_leg_swing= swing_hip_frame*chrono.ChVectorD(-(leg_length-foot_radius+0.001)*np.sin(-theta2),-(leg_length-foot_radius+0.001)*np.cos(-theta2),0)
print(end_leg_swing)
q1 = chrono.ChQuaternionD()
q1.Q_from_AngAxis(-theta2, chrono.ChVectorD(0,0,-1))
q2 = chrono.ChQuaternionD()
q2.Q_from_AngAxis(np.radians(90), chrono.ChVectorD(1,0,0))
print('q',q1*q2)
foot_swing.SetPos(end_leg_swing)
foot_swing.SetRot(q1*q2)
# foot_swing.SetBodyFixed(True)
mysystem.Add(foot_swing)

foot_stance = chrono.ChBodyEasyCylinder(foot_radius, foot_length, foot_density,True,True,contact_material)
end_leg_stance=  stance_hip_frame*chrono.ChVectorD(-(leg_length-foot_radius+0.001)*np.sin(theta1),-(leg_length-foot_radius+0.001)*np.cos(theta1),0)
print(end_leg_stance)
q1 = chrono.ChQuaternionD()
q1.Q_from_AngAxis(theta1, chrono.ChVectorD(0,0,-1))
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

Jprim1 = chrono.ChLinkMateParallel()

Jprim1.Initialize(leg_stance,
                  mfloor,True,
                  chrono.ChVectorD(0,0,1),
                  chrono.ChVectorD(0,0,1),
                  chrono.ChVectorD(0,0,1),
                  chrono.ChVectorD(0,0,1))

mysystem.AddLink(Jprim1)

# Add a revolute joint where the leg connects to the hip 
hipJoint_swing = chrono.ChLinkLockRevolute()
hipJoint_swing.SetName('Revolute')
hipJoint_swing.Initialize(leg_swing,hipBody,True,chrono.ChCoordsysD(chrono.ChVectorD(0,leg_length/2,0),chrono.ChQuaternionD(1, 0, 0, 0)),chrono.ChCoordsysD(chrono.ChVectorD(0,0,0.01),chrono.ChQuaternionD(1, 0, 0, 0)))
mysystem.AddLink(hipJoint_swing)

hipJoint_stance = chrono.ChLinkLockRevolute()
hipJoint_stance.SetName('Revolute2')
hipJoint_stance.Initialize(leg_stance,hipBody,True,chrono.ChCoordsysD(chrono.ChVectorD(0,leg_length/2,0),chrono.ChQuaternionD(1, 0, 0, 0)),chrono.ChCoordsysD(chrono.ChVectorD(0,0,-0.01),chrono.ChQuaternionD(1, 0, 0, 0)))
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
ankleJoint_stance.Initialize(foot_stance, leg_stance)
mysystem.AddLink(ankleJoint_stance)

# alignhip = chrono.ChLinkLockParallel()
# alignhip.Initialize(mfloor,hipBody,True,chrono.ChCoordsysD(chrono.ChVectorD(0,1,0),chrono.ChQuaternionD(1, 0, 0, 0)),chrono.ChCoordsysD(chrono.ChVectorD(0,1,0),chrono.ChQuaternionD(1, 0, 0, 0)))
# mysystem.AddLink(alignhip)

# plane_plane_swing = chrono.ChLinkLockPlanePlane()
# plane_plane_swing.Initialize(mfloor, 
#                         leg_swing, 
#                         chrono.ChCoordsysD(chrono.ChVectorD(-1.25, -0.75, 0), chrono.ChQuaternionD(1, 0, 0, 0)))
# mysystem.AddLink(plane_plane_swing)

# plane_plane_stance = chrono.ChLinkLockPlanePlane()
# plane_plane_stance.Initialize(mfloor, 
#                         leg_stance, 
#                         chrono.ChCoordsysD(chrono.ChVectorD(-1.25, -0.75, 0), chrono.ChQuaternionD(1, 0, 0, 0)))
# mysystem.AddLink(plane_plane_stance)


# ---------------------------------------------------------------------
#
#  Create an Irrlicht application to visualize the system

myapplication = chronoirr.ChIrrApp(mysystem, 'PyChrono example', chronoirr.dimension2du(1024,768))

myapplication.AddTypicalSky()
myapplication.AddTypicalLogo(chrono.GetChronoDataFile('logo_pychrono_alpha.png'))
myapplication.AddTypicalCamera(chronoirr.vector3df(0,4,-6), chronoirr.vector3df(0,0,0))
myapplication.AddTypicalCamera(chronoirr.vector3df(0, 0.3, -0.4))
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

# sticky_stance = chrono.ChLinkRevolute()
# sticky_stance.Initialize(foot_stance,mfloor,foot_stance.GetFrame_REF_to_abs())
# mysystem.AddLink(sticky_stance)

# sticky_swing = chrono.ChLinkRevolute()
# sticky_swing.Initialize(foot_swing,mfloor,foot_swing.GetFrame_REF_to_abs())
# mysystem.AddLink(sticky_swing)

# sticky_stance.SetDisabled(True)
# sticky_swing.SetDisabled(True)
myapplication.SetTimestep(0.0005)

array_time = []
array_hipY = []
array_hipX = []
array_angle = []
array_case = []
array_togtime = []

case = True
togtime = 0
togtime_Threshold = 0.05
angle_Threshold = 40


while(myapplication.GetDevice().run()):
    myapplication.BeginScene()
    chronoirr.ChIrrTools.drawAllCOGs(mysystem, myapplication.GetVideoDriver(), 2)
    myapplication.DrawAll()
    t = mysystem.GetChTime()
    print('time: ',mysystem.GetChTime())
    stance_V = foot_stance.GetPos()-leg_stance.GetPos()
    stance_V_norm = stance_V/(np.sqrt(pow(stance_V.x,2)+pow(stance_V.y,2)+pow(stance_V.z,2)))
    swing_V = foot_swing.GetPos()-leg_swing.GetPos()
    swing_V_norm = swing_V/(np.sqrt(pow(swing_V.x,2)+pow(swing_V.y,2)+pow(swing_V.z,2)))
    stance_array = np.array([stance_V_norm.x,stance_V_norm.y,stance_V_norm.z])
    swing_array = np.array([swing_V_norm.x,swing_V_norm.y,swing_V_norm.z])
    
    angleBWLegs = np.degrees(np.arccos(np.dot(stance_array,swing_array)))
    print('angle: ',(angleBWLegs))
    
    togtime = togtime + myapplication.GetTimestep()
    if t>0.15 and t<=0.25:
        foot_swing.SetCollide(False)
    elif t>0.25:
        if togtime >= togtime_Threshold:
            if angleBWLegs > angle_Threshold-2 and angleBWLegs < angle_Threshold+2:
                case = not case
                togtime = 0
                
        if case == 0:
            foot_swing.SetCollide(True)
            foot_stance.SetCollide(False)
        elif case == 1:
            foot_swing.SetCollide(False)
            foot_stance.SetCollide(True)

           
    
        
    # sticky_stance.Initialize(foot_stance,mfloor,foot_stance.GetFrame_REF_to_abs())
    # sticky_swing.Initialize(foot_swing,mfloor,foot_swing.GetFrame_REF_to_abs())
    # if t>0.15 and t<=0.3:
    #     foot_swing.SetCollide(False)
    #     sticky_stance.SetDisabled(False)
    #     sticky_swing.SetDisabled(True)
    #     # print(sticky_stance.GetLeftDOF())
    # elif t>0.3:#t>=0.4 and t<0.85:
    #     foot_swing.SetCollide(True)
    #     foot_stance.SetCollide(False)
    #     sticky_stance.SetDisabled(True)
    #     sticky_swing.SetDisabled(False)
    #     # print(sticky_stance.GetLeftDOF())
    #     # print(sticky_stance.IsActive())
    # else:
    #     sticky_stance.SetDisabled(False)
    #     sticky_swing.SetDisabled(True)
    array_time.append(mysystem.GetChTime())
    array_hipY.append(hipJoint_stance.GetLinkAbsoluteCoords().pos.y)
    array_hipX.append(hipJoint_stance.GetLinkAbsoluteCoords().pos.x)
    array_angle.append(angleBWLegs)
    array_togtime.append(togtime)
    array_case.append(case)
    myapplication.DoStep()
    myapplication.EndScene()
    

fig, (ax1, ax2) = plt.subplots(2, sharex = True)


ax1.plot(array_time, array_angle)
ax1.set(ylabel='Angle between Legs')
ax1.grid()

ax2.plot(array_time, array_case)
ax2.set(ylabel='Case')
ax2.grid()

plt.savefig('Graph.png')


df = pd.DataFrame({"time" : array_time, "angle" : array_angle, "Togtime" : array_togtime})
df.to_csv("results.csv", index=False)