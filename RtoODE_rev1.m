function solpts = RtoODE_rev1(r,tspan,y0)

    clear sol solpts_t;
    
    opts     = odeset('RelTol',1e-10,'AbsTol',1e-10);

    sol      = ode15s(@(t,y)diffun_rev_infinite1(t,y,r),tspan,y0,opts); % Use this for simple model
    %sol      = ode15s(@(t,y)diffun_rev_detailed(t,y,r),tspan,y0,opts); % Use this for detailed model

    solpts_t = deval(sol,tspan);
    solpts   = solpts_t(end,:);%./max(solpts_t(end,:)); % normalized by the max value 

end