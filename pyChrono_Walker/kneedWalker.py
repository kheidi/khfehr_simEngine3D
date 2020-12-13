
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

incline = np.radians(3)
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
mfloor = chrono.ChBodyEasyBox(3, floor_thickness, 1, 100000,True,True, contact_material)
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

#fix = True
fix = False

mymass = 10 #kg
foot_mass = mymass*0.0133 #https://exrx.net/Kinesiology/Segments
leg_mass = mymass*0.0535
leg_mass = 0.01
leg_length = .1
leg_radius = 0.005
leg_volume = math.pi*pow(leg_radius,2)*leg_length
leg_density = leg_mass/leg_volume
theta1 = np.radians(5)
theta2 = np.radians(30)
leg_inertia = chrono.ChVectorD(0.5*leg_mass*pow(leg_radius,2), (leg_mass/12)*(3*pow(leg_radius,2)+pow(leg_length,2)),(leg_mass/12)*(3*pow(leg_radius,2)+pow(leg_length,2)))
foot_length = 0.005
foot_radius = 0.03
foot_volume = math.pi*pow(foot_radius,2)*foot_length
foot_density = foot_mass/foot_volume

# Knee Properties
thigh_mass = leg_mass/2
thigh_length = leg_length/2
thigh_radius = leg_radius
thigh_volume = math.pi*pow(thigh_radius,2)*thigh_length
thigh_density = thigh_mass/thigh_volume
thigh_inertia = chrono.ChVectorD(0.5*thigh_mass*pow(thigh_radius,2), (thigh_mass/12)*(3*pow(thigh_radius,2)+pow(thigh_length,2)),(thigh_mass/12)*(3*pow(thigh_radius,2)+pow(thigh_length,2)))
shank_mass = leg_mass/2
shank_length = leg_length/2
shank_radius = leg_radius
shank_volume = math.pi*pow(shank_radius,2)*shank_length
shank_density = shank_mass/shank_volume
shank_inertia = chrono.ChVectorD(0.5*shank_mass*pow(shank_radius,2), (shank_mass/12)*(3*pow(shank_radius,2)+pow(shank_length,2)),(shank_mass/12)*(3*pow(shank_radius,2)+pow(shank_length,2)))


initial_hipPos = chrono.ChVectorD(0,leg_length,0)
print('hipPos',initial_hipPos)

# Create hip
hipBody = chrono.ChBodyEasyEllipsoid(chrono.ChVectorD(.02,.02,.02 ),leg_density,True,False,contact_material)
hipBody.SetPos(initial_hipPos)
mysystem.Add(hipBody)

# Hip Joint locations
swing_hipJoint_P = chrono.ChMarker()
h = hipBody.GetPos()
swing_hipJoint_P.SetPos(chrono.ChVectorD(h.x,h.y,h.z+0.01))
hipBody.AddMarker(swing_hipJoint_P)
print('swing hip', swing_hipJoint_P.GetPos())

stance_hipJoint_P = chrono.ChMarker()
stance_hipJoint_P.SetPos(chrono.ChVectorD(h.x,h.y,(h.z-0.01)))
hipBody.AddMarker(stance_hipJoint_P)
print('stance hip', stance_hipJoint_P.GetPos())

# Make a reference frame where the leg connects to the hip
swing_hip_frame = chrono.ChFrameD()
swing_hip_frame.SetCoord(swing_hipJoint_P.GetCoord())

stance_hip_frame = chrono.ChFrameD()
stance_hip_frame.SetCoord(stance_hipJoint_P.GetCoord())


# Create swing thigh
thigh_swing = chrono.ChBodyEasyCylinder(thigh_radius, thigh_length, thigh_density,True,False,contact_material)
center_thigh_swing= swing_hip_frame*chrono.ChVectorD(-(thigh_length/2)*np.sin(-theta2),-(thigh_length/2)*np.cos(-theta2),0)
print(center_thigh_swing)
q = chrono.ChQuaternionD()
q.Q_from_AngAxis(-theta2, chrono.ChVectorD(0,0,-1))
print('q',q)
thigh_swing.SetPos(center_thigh_swing)
thigh_swing.SetRot(q)
mysystem.Add(thigh_swing)

