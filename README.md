
# Modeling Biases in the Generalized Nonlinear q-Voter Model

This repository contains the code used to generate results for the publication *"Modeling biases in binary decision-making within the generalized nonlinear q-voter model"*.

[Arxiv](https://arxiv.org/pdf/2502.10172)

## Requirements

The code is written in **Julia** and was tested on **Julia v1.9.2**. To run the simulations and analyses, ensure you have the following packages installed:

```julia
using LinearAlgebra
using Plots
using DifferentialEquations
using NLsolve
using CSV
using DataFrames
```

To install missing packages, use:

```julia
using Pkg
Pkg.add(["LinearAlgebra", "Plots", "DifferentialEquations", "NLsolve"])
```

**Note:** The `DataFrames`,`DelimitedFiles` and `CSV` packages are not required to run the code unless you wish to save data to CSV files. The relevant code for saving data is marked with `# save data to csv file` and is commented out by default.

## Parameters

- **N**  - Number of agents
- **q**  - Size of the group of influence
- **$\varepsilon_{\uparrow}$** (*epsilon_up_arrow*) - Probability of an unadopted agent switching to adopted a state (if not unanimity in q-panel)
- **$\varepsilon_{\downarrow}$** (*epsilon_down_arrow*) - Probability of an adopted agent switching to an unadopted state
(if not unanimity in q-panel)


## Model Description

The model is implemented on a complete graph, meaning that the network structure is not explicitly stored. Instead, only the number of adopted agents (**N_up**) is tracked.

### Figure

A schematic diagram of the model parameters:

![Figure](model_scheme.pdf)

**Caption:**
The diagram illustrates possible scenarios where a target agent (inside the circle) may change its state. Examples are provided for **q = 4**. Black (white) agents represent adopted (unadopted) agents, while gray agents indicate agents in an arbitrary state. 
- (a), (b): The target agent's state changes independently of its initial state if the **q-panel** is unanimous.
- (c): If the **q-panel** is not unanimous, an adopted agent switches to an unadopted state with probability **$\varepsilon_{\downarrow}$**.
- (d): If the **q-panel** is not unanimous, an unadopted agent adopts the state with probability **$\varepsilon_{\uparrow}$**.

---

## Files and Functions

### Simulation

#### `one_step_function.jl` [View code](one_step_function.jl)
Main function describing the Monte Carlo elementary step (**$\Delta t = 1/N $**) in the simulation.

#### `trajectory_simulation.jl` [View code](trajectory_simulation.jl)
Generates time trajectories for given **q**, **epsilon_up_arrow**, and **epsilon_down_arrow** values. Modified for multiple initial conditions.

#### `exitprobability_simulation.jl` [View code](exitprobability_simulation.jl)
Calculates exit probabilities from simulations.

### Analytical

#### `trajectory_analytical_plus_stab_point.jl` [View code](trajectory_analytical_plus_stab_point.jl)
Generates analytical time trajectories for given **q**, **epsilon_up_arrow**, and **epsilon_down_arrow** values, with stable and unstable points included.

#### `exitprobability_analytical.jl` [View code](exitprobability_analytical.jl)
Computes exit probability using a Markov chain representation, leveraging the homogeneity of the complete graph.

#### `phase_portrait.jl` [View code](phase_portrait.jl)
Prepares a phase portrait for a given **q**, identifying fixed points and checking their stability. Outputs phase portraits and fixed-point distributions for a grid of **epsilon_up_arrow** and **epsilon_down_arrow** values.

---

## How to Run the Code

1. Clone the repository:
   ```sh
   git clone https://github.com/TheMik1999/Modeling-biases-in-the-generalized-nonlinear-q-voter-model.git
   cd Modeling-biases-in-the-generalized-nonlinear-q-voter-model
   ```
2. Ensure you have **Julia v1.9.2** installed.
3. Install dependencies (if not installed already):
   ```julia
   using Pkg
   Pkg.add(["LinearAlgebra", "Plots", "DifferentialEquations", "NLsolve"])
   ```
4. Run simulations:
   ```julia
   include("trajectory_simulation.jl")
   ```
5. Run analytical calculations:
   ```julia
   include("trajectory_analytical_plus_stab_point.jl")
   ```

---

## License

This project is licensed under the MIT License.

## Author

- **TheMik1999** - [GitHub Profile](https://github.com/TheMik1999)


For questions or contributions, feel free to open an issue or submit a pull request!
```

