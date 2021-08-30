## travel path from give graph

1. get a graph from the plan-text like
>>'A -> B'</br>
>>'B -> D'</br>
>>'B -> E'</br>

2. build the graph from it

3. find the travel path from the graph with give size(total path), sequence lengh(path length)

## requirement.txt
numpy==1.19.5

## how to use
```bash
  python3 ./get_travel.py --filename graph2.txt --size 3 --seq_len 3

  ## filename : will find the file in current fodler
  ## size     : number of sequence which you want
  ## seq_len  : the length of sequence with you want
```

- this programe get travel paths from the graph randomly
- if path is less the size, get next random start node from the graph