# Create stance thigh
thigh_stance = chrono.ChBodyEasyCylinder(thigh_radius, thigh_length, thigh_density,True,False,contact_material)
center_thigh_stance= stance_hip_frame*chrono.ChVectorD(-(thigh_length/2)*np.sin(theta1),-(thigh_length/2)*np.cos(theta1),0)
print(center_thigh_stance)
q = chrono.ChQuaternionD()
q.Q_from_AngAxis((theta1), chrono.ChVectorD(0,0,-1))
print('q',q)
thigh_stance.SetPos(center_thigh_stance)
thigh_stance.SetRot(q)
mysystem.Add(thigh_stance)

# knee Joint locations
swing_kneeJoint_P = chrono.ChMarker()
h = thigh_swing.GetPos()
swing_kneeJoint_P.SetPos(swing_hip_frame*chrono.ChVectorD(-(thigh_length)*np.sin(-theta2),-(thigh_length)*np.cos(-theta2),0))
thigh_swing.AddMarker(swing_kneeJoint_P)
print('swing knee', swing_kneeJoint_P.GetPos())

stance_kneeJoint_P = chrono.ChMarker()
h = thigh_stance.GetPos()
stance_kneeJoint_P.SetPos(stance_hip_frame*chrono.ChVectorD(-(thigh_length)*np.sin(theta1),-(thigh_length)*np.cos(theta1),0))
thigh_stance.AddMarker(stance_kneeJoint_P)
print('stance knee', stance_kneeJoint_P.GetPos())

# Make a reference frame where the leg connects to the knee
swing_knee_frame = chrono.ChFrameD()
swing_knee_frame.SetCoord(swing_kneeJoint_P.GetCoord())

stance_knee_frame = chrono.ChFrameD()
stance_knee_frame.SetCoord(stance_kneeJoint_P.GetCoord())

a = 8
b = 30

# Create swing shank
shank_swing = chrono.ChBodyEasyCylinder(shank_radius, shank_length, shank_density,True,False,contact_material)
center_shank_swing= swing_hip_frame*chrono.ChVectorD(-((3*shank_length)/2)*np.sin(-theta2-np.radians(15)),-((3*shank_length)/2)*np.cos(-theta2-np.radians(15)),0)
print(center_shank_swing)
q = chrono.ChQuaternionD()
q.Q_from_AngAxis((-theta2-np.radians(35)), chrono.ChVectorD(0,0,-1))
print('q',q)
shank_swing.SetPos(center_shank_swing)
shank_swing.SetRot(q)

mysystem.Add(shank_swing)

# Create stance shank
shank_stance = chrono.ChBodyEasyCylinder(shank_radius, shank_length, shank_density,True,False,contact_material)
center_shank_stance= stance_hip_frame*chrono.ChVectorD(-((3*shank_length)/2)*np.sin(theta1),-((3*shank_length)/2)*np.cos(theta1),0)
print(center_shank_stance)
q = chrono.ChQuaternionD()
q.Q_from_AngAxis((theta1), chrono.ChVectorD(0,0,-1))
print('q',q)
shank_stance.SetPos(center_shank_stance)
shank_stance.SetRot(q)
mysystem.Add(shank_stance)

if fix == True:
    hipBody.SetBodyFixed(True)
    thigh_stance.SetBodyFixed(True)
    shank_stance.SetBodyFixed(True)
    shank_swing.SetBodyFixed(True)
    thigh_swing.SetBodyFixed(True)

# Create feet
foot_swing = chrono.ChBodyEasyCylinder(foot_radius, foot_length, foot_density,True,True,contact_material)
end_leg_swing= swing_knee_frame*chrono.ChVectorD(-(shank_length-foot_radius)*np.sin(-theta2),-(shank_length-foot_radius)*np.cos(-theta2),0)
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
end_leg_stance=  stance_knee_frame*chrono.ChVectorD(-(shank_length-foot_radius)*np.sin(theta1),-(shank_length-foot_radius)*np.cos(theta1),0)
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

Jprim1.Initialize(thigh_stance,
                  mfloor,True,
                  chrono.ChVectorD(0,0,1),
                  chrono.ChVectorD(0,0,1),
                  chrono.ChVectorD(0,0,1),
                  chrono.ChVectorD(0,0,1))

mysystem.AddLink(Jprim1)

Jprim2 = chrono.ChLinkMateParallel()

Jprim2.Initialize(shank_stance,
                  mfloor,True,
                  chrono.ChVectorD(0,0,1),
                  chrono.ChVectorD(0,0,1),
                  chrono.ChVectorD(0,0,1),
                  chrono.ChVectorD(0,0,1))

mysystem.AddLink(Jprim2)

