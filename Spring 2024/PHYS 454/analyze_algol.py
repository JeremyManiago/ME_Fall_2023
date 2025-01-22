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


im1 = Image.open('C:/Users/mania/Desktop/ME_Fall_2023/Spring 2024/PHYS 454/plt1.png')   # open projection images of algol
im2 = Image.open('C:/Users/mania/Desktop/ME_Fall_2023/Spring 2024/PHYS 454/plt2.png')
im3 = Image.open('C:/Users/mania/Desktop/ME_Fall_2023/Spring 2024/PHYS 454/plt3.png')
im4 = Image.open('C:/Users/mania/Desktop/ME_Fall_2023/Spring 2024/PHYS 454/plt4.png')
print(im1.format, im1.size, im1.mode)   # print image format, size (width and height in px), and color mode
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

imdata1 = np.array(im1, dtype=int)*-1   # initializes image data as integer array and negates values so that white is the most negative value
imdata2 = np.array(im2, dtype=int)*-1
imdata3 = np.array(im3, dtype=int)*-1
imdata4 = np.array(im4, dtype=int) *-1

imdata = [imdata1, imdata2, imdata3, imdata4]

LineToExtractHoriz = np.arange(0, len(imdata[0][0]), 1) # all horizontal lines
LineToExtractVerti = np.arange(0, len(imdata[0][1]), 1) # all vertical lines

im1_red = []
print(im1_red)
print(len(LineToExtractHoriz))

for i in range(len(LineToExtractHoriz)):
    buffer = imdata1[LineToExtractHoriz[i], :][:, 0]
    im1_red.append(buffer)
print(len(im1_red))

im1_green = imdata[0][LineToExtractHoriz[0], :][:, 1]
im1_blue = imdata[0][LineToExtractHoriz[0], :][:, 2]
print(len(imdata1[0]))

# print(im1_red)

fig = plt.figure()
ax = fig.add_subplot(1, 1, 1)
for j in range(len(LineToExtractHoriz)):
    ax.plot(imdata1[0], im1_red[i], color='r', label='Red')
plt.show()

# def sum_row_col:
#     for imgs in range(len(imdata)):
