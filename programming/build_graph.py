#!/usr/bin/env python
# -*- coding: utf-8 -*-

from typing import Sequence


def insert_graph(x: list, g: dict) -> dict:
  if x[0] not in g.keys():
    g[x[0]] = {'in':[], 'out':[]}
  if x[1] not in g[x[0]]['out']:
    g[x[0]]['out'].append(x[1]) 
  
  if x[1] not in g.keys():
    g[x[1]] = {'in':[], 'out':[]}
  if x[0] not in g[x[1]]['in']:
    g[x[1]]['in'].append(x[0])
  return g

def print_degree_result(x:list, y:list) -> None:
  print("Min in-degree: {}".format(x[0]))
  print("Max in-degree: {}".format(x[-1]))
  print("Min out-degree: {}".format(y[0]))
  print("Max out-degree: {}".format(y[-1]))

if __name__ == "__main__":

  import sys

  walk_graph = {}
  # walk_graph = {'A': {'in': [], 'out': ['B', 'C']}, 'B': {'in': ['A'], 'out': ['C']}, 'C': {'in': ['B', 'A', 'D'], 'out': ['D']}, 'D': {'in': ['C', 'E'], 'out': ['C']}, 'E': {'in': [], 'out': ['D']}}
  
  for line in sys.stdin.readlines():
    insert_graph([w.upper() for w in line.strip("\n").split(" -> ")], walk_graph)

  with open('/home/roki/shared/techgigs/programming/graph.txt', 'r') as f:
      for line in f.readlines():
        insert_graph([w.upper() for w in line.strip("\n").split(" -> ")], walk_graph)

  import bisect
  
  in_degree = []
  out_degree = []

  for k, v in walk_graph.items():
    bisect.insort(in_degree, len(walk_graph[k]['in']))
    bisect.insort(out_degree, len(walk_graph[k]['out']))
  
  # seq_len = 3
  # path = []
  
  # for k, v in walk_graph.items():
  #   if seq_len == 0:
  #     print("sequence length should be more than zero")
  #   if len(path) == 0

  #   if len(path) < seq_len:
  #     path.append(k)
  #   for nxt in v['out']:
  #     path.append(nxt)
  #     if len(walk_graph[nxt]['out']):
  #       continue



  print(walk_graph)
  # print_degree_result(in_degree, out_degree)