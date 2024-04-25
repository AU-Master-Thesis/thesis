== Future Work


=== Verify simulation results in a Real World setup

=== Use ray casting instead of sampling an SDF image of the environment

- Use different behavior when communication is very bad. Either change the factor graph by adding
new nodes with different policies or a new algorithm all together e.g. the game theory paper we read at
the start.

- Extend to 3D world. e.g. can it work with UAVS/drone. What would have to change?
 - The state space is more complex. As a result the matrices being sent around are larger, and more computationally costly
 - What factors would have to change or be updated?
 - Have other already done something similar

 - Have the factorgraph be able to change the number of variable nodes during the lifetime of the graph. I.e. having it dependant on the desired velocity. If we want to accelerate the robot and have it move faster, it might be better to have more variables/longer future horizon, while if we do not move very fast, fewer variables could be sufficient and less computationally taxing in that case.
