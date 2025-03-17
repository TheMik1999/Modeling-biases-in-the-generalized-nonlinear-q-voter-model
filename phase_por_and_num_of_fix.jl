using DifferentialEquations 
# using SymPy
# using LinearAlgebra
using NLsolve
using Plots
using CSV
using DataFrames
function jacobian(c,q,e_1,e_2)
    part_1=c^(q - 1) *(q - c *(q + 1))
    part_2=(1 - c)^(q - 1)* (c* q + c - 1)
    part_3=(e_1 + e_2)* (e_1/(e_1 + e_2) - c)* (q *(1 - c)^(q - 1) - q* c^(q - 1)) - (e_1 + e_2)* (-c^q - (1 - c)^q + 1)
    return part_1+part_2+part_3
    # a1=c^(q - 1) *(q - c *(q + 1))
    # a2=(1 - c)^(q - 1)* (c* q + c - 1)
    # a3=(e_1 + e_2)* (e_1/(e_1 + e_2) - c)*(q *(1 - c)^(q - 1) - q* c^(q - 1)) + c^q + (1 - c)^q - 1
end

function myfunc(c, q,e1,e2)
    return [(e1-(e1+e2)*c)*(1-c^q-(1-c)^q)-(1-c)^q * c + c^q *(1-c)]
end

function myfunc(c, q,e1,e2)
    return [(e1+e2)*(e1/(e1+e2)-c)*(1-c^q-(1-c)^q)-(1-c)^q * c + c^q *(1-c)]
end

function fix_points(q,e_1,e_2)
    Rounded_solution = []
    c_span=0:0.01:1
    for c_start = c_span
        c=[c_start]
        acuracy=1e-8
        number_of_iterations=10^5

        root = nlsolve(c -> myfunc(c[1], q,e_1,e_2), c, ftol=acuracy, xtol=acuracy, iterations=number_of_iterations)
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
# delta_e=0.002

delta_e=0.001
e1_span=0:delta_e:0.5
e2_span=0:delta_e:0.5

c_span=0:0.01:1
q=5
# q_span=[7,8,9,10]

q_span=[5]
for q in q_span
    println("q=$q")
    num_of_fixed_point=zeros(length(e1_span),length(e2_span))
    typ_of_faze=zeros(length(e1_span),length(e2_span))
    non_zeros_stab=zeros(length(e1_span),length(e2_span))
    e1_i=1
    e2_i=1
    for e_1 in e1_span
        e2_i=1
        println("e_1=$e_1")
        for e_2 in e2_span
            Rounded_solution = []
            if e_1+e_2!=0 && !(e_1==0.5 && e_2==0.5 && q==2)
            
                for c_start = c_span
                    c=[c_start]
                    acuracy=1e-10
                    number_of_iterations=10^5

                    root = nlsolve(c -> myfunc(c[1], q,e_1,e_2), c, ftol=acuracy, xtol=acuracy, iterations=number_of_iterations)
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
                # println(e1_i," ",e2_i," ")
                max_num=10
                num_of_fixed_point[e1_i,e2_i]=minimum([length(Rounded_solution),max_num])
    # max_num_of_fixed_point=maximum(num_of_fixed_point)
                sol_num=1
                stab=0
                un_stab=0
                for sol_c in Rounded_solution
                    # println("sol_c=$sol_c")
                    helpc = 1e-8
                    jac = jacobian(sol_c[1], q,e_1,e_2)
                    jac_plus = jacobian(sol_c[1]+helpc, q,e_1,e_2)
                    jac_minus = jacobian(sol_c[1]-helpc, q,e_1,e_2)
                    # eigenvalues = eigvals(jac)
                    # println("Eigenvalues: $eigenvalues")
                    # c is concetraction i need magnetisation 
                    # magnetisation= abs(1-2*sol_c[1])
                    magnetisation=sol_c[1]
                    if jac < 0 && jac_plus < 0 && jac_minus < 0
                        stab=stab+1
                        # println("stable solution")
                        # println(sol_c[1], " ",e1_i," ",e2_i," ",sol_num)
                        if sol_c[1] != 0 && sol_c[1] != 1
                            non_zeros_stab[e1_i,e2_i]=sol_c[1]
                        end
                    else
                        un_stab=un_stab+1
                    end
                    sol_num+=1
                end

            # if stab==1 && un_stab==0
            #     typ_of_faze[e1_i,e2_i]=1

            # elseif stab==2 && un_stab==0
            #     typ_of_faze[e1_i,e2_i]=2

            # elseif stab==0 && un_stab==1
            #     typ_of_faze[e1_i,e2_i]=3

            # elseif stab==0 && un_stab==2
            #     typ_of_faze[e1_i,e2_i]=4

            # elseif stab==1 && un_stab==2
            #     typ_of_faze[e1_i,e2_i]=5

            # elseif stab==2 && un_stab==1
            #     typ_of_faze[e1_i,e2_i]=6

            # elseif stab==0 && un_stab==3
            #     typ_of_faze[e1_i,e2_i]=7

            # elseif stab==1 && un_stab==1
            #     typ_of_faze[e1_i,e2_i]=0
            # else
            #     typ_of_faze[e1_i,e2_i]=-1
            # end

                if stab==1 && un_stab==1
                    typ_of_faze[e1_i,e2_i]=1

                elseif stab==0 && un_stab==2
                    typ_of_faze[e1_i,e2_i]=2

                elseif stab==1 && un_stab==2
                    typ_of_faze[e1_i,e2_i]=3

                elseif stab==2 && un_stab==1
                    typ_of_faze[e1_i,e2_i]=4
                    
                elseif stab==2 && un_stab==2
                    typ_of_faze[e1_i,e2_i]=5

                elseif stab==3 && un_stab==2
                    typ_of_faze[e1_i,e2_i]=6
                else
                    typ_of_faze[e1_i,e2_i]=-1
                end
            end
            e2_i=e2_i+1
        end
        e1_i=e1_i+1
    end
    typ_of_faze[1,1]=6
    # draw line elsilon_1=eplsilon_-1 
    plot1 = plot(dpi=3200)
    # draw heatmap 
    col=cgrad(:matter, 6, categorical = true)
    plot1 = heatmap(e1_span,e2_span,num_of_fixed_point)
    # display
    # display(plot1)
    # squer axis 
    plot1 = plot(plot1, aspect_ratio=:equal)
    xlims!(0,1)
    ylims!(0,1)
    # save 
    savefig("Pratic_x_castalano_general/Plot/1h_hm_num_of_fix$q.png")

    plot1 = plot(dpi=3200)
    # draw heatmap
    # labels = (1:1:6,["s1 u1", "s0 u2", "s1 u2", "s2 u1", "s2 u2", "s3 u2"])
    # save typ_of_faze to csv
    CSV.write("Pratic_x_castalano_general/Data/Map/1_typ_of_faze_zoom$q.csv", DataFrame(typ_of_faze,:auto))
    # non_zeros_stab
    CSV.write("Pratic_x_castalano_general/Data/Map/1_non_zeros_stab_zoom$q.csv", DataFrame(non_zeros_stab,:auto))
    plot1 = heatmap(e1_span,e2_span,typ_of_faze, color = col, grid=true)#,colorbar_ticks=labels)
    
    plot1 = plot(plot1, aspect_ratio=:equal)
    xlims!(0,1)
    ylims!(0,1)


    # display
    display(plot1)
    # save
    savefig("Pratic_x_castalano_general/Plot/1typ_of_faze$q.png")
end
end