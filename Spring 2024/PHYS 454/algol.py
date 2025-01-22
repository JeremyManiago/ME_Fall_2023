import matplotlib.pyplot as plt
import matplotlib.animation as animation
from matplotlib import rc
from matplotlib.ticker import ScalarFormatter
from matplotlib.backends.backend_agg import FigureCanvasAgg
from matplotlib.figure import Figure

from PIL import Image

from scipy.integrate import solve_ivp
from scipy.spatial.transform import Rotation as R

import numpy as np

# from __future__ import print_function, division
# from PyAstronomy import pyasl
# rr = pyasl.Ramirez2005()
# Which color bands are available
# print("Available color bands: ", rr.availableBands())

rc('animation', html='jshtml')

'''
https://en.wikipedia.org/wiki/Algol
'''

'''
Constants
'''
sol_mass = 2e30     # mass of sun in kg
sol_r = 695700      # radius of sun in km
sol_L = 3.828e26    # luminosity of the sun in Watts
G = 6.67430e-20     # km**3/(kg * s**2)

'''
Astrometry of Algol System
'''
d = 28          # parsecs

'''
Details of beta per Aa1
'''
m1 = sol_mass * 3.17
r1 = sol_r * 2.73
L1 = sol_L * 182
T1 = 13000  # Kelvin
# c1 = rr.teffToColor("B-V", T1, 0.0)
# print(c1)

'''
Details of beta per Aa2
'''
m2 = sol_mass * 0.70
r2 = sol_r * 3.48
L2 = sol_L * 6.92
T2 = 4500  # Kelvin

'''
Orbital Parameters of beta per Aa2 around beta per Aa1 
'''
p = 2.867328    # period in days
a = 0.00215     # semi-major axis in arcseconds
e = 0           # eccentricity
i = 98.70       # inclination in degrees
omega = 43.43   # longitude of the node in degrees

'''
Conversions
'''
d = d * 206265 # AU
a = a * (np.pi/(180 * 3600))    # radians
a = a * d * 1.496e8 # km
print("Semi-major axis = " + str("{:e}".format(a)) + " km. Since eccentricity = " + str(e) + ", the orbit is ciruclar and the semi-major axis \n is equivalent to the radius of the orbit.")
r = a

# Define the Euler angles
phi = omega - 180   # alpha
theta = -i          # beta
psi = 90            # gamma

def Rx(theta):
  return np.matrix([[ 1, 0           , 0           ],
                   [ 0, np.cos(theta),-np.sin(theta)],
                   [ 0, np.sin(theta), np.cos(theta)]])
  
def Ry(theta):
  return np.matrix([[ np.cos(theta), 0, np.sin(theta)],
                   [ 0           , 1, 0           ],
                   [-np.sin(theta), 0, np.cos(theta)]])
  
def Rz(theta):
  return np.matrix([[ np.cos(theta), -np.sin(theta), 0 ],
                   [ np.sin(theta), np.cos(theta) , 0 ],
                   [ 0           , 0            , 1 ]])

R = Rz(psi) * Ry(theta) * Rx(phi) # Create a rotation matrix from the Euler angles


center = [0,0,0]
thet = np.linspace(0, 2*np.pi, 200)
x = (r * np.cos(thet) + center[0])
y = (r * np.sin(thet) + center[1])
z = (np.zeros(len(x)))
coord = np.zeros((len(x),3))
# print(len(x))

for j in range(len(x)):
    arr = R * [[x[j]], [y[j]], [z[j]]]
    coord[j,0] = arr[0]
    coord[j,1] = arr[1]
    coord[j,2] = arr[2]
# print(coord[:,2])

'''
Plotting
'''

fig = plt.figure(figsize=(10,5))
ax = fig.add_subplot(131, projection="3d")
ax1 = fig.add_subplot(132, projection="3d")
ax2 = fig.add_subplot(133)

u1 = np.linspace(0, 2 * np.pi, 50)
v1 = np.linspace(0, np.pi, 50)
x1 = r1 * np.outer(np.cos(u1), np.sin(v1)) + center[0]
y1 = r1 * np.outer(np.sin(u1), np.sin(v1)) + center[1]
z1 = r1 * np.outer(np.ones(np.size(u1)), np.cos(v1)) + center[2]
# print(z1)

step = 9
u2 = np.linspace(0, 2 * np.pi, 50)
v2 = np.linspace(0, np.pi, 50)
x2 = r2 * np.outer(np.cos(u2), np.sin(v2)) + coord[step, 0]
y2 = r2 * np.outer(np.sin(u2), np.sin(v2)) + coord[step, 1]
z2 = r2 * np.outer(np.ones(np.size(u2)), np.cos(v2)) + coord[step, 2]

