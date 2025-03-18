using DifferentialEquations
using Plots
using NLsolve
using DataFrames
using CSV

let 
    function my_ode(dc, c, p_q, t)
        q,ε_⭡,ε_⭣ = p_q
        c=c[1]
        dc[1] = (ε_⭡+ε_⭣)*(ε_⭡/(ε_⭡+ε_⭣)-c)*(1-c^q-(1-c)^q)-(1-c)^q * c + c^q *(1-c)
    end

    function jacobian(c,q,ε_⭡,ε_⭣)
        part_1=c^(q - 1) *(q - c *(q + 1))
        part_2=(1 - c)^(q - 1)* (c* q + c - 1)
        part_3=(ε_⭡ + ε_⭣)* (ε_⭡/(ε_⭡ + ε_⭣) - c)* (q *(1 - c)^(q - 1) - q* c^(q - 1)) - (ε_⭡ + ε_⭣)* (-c^q - (1 - c)^q + 1)
        return part_1+part_2+part_3
    end

    
    function myfunc(c, q,ε_⭡,ε_⭣)
        return [(ε_⭡-(ε_⭡+ε_⭣)*c)*(1-c^q-(1-c)^q)-(1-c)^q * c + c^q *(1-c)]
    end

    function fix_points(q,ε_⭡,ε_⭣)
        Rounded_solution = []
        c_span=0:0.01:1
        for c_start = c_span
            c=[c_start]
            acuracy=1e-10
            number_of_iterations=10^5
    
            root = nlsolve(c -> myfunc(c[1], q,ε_⭡,ε_⭣), c, ftol=acuracy, xtol=acuracy, iterations=number_of_iterations)
            helpc = 1e-5
            rounded_root = round.(root.zero, digits=3)
            rrx = rounded_root[1]
            if root.f_converged
                if rounded_root in Rounded_solution
                    continue
                elseif rrx < 0 || rrx > 1 
                    continue
                else
                    # if point rrx and rry is close to the point (pp/3, pp/3) then skip it
                    push!(Rounded_solution, rounded_root)
                end
            end
        end
        stab=[]
        un_stab=[]
        for sol_c in Rounded_solution
            helpc = 1e-8
            jac = jacobian(sol_c[1], q,ε_⭡,ε_⭣)
            jac_plus = jacobian(sol_c[1]+helpc, q,ε_⭡,ε_⭣)
            jac_minus = jacobian(sol_c[1]-helpc, q,ε_⭡,ε_⭣)

            magnetisation=sol_c[1]
            if jac < 0 && jac_plus < 0 && jac_minus < 0
                push!(stab,sol_c[1])
            else
                push!(un_stab,sol_c[1])
            end
        end

        return (stab,un_stab)
    end

    
    #--------- model parameters 
    q =5
    ε_⭡=0.25
    ε_⭣=0.19


    # set initial conditions 
    c_0_span=0.0:0.05:1
    c_0_span=collect(c_0_span)
    c_0_span[1]=0.01   # do not start from the absorbing state 
    c_0_span[end]=0.99 # do not start from the absorbing state


    # set time 
    tspan = (0.0, 100.0)
    dt = 0.1
    tsteps = 0:dt:tspan[2]

    dpi_me=1600

    plot1=plot(dpi=dpi_me)
    

        traj_span=zeros(length(tsteps),length(c_0_span))
        c_iter=1
        for c_0_i in c_0_span
            
            c_0=[c_0_i]
            p_q = [ q,ε_⭡,ε_⭣] 
            prob = ODEProblem(my_ode, c_0, tspan, p_q)
            sol = solve(prob, Tsit5(), saveat=tsteps, abstol=1e-8, reltol=1e-8, maxiters = 1000)
            traj_single = sol[1, :]  # Perform element-wise subtraction with broadcasting

            plot!(sol.t, traj_single,linewidth=2,label="",color=:gray)
            if c_0_i==0.9
                println("c_end = ",traj_single[end])
            end
            traj_span[:,c_iter]=traj_single
            c_iter+=1

        end

        df = DataFrame(traj_span, :auto)
        # CSV.write("traj_q_$q"*"_ep1_$ε_⭡"*"_em1_$ε_⭣.csv", df)


        
        title!("epsilon_1 = $ε_⭡, epsilon_-1 = $ε_⭣, q = $q")
        plot!( legend=false)
        xlims!(0,maximum(tsteps))
        ylims!(0,1)

        stab , un_stab=fix_points(q,ε_⭡,ε_⭣)
        stab_un_stab=zeros(5,2) .-1
        println("fix_num=$(length(stab)+length(un_stab))")
        iter=1
        for i in stab
            scatter!([0],[i[1]],label="",color=:green,markersize=5)
            plot!([0,maximum(tsteps)],[i[1],i[1]],label="",color=:green,linewidth=2,linestyle=:dash)
            stab_un_stab[iter,1]=i[1]
            iter+=1
        end
        iter=1
        for i in un_stab
            scatter!([0],[i[1]],label="",color=:red,markersize=5)
            plot!([0,maximum(tsteps)],[i[1],i[1]],label="",color=:red,linewidth=2,linestyle=:dash)
            stab_un_stab[iter,2]=i[1]
            iter+=1
        end

        df = DataFrame(stab_un_stab, :auto)
        # CSV.write("stab_q_$q"*"_ep1_$ε_⭡"*"_em1_$ε_⭣.csv", df)
        

        display(plot1)


end