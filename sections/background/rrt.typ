#import "../../lib.typ": *
== Rapidly Exploring Random Trees <s.b.rrt>

Rapidly Exploring Random Trees (RRT) is a sampling-based motion planning algorithm, introduced by Steven M. LaValle in 1998@original-rrt. The algorithm incrementally builds a tree of nodes, each node a specific step length, $s$, from the last. The tree is built by randomly sampling a point in the configuration space, and then extending the tree towards that point with $s$. See the entire algorithm in @alg-rrt.@original-rrt@sampling-based-survey


What about `inline` code? Also shown in @lst.python-rrt.
#listing(caption: [This is the caption.])[
```python
def rrt(start, goal, s, N, g_tolerance):
    V = {start}
    E = set()
    for i in range(N):
        x_random = SampleRandomPoint()
        x_nearest = NearestNeighbor(G=(V, E), x_random)
        x_new = Steer(s, x_nearest, x_random)
        if CollisionFree(x_nearest, x_new):
            V = V.union({x_new})
            E = E.union({(x_nearest, x_new)})
        else:
            continue
        if WithinGoalTolerance(g_tolerance, x_new, goal) and CollisionFree(x_new, goal):
            V = V.union({goal})
            E = E.union({(x_new, goal)})
            break
    return G = (V, E)
```
]<lst.python-rrt>

#example[
  #set par(first-line-indent: 0em)
  *Scenario:* Let's look at an example, where the possible state space is _two-dimensional euclidean space_. A Robot wants to go from 2D position $x_A$ to $x_B$ \ \

  *Input:* In @alg-rrt, the input is outlined to be a starting position, $x_"start"$, a goal position $x_"goal"$, a step length $s$, a maximum number of iterations, $N$, and lastly, a goal tolerance, $g_"tolerance"$. \ \

  *Output:* At the end of algorithm execution, the resulting graph is outputted as the combination of; $V$, the set of vertices, and $E$, the set of edges. \ \

  *Execution:*
  + $V$ is initialised to contain the initial position of the robot $x_"start" = x_A$, thus the set ${x_A}$. $E$ is initialised to be empty.
  + Enter a for loop, that will maximally run $N$ times, but will break early if the goal is reached.

    *Each iteration:*
    + A random point, $x_"random"$, is sampled from the configuration space, by calling the sampling function $"SampleRandomPoint"()$.
    + The nearest existing node in the tree, $x_"nearest"$, is found by $"NearestNeighbor"(G = (V, E), x_"random")$.
    + Thereafter, a new node, $x_"new"$, is created by making a new node $s$ distance from $x_"nearest"$ towards $x_"random"$ in the call to $"Steer"(s, x_"nearest", x_"random")$.

    *Checks:*
    + Only if the path from $x_"nearest"$ to $x_"new"$ is collision-free, the new node is added to the tree. Otherwise, continue to the next iteration.
    + If the node is added to the tree, and it is within $g_"tolerance"$ distance from $x_"goal"$, and the path from $x_"new"$ to $x_"goal"$ is collision-free, the goal is added to the tree, and the loop is broken.
]

#jens[make functions monotext also in the algorithm?]

#let la = sym.arrow.l
#algorithm(
  [
    #let ind() = h(2em)
    *Input:* ${x_"start", x_"goal", s, N, g_"tolerance"}$ \ \

    $V #la x_"start"$ \
    $E #la emptyset$ \ \

    *for* $i = 1, \ldots, N$ *do* \
    #ind()$x_"random" #la "SampleRandomPoint"()$ \
    #ind()$x_"nearest" #la "NearestNeighbor"(G = (V, E), x_"random")$ \
    #ind()$x_"new" #la "Steer"(s, x_"nearest", x_"random")$ \ \

    #ind()*if* $"CollisionFree"(x_"nearest", x_"new")$ *then* \
    #ind()#ind()$V #la V union x_"new"$ \
    #ind()#ind()$E #la E union {(x_"nearest", x_"new")}$ \
    #ind()*else* \
    #ind()#ind()*continue* \
    #ind()*end* \ \

    #ind()*if* $"WithinGoalTolerance"(g_"tolerance", x_"new", x_"goal")$ \
    #ind()#h(1em)*and* $"CollisionFree"(x_"new", x_"goal")$ *then* \
    #ind()#ind()$V #la V union x_"goal"$ \
    #ind()#ind()$E #la E union {(x_"new", x_"goal")}$ \
    #ind()#ind()*break* \
    #ind()*end* \
    *end* \ \

    *return* $G = (V, E)$
  ],
  caption: [The RRT algorithm.]
)<alg-rrt>

#jens[also do this]

=== RRT Star <s.b.rrt-star>

#todo[ONLY do this if we end up using RRT\*]
