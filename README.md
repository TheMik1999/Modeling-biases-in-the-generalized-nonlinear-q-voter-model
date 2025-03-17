# Modeling biases in the generalized nonlinear q-voter model
 Codes used to generate results for publication "Modeling biases in binary decision-making within the generalized nonlinear q-voter model"
 [Arxiv](https://arxiv.org/pdf/2502.10172)
 ## Parameters 
 - **N**  - Number of agents
 - **q**  - size of grupe of influencse 
 - **epsilon_up_arrow** -
 - **epsilon_down_arrow** -

In the code, **epsilon_up_arrow** and **epsilon_down_arrow** can be labeled **e1** and **e2**, respectively
### Figure
A figure to remind you of the meaning of the parameters

![Figure](model_scheme.pdf)

**Caption:** 
Schematic diagram of our model illustrating possible scenarios in which a target agent (inside the circle) may change its state. Examples are provided for $q=4$. Black (white) agents represent adopted (unadopted) agents, while gray agents indicate agents in an arbitrary state. In scenarios (a) and (b), the target agent’s state changes independently of its initial state because the $q$-panel is unanimous. Cases (c) and (d) represent situations where the $q$-panel is not unanimous, meaning that the probability of changing state depends on the target agent's initial state: (c) the target agent is adopted and switches to an unadopted state with probability $\varepsilon_\downarrow$; otherwise, it retains its original state; (d) the target agent is unadopted and adopts with probability $\varepsilon_\uparrow$; otherwise, it retains its original state.
 ## Files
 ### Simulation
 The model was implemented on a complete graph, so in the case of simulation, it allowed us to forget the network structure and remember only the number of agents adapted (**N_up**) 
 #### one_step_function.jl [View file](one_step_function.jl)
 
Main function that describes the MoneCarlo elemetary step($\Delta t= 1/N $) in the simulation.
 #### trajectory_simulation.jl [View file](trajectory_simulation.jl)
 
 Time trajectories from symulation for given **q**,**epsilon_up_arrow**,**epsilon_down_arrow values**. The file has been modified for calculating multiple initial conditions  
 #### exitprobability_simulation.jl [View file](exitprobability_simulation.jl)
 Code used to calculate exit probability from simulation.

 ### Analytical
 #### trajectory_analitical_plus_stab_point.jl [View file](trajectory_analitical_plus_stab_point.jl )
Time trajectories from analytics for given **q**,**epsilon_up_arrow**,**epsilon_down_arrow values**.
In these cases were added stable and unstable points that occur in the system for the given parameters.

 #### phase_portrait.jl [View file](phase_portrait.jl)
 Preparation of a phase portrait for a given q.
In the code, we look for fixed points and check their stability. The code generates temporary phase numbers as well as the number of fixed points for a grid of **epsilon_up_arrow** and **epsilon_down_arrow values** values.


