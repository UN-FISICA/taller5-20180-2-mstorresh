#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from distutils.core import setup
from Cython.Build import cythonize
import matplotlib.pyplot as plt

image=imread("Bolas2.tif")
imC2= 0.299*image[:,:,0] + 0.587*image[:,:,1] + 0.114*image[:,:,2]
plt.imshow(imC2)