
using Plots
include("one_step_function.jl")

let 


#--------- paraniteres of the model 
epsilon_up_arow=0.51   
epsilon_down_arow=0.49
q=3
N=500     
#----------------------------------


c_0_span=0.1:0.1:0.9   # list of initail concetration of opinion 
mcs=10^4  # max number of step in trajektory 


plot1 = plot(dpi=800)

for c_0 in c_0_span

    N_up=Integer(c_0*N)
    println("c_0 = ",c_0)
    c_in_time=zeros(mcs+1)
    c_in_time[1]=c_0
    for t_i=1:mcs

        for i=1:N
            N_up=N_up+one_step(N,N_up,epsilon_up_arow,epsilon_down_arow,q)
        end
        c_in_time[t_i+1]=N_up/N

        if N_up==0 || N_up==N # if we hit absorbing state
            break 
        end
    end
    plot!(c_in_time,label="",c="black")

end
ylims!(0,1)
display(plot1)

end