function f=model(t,IN)
f = zeros(4,1);

% Parameter Setting
global k1 k2

% Replace with protein name in model for clarity
Input = IN(1); 
Gate_Output = IN(2);
Output = IN(3); 
Gate_Input = IN(4);

% Write the right-hand side of the reaction rate equation
v1 = k1*Input*Gate_Output;
v2 = k2*Output*Gate_Input;

% Write the right side of the differential equation
f(1) = -v1+v2; % Input
f(2) = -v1+v2; % Gate_Output
f(3) = v1-v2; % Output
f(4) = v1-v2; % Gate_Input