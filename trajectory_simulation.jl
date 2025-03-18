using Plots
include("one_step_function.jl")

let 


#--------- paraniteres of the model 
ε_⭡=0.25  
ε_⭣=0.19
q=5
N=10000     
#----------------------------------


c_0_span=0.0:0.05:1.0   # list of initail concetration of opinion 
c_0_span=collect(c_0_span)
c_0_span[1]=0.01   # do not start from the absorbing state 
c_0_span[end]=0.99 # do not start from the absorbing state

mcs= 500  # max number of step in trajektory 


plot1 = plot(dpi=800)

for c_0 in c_0_span

    N_up=floor(Int, c_0 * N)
    println("c_0 = ",c_0)
    c_in_time=zeros(mcs+1)
    c_in_time[1]=c_0
    for t_i=1:mcs

        for i=1:N
            N_up=N_up+one_step(N,N_up,ε_⭡,ε_⭣,q)
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