#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from cython.view cimport array as cvarray
from cpython cimport array
import array
import numpy as np
import matplotlib.pyplot as plt
image=plt.imread('b1.jpeg')
#image=plt.imread('b1.jpeg')
#plt.imshow(gray)
def prom(x): #promedio de los valores dentro de la matriz
    a = 0
    for i in range(x.shape[0]):
        for j in range(x.shape[1]): 
            a+=x[i][j]
    return a/(x.shape[0]*x.shape[1])    
def bina(x):
    if prom(x)<255/2:  #fondo negro
        for i in range(x.shape[0]):
            for j in range(x.shape[1]):
                if x[i][j]>35: x[i][j]=255
                else: x[i][j]=0
    else:               #fondo blanco
        for i in range(x.shape[0]):
            for j in range(x.shape[1]):
                if x[i][j]<200: x[i][j]=255
                else: x[i][j]=0    
    cdef double[:,:]x_view = x
    return(x_view)
    
def arr(n,i):#crea un memory view de tamaño n, con todos los valores iguales a i 
    c=array.array('d',[i])    
    for k in range (n-1):
        c.extend([i])
    cdef double[:] c_view=c
    return(c_view)

"""
def fmedia(x):
    med = np.zeros((3,3))
    cdef double [:,:] med_view = med
    for i in range(2, x.shape[0]-2):
        for j in range(2,x.shape[1]-2):
            med_view[i-1][j-1]=x[i-1][j-1]
            med_view[i-1][j]=x[i-1][j]
            med_view[i-1][j+1]=x[i-1][j+1]
            med_view[i][j-1]=x[i][j-1]
            med_view[i][j+1]=x[i][j+1]
            med_view[i+1][j-1]=x[i+1][j-1]
            med_view[i+1][j]=x[i+1][j]
            med_view[i+1][j+1]=x[i+1][j+1]
            x[i][j]=(med_view[i-1][j-1]+med_view[i-1][j]+med_view[i-1][j+1]+med_view[i][j-1]+med_view[i][j+1]+med_view[i+1][j-1]+med_view[i+1][j]+med_view[i+1][j+1])/8
    cdef double[:,:] x_view=x
    return(x_view)
"""

def lbl(x):
    cdef double b=1
    f_view=arr(x.shape[0],0) #vector de 0, paraluego cambiarlo ya que sin este no suma y no cambia lo labels
    for i in range(x.shape[0]):
        for j in range(x.shape[1]):
            if x[i][j]>0:
                x[i][j]=b
                f_view[i]+=1
        if  f_view[i]==0 and f_view[i-1]!=0:              
            b+=1
    cdef double[:,:] x_view=x
    return(x_view,b)


def cm(x,l,dx1):
   #a=arr(int(l)-2,0)
   c0arr = cvarray(shape=(int(l)-2,1), itemsize=sizeof(double), format="d")
   cdef double [:, :] c0arr_view = c0arr    
   cdef float cn #numero de cuadritos en la linea
   cdef float cm #sub centros de masa 
   cdef float n   #numero total decuadritos
   for k in range(2,int(l)):
       n=0
       cm=0        
       for i in range(x.shape[0]):
           cn=0                          
           for j in range(x.shape[1]):
               if x[i][j]==k:
                   cn+=1
                   n+=1
           cm+=cn*i
       c0arr_view[k-2]=cm/n *dx1
                   
   return(c0arr_view)
"""
def dt(z):    
    Dt1 = arr(int(lbl(K)[1])-2,0)   
    for i in range(0,int(Dt1.shape[0])):
        Dt1[i]=i/z
    cdef double[:] Dt1_view=Dt1
    return(Dt1_view)
#print(type(lbl(y)[1])) 
"""
def Xt(x,d):
    Dt=d
    for i in range(x.shape[0]):
        for j in range (x.shape[1]):
            if i==0:
                x[i][j]=1
            if i==1:
                x[i][j]=Dt[j]
            if i==2:
                x[i][j]=(Dt[j]**2)/2
    cdef double[:,:] x_view=x
    return(x_view)

def Xn(x,d):
    Dt=d
    for i in range(x.shape[0]):
        for j in range(x.shape[1]):
            if j==0:
                x[i][j]=1
            if j==1:
                x[i][j]=Dt[i]
            if j==2:
                x[i][j]=(Dt[i]**2)/2
    cdef double[:,:] x_view=x
    return(x_view)   

def mult(x,y):
    c3arr = cvarray(shape=(int(x.shape[0]),int(y.shape[1])), itemsize=sizeof(double), format="d")
    cdef double [:, :] c3arr_view = c3arr
    for i in range(x.shape[0]):
        for j in range(y.shape[1]):
            c3arr_view[i][j]=0
            for k in range(y.shape[0]):
                c3arr_view[i][j] += x[i][k] * y[k][j]   
    return(c3arr_view)    
    
def inver(x):
    c4arr = cvarray(shape=(3,3), itemsize=sizeof(double), format="d")
    cdef double [:, :] c4arr_view = c4arr
    detA = x[0][0]*x[1][1]*x[2][2]+x[0][1]*x[1][2]*x[2][0]+x[0][2]*x[1][0]*x[2][1]-x[0][2]*x[1][1]*x[2][0]-x[0][1]*x[1][0]*x[2][2]-x[0][0]*x[1][2]*x[2][1]
    c4arr_view[0][0] = (x[1][1]*x[2][2] - x[1][2]*x[2][1])/detA
    c4arr_view[0][1] = (x[0][2]*x[2][1] - x[0][1]*x[2][2])/detA
    c4arr_view[0][2] = (x[0][1]*x[1][2] - x[0][2]*x[1][1])/detA
    c4arr_view[1][0] = (x[1][2]*x[2][0] - x[1][0]*x[2][2])/detA
    c4arr_view[1][1] = (x[0][0]*x[2][2] - x[0][2]*x[2][0])/detA
    c4arr_view[1][2] = (x[0][2]*x[1][0] - x[0][0]*x[1][2])/detA
    c4arr_view[2][0] = (x[1][0]*x[2][1] - x[1][1]*x[2][0])/detA
    c4arr_view[2][1] = (x[0][1]*x[2][0] - x[0][0]*x[2][1])/detA
    c4arr_view[2][2] = (x[0][0]*x[1][1] - x[0][1]*x[1][0])/detA
    return (c4arr_view)

def calc(image,hz,dx):
    gray=0.299*image[:,:,0]+0.587*image[:,:,1]+0.114*image[:,:,2]
    narr = gray
    cdef double [:, :] narr_view = narr
    K=bina(narr_view)
    cyarr = cvarray(shape=(3,int(lbl(K)[1]-2)), itemsize=sizeof(double), format="d")
    cdef double [:, :] cyarr_view = cyarr
    c2arr = cvarray(shape=(int(lbl(K)[1]-2),3), itemsize=sizeof(double), format="d")
    cdef double [:, :] c2arr_view = c2arr
    Dt = arr(int(lbl(K)[1])-2,0)   
    for i in range(0,int(Dt.shape[0])):
        Dt[i]=i/hz
    g=mult(Xt(cyarr_view,Dt),Xn(c2arr_view,Dt))
    p=inver(g)
    u=mult(p,Xt(cyarr_view,Dt))
    w=cm(lbl(K)[0],lbl(K)[1],dx)
    r=mult(u,w)
    print(r[2][0])



    