def plot_everything(ax):

    ax.plot(coord[:,0], coord[:,1], coord[:,2]) # plot orbit

    ax.plot_surface(x1, y1, z1, color='#CCFFFF') # plot beta per Aa1
    ax.set_aspect('equal')

    ax.plot_surface(x2, y2, z2, color='tab:orange') # plot beta per Aa2
    ax.set_aspect('equal')

    # ax.view_init(elev = 90, azim = 0, roll = 90)

    formatter = ScalarFormatter(useMathText=True)
    formatter.set_scientific(True)
    # formatter.set_powerlimits((-1,8))

    ax.set_xlabel('x [1e6 km]')
    ax.set_ylabel('y [1e6 km]')
    ax.set_zlabel('z [1e6 km]')
    ax.xaxis.set_major_formatter(formatter)
    ax.ticklabel_format(useOffset=False)

    ax.autoscale(False)
    # ax._axis3don = False
    ax.set_xlim3d( np.min(coord[:,0]), np.max(coord[:,0]) ) # x-axis limits defined by minimum and maximum x value of orbit
    ax.set_ylim3d( np.min(coord[:,1]), np.max(coord[:,1]) ) # y-^^^^
    ax.set_zlim3d( np.min(coord[:,2]), np.max(coord[:,2]) ) # z-^^^^

plot_everything(ax)
ax.view_init(elev = 20, azim = -40, roll = 0)

plot_everything(ax1)
ax1.view_init(elev = 90, azim = 0, roll = 90)
ax1.zaxis.line.set_lw(0.)
ax1.set_zticks([])
ax1.set_zlabel(' ')
ax1.set_xlabel('x [km]')
ax1.set_ylabel('y [km]')
ax1.grid(False)
# ax1.plot(coord[:,0], coord[:,1], 'b', zdir='z', zs=-1e7)  # projection

ax2.plot(coord[:,0], coord[:,1], 'b', lw='0.25')
zorder1 = 0
zorder2 = 0
if(coord[step,2] > center[2]):
    zorder1 = 1
    zorder2 = 2
else:
    zorder1 = 2
    zorder2 = 1
c1 = plt.Circle((center[0], center[1]), r1, color='#CCFFFF', zorder=zorder1)
c2 = plt.Circle((coord[step,0], coord[step,1]), r2, color='tab:orange', zorder=zorder2)
ax2.add_patch(c1)
ax2.add_patch(c2)
ax2.set_aspect('equal')

fig.tight_layout()

plt.show()


'''
Projections
'''

fig = plt.figure(figsize=(10,5))
ax = fig.add_subplot(221)
ax1 = fig.add_subplot(222)
ax2 = fig.add_subplot(223)
ax3 = fig.add_subplot(224)

def plot_proj(ax,step):
    ax.plot(coord[:,0], coord[:,1], 'b', lw='0')
    zorder1 = 0
    zorder2 = 0
    if(coord[step,2] > center[2]):
        zorder1 = 1
        zorder2 = 2
    else:
        zorder1 = 2
        zorder2 = 1
    c1 = plt.Circle((center[0], center[1]), r1, color='#CCFFFF', zorder=zorder1)
    c2 = plt.Circle((coord[step,0], coord[step,1]), r2, color='tab:orange', zorder=zorder2)
    ax.add_patch(c1)
    ax.add_patch(c2)
    ax.set_aspect('equal')
    ax.set_xticks([])
    ax.set_xlabel(' ')
    ax.set_yticks([])
    ax.set_ylabel(' ')
    ax.grid(False)
    # ax.set_aspect('equal')
    ax.set_xlim( np.min(coord[:,0]) - 3e6, np.max(coord[:,0]) + 3e6)
    ax.set_ylim( np.min(coord[:,1]) - 3e6, np.max(coord[:,1]) + 3e6)

plot_proj(ax, 50 + 9)
ax.set_title('Full Luminosity')
plot_proj(ax1, 9)
ax1.set_title('Secondary Eclipse')
plot_proj(ax2, 150 + 9)
ax2.set_title('Full Luminosity')
plot_proj(ax3, 100 + 9)
ax3.set_title('Primary Eclipse')

# canvas = FigureCanvasAgg(fig)
# # Option 2: Retrieve a memoryview on the renderer buffer, and convert it to a
# # numpy array.
# canvas.draw()
# rgba = np.asarray(canvas.buffer_rgba())
# # ... and pass it to PIL.
# im = Image.fromarray(rgba)
# # This image can then be saved to any format supported by Pillow, e.g.:
# im.save("C:/Users/mania/Desktop/ME_Fall_2023/Spring 2024/PHYS 454/test.bmp")
# fig.tight_layout()
# fig.savefig('C:/Users/mania/Desktop/ME_Fall_2023/Spring 2024/PHYS 454/algol_luminosities.png', dpi = 600) # save to desired location

