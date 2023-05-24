import torch
import torch.nn as nn
import torch.nn.functional as F
import os
os.environ['KMP_DUPLICATE_LIB_OK'] = 'True'
import numpy as np
import graphviz

def draw_dianet(input_dim, output_dim, num_expd):
    nm_nds_lst = get_num_nodes(input_dim, output_dim, num_expd)
    # create nodes by nm_nds_lst
    layers = []
    for i, num in enumerate(nm_nds_lst):
        onelayer = []
        # fill onelayer
        for j in range(num):
            onelayer.append(str(i)+'_'+str(j))
        layers.append(onelayer)
    # create edges: 
    edges = []
    for i, layer in enumerate(layers):
        for j, layer in enumerate(layers):
            if i == j:
                continue
            if i+1 == j: # next layer
                if len(layers[i]) < len(layers[j]):
                    for ii, node in enumerate(layers[i]):
                        edges.append((layers[i][ii], layers[j][ii]))
                        edges.append((layers[i][ii], layers[j][ii+1]))
                if len(layers[i]) > len(layers[j]):
                    for jj, node in enumerate(layers[j]):
                        edges.append((layers[i][jj], layers[j][jj]))
                        edges.append((layers[i][jj+1], layers[j][jj]))
            if i+2 == j: # next next layer
                if len(layers[i]) < len(layers[j]):
                    for ii, node in enumerate(layers[i]):
                        edges.append((layers[i][ii], layers[j][ii+1]))
                if len(layers[i]) > len(layers[j]):
                    for jj, node in enumerate(layers[j]):
                        edges.append((layers[i][jj+1], layers[j][jj]))
                if len(layers[i]) == len(layers[j]):
                    for ii, node in enumerate(layers[i]):
                        edges.append((layers[i][ii], layers[j][ii]))
    # create graph
    g = graphviz.Digraph(format='png')
    for i, layer in enumerate(layers):
        for j, node in enumerate(layer):
            g.node(node)
    for edge in edges:
        g.edge(edge[0], edge[1])
    return g, layers, edges

def get_num_nodes(input_dim, output_dim, num_expd):
    num_nodes = [input_dim]
    for i in range(num_expd):
        num_nodes.append(input_dim+i+1)
    left = num_nodes[-1]-output_dim
    for i in range(left):
        num_nodes.append(num_nodes[-1]-1)
    return num_nodes


def make_mask(in_dim, out_dim):
    mask = np.zeros((out_dim, in_dim))
    # for each col
    for i in range(in_dim):
        mask[i:i+2, i] = 1
    return mask

def make_mask_T(in_dim, out_dim):
    mask = make_mask(in_dim, out_dim).T
    return mask