#import "../../lib/mod.typ": *
== #study.H-2.full.n <s.d.study-2>

#k[check this aaligns with your vision]

This part discusses, and evaluates the results of the contribution, which pertains to the second hypothesis, #study.H-2.box. This hypothesis specifically concerns the testing of an enhancement to the original `gbpplanner`, which have both been implemented in the #acr("MAGICS") tool. Namely, the effect of varying the number of both internal and external iterations in the #acr("GBP") inference process. Further, also providing a comparison of five different iteration schedules. The deliberations take place in the following sections; #numref(<s.d.iteration-amount>), #numref(<s.d.iteration-schedules>).


=== Iteration Amount <s.d.iteration-amount>

The analysis of the results from the @s.r.iteration-amount-plots highlights the significance of the number of internal iterations $M_I$ and external message passing steps $M_R$ per simulated timestep on performance. It is evident that performing 8 to 10 iterations of each yields satisfactory results, with improvements beyond this range being marginal. This is due to the iterative nature of optimization on a factor graph, where each pass within a timestep yields diminishing returns in terms of certainty, as the amount of new information introduced is limited and much of it has already been incorporated in earlier steps. Consequently, the choice of $M_I = 50$ and $M_R = 10$ in the scenarios used by the GBPplanner@gbpplanner paper appears to be unnecessary and redundant. This excessive iteration count does not translate to substantial performance gains. Moreover, in highly connected cases, such as when robots converge at the center of a circle, the exponential increase in information from neighbors becomes detrimental if $M_I <= 3$. It overwhelms the dynamic factors of the robots leading to highly sporadic planned movement, that are infeasible for robots with holonomic constraints. An approach with $M_I > M_R$ and both $M_I$ and $M_R$ being at least 10 iterations is generally optimal for achieving good performance without unnecessary computational overhead.



// - Looking at the results in @s.r.iteration-amount-plots the choice of how many internal iterations $M_I$ and external $M_R$ message passing steps are performed per simulated timestep does have an effect on the performance.
//
// - demonstrates that 8 to 10 iterations of each is enough to get good results, and that anything above quickly results in very slight improvements.
//
// - As such the choice of $M_I = 50, and M_R = 10$ in all of the scenarios used by the gpbplanner@gbpplanner paper is unnecessary/redundant.
//
// - Exponentially more information from neighbours in highly connected cases such as when the robots all meet in the center of the circle, is detrimental, and overrules the dynamics factors,
//   of the robots.
//
// - Not as clear of a direct correlation for the _Finished at Difference_ metric. This might be due to randomness present in the scenario with robots not having the same radius. The distribution of how robots are placed around the circle could affect this as the radius affect at which point the interrobot factors start to affect the joint factorgraph between two neighbours.
//
// - In general a good choice is for $M_I > M_R$ and both $M_I >= 10 and M_R >= 10$.


=== Iteration Schedules <s.d.iteration-schedules>
#k[hello]


- Choice of schedule appears to be of little to no importance.
- This broadly supports to given hypothesis about the outcome of the enhancement.
- Half end, Half beginning showcases a slight edge over the others. Why that is, is...
- Given the apparent variance in the measurements, it is diffecult to conclude that there are any difference.
- Either there is no noticeable difference, or the simulated environment is not able to test it. More insight would be able to be retrieved by a more sophisticated modelling of timed networking, with random noise to more broadly simulate real world stochastic processes.


Looking at the results in
