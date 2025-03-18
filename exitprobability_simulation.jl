using Plots
using CSV

include("one_step_function.jl")
let 

#--------- paraniteres of the model 
# for exit probability we used the the assumption  
# epsilon_up_arow + epsilon_down_arow = 1  
# epsilon_down_arow will be called p
p_span=[0.9,0.6,0.54,0.52,0.51,0.50,0.49,0.48,0.46,0.4,0.10]
q_span=[2,3]
N=64


k_span=1:N-1 # is N_up and i will use it to inital condition 
k_span=collect(k_span)
repeat=10^3 # avreage over this 

plot1 = plot(dpi=800)
exit_p=zeros(length(k_span)) #vector of lenght k_span to collect all exit probability from inital condition

for q in q_span
    for p in p_span
        for k in k_span
            exit=0 #number of simulation which get to N_up=64 
            for rep_i in 1:repeat
                N_up=k
                
                while N_up!=N && N_up!=0 
                    for i=1:N
                        N_up=N_up+one_step(N_up,p,1-p,q,N)
                    end
                end

                if N_up==N
                    exit=exit+1
                end

            end
            exit_p[k]=exit/repeat
        end

    name="exit_sim_N$(N)_p$(p)_q$(q).csv"
    plot!(k_span,exit_p,label="p = $p",linewidth=3)
    end
end

ylims!(0,1)
xlims!(0,1)
display(plot1)

end