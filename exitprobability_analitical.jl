using LinearAlgebra
using Plots
using DelimitedFiles

function gamma_plus(k, N, q, ε_⭡)

    N_down=N-k
    N_up=k
    gamma_u = (N_down / N) * prod((N_up - i) / (N - 1 - i) for i in 0:q-1)
    gamma_nu = ε_⭡ * (N_down / N) * (
        1 - prod((N_up - i) / (N - 1 - i) for i in 0:q-1)
          - prod((N_down - 1 - i) / (N - 1 - i) for i in 0:q-1)
    )
    return min(gamma_u + gamma_nu, 1.0)
end

function gamma_minus(k, N, q, ε_⭣)

    N_down=N-k
    N_up=k
    gamma_u = (N_up / N) * prod((N_down - i) / (N - 1 - i) for i in 0:q-1)
    gamma_nu = ε_⭣ * (N_up / N) * (
        1 - prod((N_down - i) / (N - 1 - i) for i in 0:q-1)
          - prod((N_up - 1 - i) / (N - 1 - i) for i in 0:q-1)
    )
    return min(gamma_u + gamma_nu, 1.0)
end

function create_transition_matrix(N, q, ε_⭡, ε_⭣)
    P = zeros(N+1, N+1)

    for k in 2:N
        P[k, k+1] = gamma_plus(k-1, N, q, ε_⭡)  # transition k -> k+1
        P[k, k-1] = gamma_minus(k-1, N, q, ε_⭣) # transition k -> k-1
        P[k, k] = 1 - P[k, k+1] - P[k, k-1]     # stay in state k 
    end
    to_0=gamma_minus(1, N, q, ε_⭣)
    to_N= gamma_plus(N-1, N, q, ε_⭡)
    # Absorption states: N_up = 0 i N_up = N
    P[1, 1] = 1.0     #  N_up = 0
    P[N+1, N+1] = 1.0 #  N_up = N

    return P,to_0,to_N
end


function exit_probability_to_N_from_k(N, q, ε_⭡, ε_⭣)
    P,to_0,to_N = create_transition_matrix(N, q, ε_⭡, ε_⭣)
    Q = P[2:N, 2:N] 
    F = inv(I - Q)
    R=zeros(N-1,2)
    R=zeros(N-1)
    R[end]=to_N
    exit_prob = F * R 
    return  exit_prob
end


let 

N = 64 
q = 2

k_span= 1: 1 : N-1 
k_span= collect(k_span)
exit_all=k_span .* 0.0 

ε_⭡_span=[0.9,0.6,0.54,0.52,0.51,0.50,0.49,0.48,0.46,0.4,0.10]

plot1 = plot()
for ε_⭡ in ε_⭡_span
    ε_⭣ = 1 - ε_⭡ 
    exit_all=exit_probability_to_N_from_k(N, q, ε_⭡, ε_⭣)
    plot1 = plot!(k_span./N,exit_all,label="$(ε_⭡)")
    # name="exit_N$(N)_p$(ε_⭡)_q$(q).csv"
    # writedlm(name, hcat(k_span ./N, exit_all), ',')
end 

display(plot1)

end 