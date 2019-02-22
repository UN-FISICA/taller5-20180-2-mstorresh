#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from calc_mod import *
import argparse,time, numpy as np
from scipy.misc import imread
import matplotlib.pyplot as plt
#Me deja hacer parse con un array de nupy
class Store_as_array(argparse._StoreAction):
    def __call__(self, parser, namespace, values, option_string=None):
        values = np.array(values)
        return super().__call__(parser, namespace, values, option_string)
    
parser = argparse.ArgumentParser(prog='PROG')
#parser.add_argument("-imname", action=Store_as_array, help="-imname: Nombre del archivo a procesar",type=int, nargs='+')
parser.add_argument("-imname", action='store', help="-imname: Nombre del archivo a procesar",type=str)
parser.add_argument("-hz",action='store', help="-hz: Frecuencia de la lampara", dest='hz', type=float)
parser.add_argument("-dx", action='store', dest='dx',help="-dx Tamaño de cada pixel de la imagen en mm",type=float)
args=parser.parse_args()
#args = parser.parse_args(['-dx','1','-hz','1','-imname','Bolas1.tif'])
#args=parser.parse_args(['-imname',image.all()])
#assert isinstance(args.imname, np.ndarray)
args.imname=plt.imread(args.imname)

print(ace(image, hz, dx))