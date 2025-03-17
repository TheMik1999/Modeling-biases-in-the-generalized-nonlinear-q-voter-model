# Modeling biases in the generalized nonlinear q-voter model
 Codes used to generate results for publication "Modeling biases in binary decision-making within the generalized nonlinear q-voter model"

 ## Parameters 
 - N  - Number of agents
 - q  - size of grupe of influencse 
 - epsilon_up_arrow -
 - epsilon_down_arrow -

### Figure
A figure to remind you of the meaning of the parameters

![Schematic diagram of our model illustrating possible scenarios in which a target agent (inside the circle) may change its state. Examples are provided for $q=4$. Black (white) agents represent adopted (unadopted) agents, while gray agents indicate agents in an arbitrary state. In scenarios (a) and (b), the target agent’s state changes independently of its initial state because the $q$-panel is unanimous. Cases (c) and (d) represent situations where the $q$-panel is not unanimous, meaning that the probability of changing state depends on the target agent's initial state: (c) the target agent is adopted and switches to an unadopted state with probability $\varepsilon_\downarrow$; otherwise, it retains its original state; (d) the target agent is unadopted and adopts with probability $\varepsilon_\uparrow$; otherwise, it retains its original state.](model_scheme.pdf)

 ## Files
 ### one_step_function.jl
Main function that describes the MoneCarlo elemetary step($\Delta t= 1/N $) in the simulation.
 ### trajectory_simulation.jl
 Temporal trajectories from dymulation for given q,epsilon_up_arrow,epsilon_down_arrow values. The file has been modified for calculating multiple initial conditions  
