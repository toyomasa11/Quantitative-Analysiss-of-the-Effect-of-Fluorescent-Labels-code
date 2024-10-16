function solpts = RtoODE_rev(r,tspan,y0)

    clear sol solpts_t;
    
    opts     = odeset('RelTol',1e-10,'AbsTol',1e-10);

    sol      = ode15s(@(t,y)diffun_rev_infinite(t,y,r),tspan,y0,opts); % Use this for simple model

    solpts_t = deval(sol,tspan);
    solpts   = solpts_t(end,:);%./max(solpts_t(end,:)); % normalized by the max value 

end