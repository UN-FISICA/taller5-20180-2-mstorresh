#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import numpy as np
import scipy.ndimage as nd
import matplotlib.pyplot as plt
from scipy.misc import imread
from numpy.linalg import inv,lstsq
#d

def ace(image, hz, dx):
    imC2= 0.299*image[:,:,0] + 0.587*image[:,:,1] + 0.114*image[:,:,2]
    #Binarización de la blanco y negro
    CB=np.where(imC2<35,0,255)
    imfil1=nd.median_filter(CB,(10,10)) #Filtro paso mediano
    kernel=1/25*np.ones((5,5),dtype=int)
    suave=nd.convolve(imfil1,kernel)
    lblim,n=nd.label(CB)
    ##Debo suavizarla para que em detecto solo las bolas sin los machones
    #kernel=np.array([[1,1,1],[0,0,0],[-1,-1,-1]])   
    #bordes=nd.convolve(imC2,kernel)
    lbl,n = nd.label(suave)
    X,Y=[],[]
    for j in range(1,n+1):
        Y.append(nd.measurements.center_of_mass(suave, lbl, [j])[0][0])
        #X.append(nd.measurements.center_of_mass(suave, lbl, [j])[0][1])
    Y.sort()
    Y.pop(0)
    #print(Y)
    Y=np.array(Y)
    dt=np.ones(len(Y))
    for i in range(0,len(dt)):
        dt[i]=(i)/hz
    f=[]
    f.append(lambda x:np.ones_like(dt))
    f.append(lambda x:dt)
    f.append(lambda x:(1/2)*(dt**2))
    Xt=[]
    for fun in f:
        Xt.append(fun(dt))   
    Xt= np.array(Xt)*dx
    X=Xt.transpose()
    #L=[0,image,imfil1,lbl]
    print("la aceleración es:")
    print(lstsq(X,Y)[0][2])
    
#image1=imread("Bolas1.tif") 
#print(ace(image1,5.3,0.2))   
    
"""
#imshow(suave)
#IMprime todas las fotos en una figura

fig=plt.figure(figsize=(8, 8))
columns = len(L)-1
rows = 1
for i in range(1, columns*rows +1):
    img = L[i]
    fig.add_subplot(rows, columns, i)
    plt.imshow(img,origin='upper')
plt.show()
H=lstsq(X,Y,rcond=-1)[0]
y0,v0,a= H[0],H[1],H[2] 
plt.plot(dt, Y, 'o', label='Original data', markersize=10)
plt.plot(dt, y0+v0*dt+a/2*dt**2, 'r', label='Fitted line')
plt.legend()
plt.show()
"""