"""
    one_step(N::Int, N_up::Int, ε_⭡::Float64, 
             ε_⭣::Float64, q::Int)

Performs one elementary step Monte Carlo simulation :

- `N` – total number of agents.
- `N_up` – number of agents with the adopted state.
- `ε_⭡` – probability of changing opinion to adopted (if not unanimity).
- `ε_⭣` – probability of changing opinion to unadopted (if not unanimity).
- `q` – number of agents considered in the panel.

Returns the value by how much the N_up will change
"""

function one_step(N::Int,N_up::Int,ε_⭡::Float64,ε_⭣::Float64,q::Int)
    r=rand()
    q_con=1 # which agent of q-panel will be draw next 
    q_panel_fail=false # give as info if we collect q_panel with same opinion 
    N_down=N-N_up
    if r <= N_up/N
        # agent have up opinion 
        r=rand()
        if r <=(N_up-1)/(N-1)
            #first agent in q-panel is up
            while q_con!=q && !q_panel_fail
                r=rand()
                if r<=1-(N_up-1-q_con)/(N-1-q_con)
                    q_panel_fail=true
                end
                q_con=q_con+1
            end

            if q_panel_fail==false
                return 0
            end
        else
            #first agent in q-panel is down
            while q_con!=q && !q_panel_fail
                r=rand()
                if r<=1-(N_down-q_con)/(N-1-q_con)
                    q_panel_fail=true
                end
                q_con=q_con+1
            end

            if q_panel_fail==false
                return -1
            end
        end
        
        # we did not collect q-panel with same opinion
        r=rand()
        if r<ε_⭣
            return -1
        else
            return 0       
        end
    
    else
        # agent have down opinion 
        r=rand()
        if r <=(N_up)/(N-1)
            #first agent in q-panel is up
            while q_con!=q && !q_panel_fail
                r=rand()
                if r<=1-(N_up-q_con)/(N-1-q_con)
                    q_panel_fail=true
                end
                q_con=q_con+1
            end

            if q_panel_fail==false
                return 1
            end

        else

            #first agent in q-panel is down
            while q_con!=q && !q_panel_fail
                r=rand()
                if r<=1-((N_down-q_con-1))/(N-1-q_con)
                    q_panel_fail=true
                end
                q_con=q_con+1
            end

            if q_panel_fail==false
                return 0
            end

        end

        # we did not collect q-panel with same opinion
        r=rand()
        if r<ε_⭡ 
            return 1
        else
            return 0
        end

    end
end