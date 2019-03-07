#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import argparse
from calc_mod import *
import argparse,time, numpy as np
import matplotlib.pyplot as plt

parser = argparse.ArgumentParser(prog='gravedad')
parser.add_argument("-imname", action='store', help="-imname: Nombre del archivo a procesar", dest="imname",type=str)
parser.add_argument("-hz",action='store', help="-hz: Frecuencia de la lampara", dest="hz", type=float)
parser.add_argument("-dx", action='store',help="-dx Tamaño de cada pixel de la imagen en mm", dest="dx",type=float)
args=parser.parse_args()
image,hz,dx=plt.imread(args.imname),args.hz,args.dx


if __name__ =="__main__":
    
    print(calc(image,hz,dx))
