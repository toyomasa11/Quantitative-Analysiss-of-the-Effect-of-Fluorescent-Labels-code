% Reversible DSD model (simple version)

function dydt = diffun_rev_infinite2(~,y,r)

    dydt = zeros(4,1);

    x1 = y(1);
    x2 = y(2);
    x5 = y(3);
    x6 = y(4);
        
    k = 5.0*1e-4;

    v1 = k * x1 * x2;
    v2 = r(1) * x5 * x6;
    
    dydt(1) = - v1 + v2; % x1
    dydt(2) = - v1 + v2; % x2
    dydt(3) = + v1 - v2; % x5
    dydt(4) = + v1 - v2; % x6

end