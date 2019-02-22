#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from calc_mod import *
import argparse,time, numpy as np
import matplotlib.pyplot as plt

parser = argparse.ArgumentParser(prog='gravedad')
#parser.add_argument("-imname", action=Store_as_array, help="-imname: Nombre del archivo a procesar",type=int, nargs='+')
parser.add_argument("-imname", action='store', help="-imname: Nombre del archivo a procesar", dest="imname",type=str)
parser.add_argument("-hz",action='store', help="-hz: Frecuencia de la lampara", dest="hz", type=float)
parser.add_argument("-dx", action='store',help="-dx Tamaño de cada pixel de la imagen en mm", dest="dx",type=float)
args=parser.parse_args()
#args = parser.parse_args(['-dx','1','-hz','1','-imname','Bolas1.tif'])
#args=parser.parse_args(['-imname',image.all()])
#assert isinstance(args.imname, np.ndarray)
#args.imname=plt.imread(args.imname)
image,hz,dx=plt.imread(args.imname),args.hz,args.dx
print(ace(image, hz, dx))