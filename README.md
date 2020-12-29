# Sailor path finding using genetic algorithms and reinforcement learning

Given a sea map, the problem is to find the optimal path to the finishing point.
- every field on the map, except the goal fields has specified a gust of wind, which (with certain probability) moves you with its direction.
- there are specified penalty and finishing fields, after standing on it you get -1 (pale red), -5 (red) and +10 (green) points.
- the starting point is picked randomly from the first column fields.
- you have four actions to choose 1 - move right, 2 - move up, 3 - move left, 4 - move down.
- the goal is to maximize the sum of prizes by finding the finishing points and avoiding  penalty fields.

## The map of the sea:
![map-of-the-sea](https://raw.githubusercontent.com/WaznyKamo/Sailor-path-finding-using-genetic-algorithms/main/srednia_str_opt_gamma1.png)

**Visualisation of the learned algorithm can be seen here:*** https://www.youtube.com/watch?v=cTWiIK5lbwo


The project was made for university classes.

