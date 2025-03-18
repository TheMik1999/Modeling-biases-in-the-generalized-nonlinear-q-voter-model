using DifferentialEquations 
using NLsolve
using Plots

# save data to csv file
# using CSV
# using DataFrames

function jacobian(c,q,ε_⭡,ε_⭣)
    part_1=c^(q - 1) *(q - c *(q + 1))
    part_2=(1 - c)^(q - 1)* (c* q + c - 1)
    part_3=(ε_⭡ + ε_⭣)* (ε_⭡/(ε_⭡ + ε_⭣) - c)* (q *(1 - c)^(q - 1) - q* c^(q - 1)) - (ε_⭡ + ε_⭣)* (-c^q - (1 - c)^q + 1)
    return part_1+part_2+part_3
end

function myfunc(c, q,ε_⭡,ε_⭣)
    return [(ε_⭡-(ε_⭡+ε_⭣)*c)*(1-c^q-(1-c)^q)-(1-c)^q * c + c^q *(1-c)]
end

function myfunc(c, q,ε_⭡,ε_⭣)
    return [(ε_⭡+ε_⭣)*(ε_⭡/(ε_⭡+ε_⭣)-c)*(1-c^q-(1-c)^q)-(1-c)^q * c + c^q *(1-c)]
end

function fix_points(q,ε_⭡,ε_⭣)
    Rounded_solution = []
    c_span=0:0.01:1
    for c_start = c_span
        c=[c_start]
        acuracy=1e-8
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
    return Rounded_solution
end

let 

delta_e=0.01
ε_⭡_span=0:delta_e:1.0
ε_⭣_span=0:delta_e:1.0

c_span=0:0.01:1
q=5
q_span=[5]

for q in q_span
    println("q=$q")
    num_of_fixed_point=zeros(length(ε_⭡_span),length(ε_⭣_span))
    typ_of_phase=zeros(length(ε_⭡_span),length(ε_⭣_span))
    non_zeros_stab=zeros(length(ε_⭡_span),length(ε_⭣_span))
    ε_⭡_i=1
    ε_⭣_i=1
    for ε_⭡ in ε_⭡_span
        ε_⭣_i=1
        println("e_1=$ε_⭡")
        for ε_⭣ in ε_⭣_span
            Rounded_solution = []
            if ε_⭡+ε_⭣!=0 && !(ε_⭡==0.5 && ε_⭣==0.5 && q==2)
            
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

                max_num=10
                num_of_fixed_point[ε_⭡_i,ε_⭣_i]=minimum([length(Rounded_solution),max_num])
                sol_num=1
                stab=0
                un_stab=0
                for sol_c in Rounded_solution

                    helpc = 1e-8
                    jac = jacobian(sol_c[1], q,ε_⭡,ε_⭣)
                    jac_plus = jacobian(sol_c[1]+helpc, q,ε_⭡,ε_⭣)
                    jac_minus = jacobian(sol_c[1]-helpc, q,ε_⭡,ε_⭣)
                    magnetisation=sol_c[1]
                    if jac < 0 && jac_plus < 0 && jac_minus < 0
                        stab=stab+1
                        if sol_c[1] != 0 && sol_c[1] != 1
                            non_zeros_stab[ε_⭡_i,ε_⭣_i]=sol_c[1]
                        end
                    else
                        un_stab=un_stab+1
                    end
                    sol_num+=1
                end


                if stab==1 && un_stab==1
                    typ_of_phase[ε_⭡_i,ε_⭣_i]=1

                elseif stab==0 && un_stab==2
                    typ_of_phase[ε_⭡_i,ε_⭣_i]=2

                elseif stab==1 && un_stab==2
                    typ_of_phase[ε_⭡_i,ε_⭣_i]=3

                elseif stab==2 && un_stab==1
                    typ_of_phase[ε_⭡_i,ε_⭣_i]=4
                    
                elseif stab==2 && un_stab==2
                    typ_of_phase[ε_⭡_i,ε_⭣_i]=5

                elseif stab==3 && un_stab==2
                    typ_of_phase[ε_⭡_i,ε_⭣_i]=6
                else
                    typ_of_phase[ε_⭡_i,ε_⭣_i]=-1
                end
            end
            ε_⭣_i=ε_⭣_i+1
        end
        ε_⭡_i=ε_⭡_i+1
    end
    typ_of_phase[1,1]=6

    # save data to csv file
    # CSV.write("typ_of_phase$q.csv", DataFrame(typ_of_phase,:auto))
    # CSV.write("non_zeros_stab$q.csv", DataFrame(non_zeros_stab,:auto))

    
    # draw heatmap of number of fixed points
    # plot1 = plot(dpi=3200)
    # col=cgrad(:matter, 6, categorical = true)
    # plot1 = heatmap(ε_⭡_span,ε_⭣_span,num_of_fixed_point)
    # plot1 = plot(plot1, aspect_ratio=:equal)
    # xlims!(0,1)
    # ylims!(0,1)
    # savefig("num_of_fix$q.png")

    # draw heatmap of number of type of phase
    plot1 = plot(dpi=3200)
    plot1 = heatmap(ε_⭡_span,ε_⭣_span,typ_of_phase, color = col, grid=true)   
    plot1 = plot(plot1, aspect_ratio=:equal)
    xlims!(0,1)
    ylims!(0,1)
    # savefig("typ_of_phase$q.png")
    display(plot1)

    
end
end