# Add a revolute joint where the leg connects to the hip 
hipJoint_swing = chrono.ChLinkLockRevolute()
hipJoint_swing.SetName('Revolute')
hipJoint_swing.Initialize(thigh_swing,hipBody,True,chrono.ChCoordsysD(chrono.ChVectorD(0,thigh_length/2,0),chrono.ChQuaternionD(1, 0, 0, 0)),chrono.ChCoordsysD(chrono.ChVectorD(0,0,0.01),chrono.ChQuaternionD(1, 0, 0, 0)))
mysystem.AddLink(hipJoint_swing)

hipJoint_stance = chrono.ChLinkLockRevolute()
hipJoint_stance.SetName('Revolute2')
hipJoint_stance.Initialize(thigh_stance,hipBody,True,chrono.ChCoordsysD(chrono.ChVectorD(0,thigh_length/2,0),chrono.ChQuaternionD(1, 0, 0, 0)),chrono.ChCoordsysD(chrono.ChVectorD(0,0,-0.01),chrono.ChQuaternionD(1, 0, 0, 0)))
mysystem.AddLink(hipJoint_stance)

# Add a revolute joint where the thigh connects to the shank
kneeJoint_swing = chrono.ChLinkLockRevolute()
kneeJoint_swing.SetName('Revolute')
kneeJoint_swing.Initialize(shank_swing,thigh_swing,True,chrono.ChCoordsysD(chrono.ChVectorD(0,shank_length/2,0),chrono.ChQuaternionD(1, 0, 0, 0)),chrono.ChCoordsysD(chrono.ChVectorD(0,-thigh_length/2,0),chrono.ChQuaternionD(1, 0, 0, 0)))
mysystem.AddLink(kneeJoint_swing)

kneeJoint_stance = chrono.ChLinkLockRevolute()
kneeJoint_stance.SetName('Revolute2')
kneeJoint_stance.Initialize(shank_stance,thigh_stance,True,chrono.ChCoordsysD(chrono.ChVectorD(0,shank_length/2,0),chrono.ChQuaternionD(1, 0, 0, 0)),chrono.ChCoordsysD(chrono.ChVectorD(0,-thigh_length/2,0),chrono.ChQuaternionD(1, 0, 0, 0)))
mysystem.AddLink(kneeJoint_stance)

# Add some limits since we don't want the walker to do the splits

# hipJoint_swing.GetLimit_Rz().SetActive(True)
# hipJoint_swing.GetLimit_Rz().SetMin((math.pi)/3)
# hipJoint_swing.GetLimit_Rz().SetMax(-(math.pi)/3)

# hipJoint_stance.GetLimit_Rz().SetActive(True)
# hipJoint_stance.GetLimit_Rz().SetMin((math.pi)/3)
# hipJoint_stance.GetLimit_Rz().SetMax(-(math.pi)/3)

# Constraint to fix the feet to the bottom of the legs

ankleJoint_swing = chrono.ChLinkMateFix()
ankleJoint_swing.Initialize(shank_swing, foot_swing)
mysystem.AddLink(ankleJoint_swing)

ankleJoint_stance = chrono.ChLinkMateFix()
ankleJoint_stance.Initialize(foot_stance, shank_stance)
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
array_stancefoot_x = []
array_stancefoot_y = []
array_swingfoot_x = []
array_swingfoot_y = []

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
    stance_V = thigh_stance.GetPos()-stance_hip_frame.GetPos()
    stance_V_norm = stance_V/(np.sqrt(pow(stance_V.x,2)+pow(stance_V.y,2)+pow(stance_V.z,2)))
    swing_V = thigh_swing.GetPos()-swing_hip_frame.GetPos()
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
    array_stancefoot_x.append(foot_stance.GetPos().x-foot_radius)
    array_stancefoot_y.append(foot_stance.GetPos().y-foot_radius)
    array_swingfoot_x.append(foot_swing.GetPos().x-foot_radius)
    array_swingfoot_y.append(foot_swing.GetPos().y-foot_radius)
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


df = pd.DataFrame({"time" : array_time,
                   "angle" : array_angle,
                   "Togtime" : array_togtime,
                   "Stance Pos X": array_stancefoot_x,
                   "Stance Pos Y": array_stancefoot_y,
                   "Swing Pos X": array_swingfoot_x,
                   "Swing Pos Y": array_swingfoot_y
                   })
df.to_csv("results.csv", index=False)