plt.show()

""" 

'''
Analyze images
'''
im1 = Image.open('C:/Users/mania/Desktop/ME_Fall_2023/Spring 2024/PHYS 454/plt1.png')
im2 = Image.open('C:/Users/mania/Desktop/ME_Fall_2023/Spring 2024/PHYS 454/plt2.png')
im3 = Image.open('C:/Users/mania/Desktop/ME_Fall_2023/Spring 2024/PHYS 454/plt3.png')
im4 = Image.open('C:/Users/mania/Desktop/ME_Fall_2023/Spring 2024/PHYS 454/plt4.png')
print(im1.format, im1.size, im1.mode)
print(im2.format, im2.size, im2.mode)
print(im3.format, im3.size, im3.mode)
print(im4.format, im4.size, im4.mode)

fig = plt.figure(figsize=(15,5))
ax = fig.add_subplot(141)
ax1 = fig.add_subplot(142)
ax2 = fig.add_subplot(143)
ax3 = fig.add_subplot(144)

ax.imshow(im2)
ax1.imshow(im2)
ax2.imshow(im3)
ax3.imshow(im4)
# plt.show()

imdata1 = np.array(im1, dtype=int)
imdata2 = np.array(im2, dtype=int)
imdata3 = np.array(im3, dtype=int)
imdata4 = np.array(im4, dtype=int) 

"""


'''
Animation???
'''
import matplotlib
matplotlib.rcParams['animation.embed_limit'] = 100
fig = plt.figure()
ax = fig.add_subplot(121, projection="3d")
ax1 = fig.add_subplot(122, projection="3d")

duration = 199
coord = np.flip(coord, 0)


def animate(i):
    ax.clear()
    ax1.clear()

    x2 = r2 * np.outer(np.cos(u2), np.sin(v2)) + coord[i, 0]
    y2 = r2 * np.outer(np.sin(u2), np.sin(v2)) + coord[i, 1]
    z2 = r2 * np.outer(np.ones(np.size(u2)), np.cos(v2)) + coord[i, 2]

    line1 = ax.plot(coord[:i,0], coord[:i,1], coord[:i,2]) # plot orbit
    line2 = ax1.plot(coord[:i,0], coord[:i,1], coord[:i,2]) # plot orbit

    ax.plot_surface(x1, y1, z1, color='#CCFFFF') # plot beta per Aa1
    ax.set_aspect('equal')
    ax1.plot_surface(x1, y1, z1, color='#CCFFFF') # plot beta per Aa1
    ax1.set_aspect('equal')

    ax.plot_surface(x2, y2, z2, color='tab:orange') # plot beta per Aa2
    ax.set_aspect('equal')
    ax1.plot_surface(x2, y2, z2, color='tab:orange') # plot beta per Aa2
    ax1.set_aspect('equal')

    ax.autoscale(False)
    ax.set_xlim3d( np.min(coord[:,0]), np.max(coord[:,0]) ) # x-axis limits defined by minimum and maximum x value of orbit
    ax.set_ylim3d( np.min(coord[:,1]), np.max(coord[:,1]) ) # y-^^^^
    ax.set_zlim3d( np.min(coord[:,2]), np.max(coord[:,2]) ) # z-^^^^
    ax.set_aspect('equal')
    plt.autoscale(True)
    ax._axis3don = False

    ax1.autoscale(False)
    ax1.set_xlim3d( np.min(coord[:,0]), np.max(coord[:,0]) ) # x-axis limits defined by minimum and maximum x value of orbit
    ax1.set_ylim3d( np.min(coord[:,1]), np.max(coord[:,1]) ) # y-^^^^
    ax1.set_zlim3d( np.min(coord[:,2]), np.max(coord[:,2]) ) # z-^^^^
    ax1.set_aspect('equal')
    # plt.autoscale(True)
    ax1._axis3don = False

    ax.view_init(elev = 40, azim = 10, roll = 0)
    ax1.view_init(elev = 80, azim = 0, roll = 100)

    return line1, line2


# ani = animation.FuncAnimation(fig, animate, duration, interval=100, blit=False, save_count=30, repeat=True)
# plt.show()

# plt.rcParams['animation.ffmpeg_path'] ='C:\\ffmpeg\\bin\\ffmpeg.exe'
# FFwriter=animation.FFMpegWriter(fps=60, extra_args=['-vcodec', 'libx264'])
# ani.save('C:/Users/mania/Desktop/ME_Fall_2023/Spring 2024/PHYS 454/algol.mp4', writer=FFwriter)