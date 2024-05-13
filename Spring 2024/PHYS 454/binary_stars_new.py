# -*- coding: utf-8 -*-
"""Binary Stars
"""

"""---

https://orbital-mechanics.space/the-n-body-problem/two-body-inertial-numerical-solution.html
"""

import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp
import numpy as np
import matplotlib.animation as animation
from matplotlib import rc
rc('animation', html='jshtml')

sol_mass = 2e30 # mass of sun in kg
G = 6.67430e-20  # km**3/(kg * s**2)
m_1 = sol_mass * 3.17 # kg
m_2 = sol_mass * 0.70  # kg

# Initial State Vector
R_1_0 = np.array((0, 0, 0))  # km
R_2_0 = np.array((3000, 0, 0))  # km
dotR_1_0 = np.array((5, 20, 0))  # km/s
dotR_2_0 = np.array((0, 40, 5))  # km/s

y_0 = np.hstack((R_1_0, R_2_0, dotR_1_0, dotR_2_0))

def absolute_motion(t, y):
    """Calculate the motion of a two-body system in an inertial reference frame.

    The state vector ``y`` should be in the order:

    1. Coordinates of $m_1$
    2. Coordinates of $m_2$
    3. Velocity components of $m_1$
    4. Velocity components of $m_2$
    """
    # Get the six coordinates for m_1 and m_2 from the state vector
    R_1 = y[:3]
    R_2 = y[3:6]

    # Fill the derivative vector with zeros
    ydot = np.zeros_like(y)

    # Set the first 6 elements of the derivative equal to the last
    # 6 elements of the state vector, which are the velocities
    ydot[:6] = y[6:]

    # Calculate the acceleration terms and fill them in to the rest
    # of the derivative array
    r = np.sqrt(np.sum(np.square(R_2 - R_1)))
    ddot = G * (R_2 - R_1) / r**3
    ddotR_1 = m_2 * ddot
    ddotR_2 = -m_1 * ddot

    ydot[6:9] = ddotR_1
    ydot[9:] = ddotR_2
    return ydot

t_0 = 0  # seconds
t_f = 480  # seconds
t_points = np.linspace(t_0, t_f, 1000)

sol = solve_ivp(absolute_motion, [t_0, t_f], y_0, t_eval=t_points)

y = sol.y.T
R_1 = y[:, :3]  # km
R_2 = y[:, 3:6]  # km
V_1 = y[:, 6:9]  # km/s
V_2 = y[:, 9:]  # km/s
barycenter = (m_1 * R_1 + m_2 * R_2) / (m_1 + m_2)  # km

fig = plt.figure()
ax = fig.add_subplot(111, projection="3d")
R1_rel_COG = R_1 - barycenter
R2_rel_COG = R_2 - barycenter
ax.plot(R1_rel_COG[:, 0], R1_rel_COG[:, 1], R1_rel_COG[:, 2], label="m_1")
ax.plot(R2_rel_COG[:, 0], R2_rel_COG[:, 1], R2_rel_COG[:, 2], label="m_2")
ax.plot(0, 0, 0, "r.", label="COG")
ax.plot([R1_rel_COG[0, 0], R2_rel_COG[0, 0]], [R1_rel_COG[0, 1], R2_rel_COG[0, 1]], [R1_rel_COG[0, 2], R2_rel_COG[0, 2]], "k--", label="COG")
ax.legend()
plt.show()

import matplotlib
matplotlib.rcParams['animation.embed_limit'] = 100
fig = plt.figure()
ax = fig.add_subplot(121, projection="3d")
ax1 = fig.add_subplot(122)

duration = 900

line_d = []
line_dy = []

def dist(i):
   d = np.sqrt((R2_rel_COG[i,0] - R1_rel_COG[i,0])**2 + (R2_rel_COG[i,1] - R1_rel_COG[i,1])**2 + (R2_rel_COG[i,2] - R1_rel_COG[i,2])**2)
   print(d)
   return d

def animate(i):
  if i < (duration - 60):
    ax.clear()
    ax1.clear()
    m1 = ax.plot(R1_rel_COG[i, 0], R1_rel_COG[i, 1], R1_rel_COG[i, 2], label="m_1", marker='o') # redraw m1
    m2 = ax.plot(R2_rel_COG[i, 0], R2_rel_COG[i, 1], R2_rel_COG[i, 2], label="m_2", marker='o') # redraw m2
    line1 = ax.plot(R1_rel_COG[:i, 0], R1_rel_COG[:i, 1], R1_rel_COG[:i, 2], label="m_1")       # trace m1
    line2 = ax.plot(R2_rel_COG[:i, 0], R2_rel_COG[:i, 1], R2_rel_COG[:i, 2], label="m_2")       # trace m2
    ax.plot(0, 0, 0, "ro", label="COG") # plot COG as origin
    ax.plot([R1_rel_COG[i, 0], R2_rel_COG[i, 0]], [R1_rel_COG[i, 1], R2_rel_COG[i, 1]], [R1_rel_COG[i, 2], R2_rel_COG[i, 2]], "k--", label="COG") # connecting line between R1 and R2

    line_d.append(i)
    line_dy.append(dist(i))
    dist_d = ax1.plot(i, dist(i), 'ko')
    line3 = ax1.plot(line_d, line_dy, 'k--')

    ax.set_xlabel('x')
    ax.set_ylabel('y')
    ax.set_zlabel('z')

    ax.set_xlim3d( np.min((R1_rel_COG[:,0], R2_rel_COG[:,0])), np.max((R1_rel_COG[:,0], R2_rel_COG[:,0])) ) # x-axis limits defined by minimum and maximum x value (comparing all values of R1 and R2)
    ax.set_ylim3d( np.min((R1_rel_COG[:,1], R2_rel_COG[:,1])), np.max((R1_rel_COG[:,1], R2_rel_COG[:,1])) ) # y-^^^^
    ax.set_zlim3d( np.min((R1_rel_COG[:,2], R2_rel_COG[:,2])), np.max((R1_rel_COG[:,2], R2_rel_COG[:,2])) ) # z-^^^^
    ax.view_init(elev = 40, azim = 10, roll = 0)
    ax.set_aspect('equal')
    plt.autoscale(True)
    ax._axis3don = False
    
    return m1, m2, line1, line2, dist_d, line3
  else:
    ax.view_init(elev = 30 + ((i - 1) - (duration - 60))/3, azim = 30 + ((i - 1) - (duration - 60))/3, roll = 0)
    return ax

ani = animation.FuncAnimation(fig, animate, duration, interval=100, blit=False, save_count=30, repeat=True)
plt.show()

# plt.rcParams['animation.ffmpeg_path'] ='C:\\ffmpeg\\bin\\ffmpeg.exe'
# FFwriter=animation.FFMpegWriter(fps=60, extra_args=['-vcodec', 'libx264'])
# ani.save('C:/Users/mania/Desktop/ME_Fall_2023/Spring 2024/PHYS 454/binaryStars.mp4', writer=FFwriter)