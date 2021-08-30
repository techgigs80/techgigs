#!/usr/bin/env python
# -*- coding: utf-8 -*-

def build_graph(x: list, g: dict) -> dict:
    if x[0] not in g.keys():
        g[x[0]] = {'in':[], 'out':[]}
    if x[1] not in g[x[0]]['out']:
        g[x[0]]['out'].append(x[1]) 
    
    if x[1] not in g.keys():
        g[x[1]] = {'in':[], 'out':[]}
    if x[0] not in g[x[1]]['in']:
        g[x[1]]['in'].append(x[0])
    return g

def travel_graph(graph, node, seq_len=3, path =[]):
  path = path + [node]
  if len(path) == seq_len:
    return [path]
  path_list = []
  for neighbour in graph[node]['out']:
    if neighbour not in path:
      new_travels = travel_graph(graph, neighbour, seq_len, path)
      for new_travel in new_travels:
        path_list.append(new_travel)
    else:
      continue


  return path_list

if __name__ == "__main__":
    import os
    import argparse
    from pathlib import Path
    
    parser = argparse.ArgumentParser(description='find number of the given sequence from a Graph')

    parser.add_argument('--filename', required=True, help='filename with absolute path')
    parser.add_argument('--batch', required=False, metavar='N', type=int, default=50000, help='batch size')
    parser.add_argument('--size', required=True, metavar='N', type=int, help='size of sequences')
    parser.add_argument('--seq_len', required=True, metavar='N', type=int, help='length of sequences')

    args = parser.parse_args()

    import sys
    sys.setrecursionlimit(100)

    walk_graph = {}

    with open(Path(os.getcwd())/args.filename, 'r') as f:
        for line in f.readlines():
            build_graph([w.upper() for w in line.strip("\n").split(" -> ")], walk_graph)
   
    from numpy.random import permutation

    result = []
    for i in permutation(list(walk_graph.keys())):
        result.extend(travel_graph(walk_graph, i, args.seq_len))
    
    print(result[:min(len(result), args.size)])
