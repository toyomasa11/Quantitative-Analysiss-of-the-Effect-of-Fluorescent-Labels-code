function f=model(t,IN)
f = zeros(4,1);

% パラメータ設定
global k1 k2

% わかりやすくするためのモデルのタンパク質名に置き換える
Input = IN(1); 
Gate_Output = IN(2);
Output = IN(3); 
Gate_Input = IN(4);

% 反応速度式の右辺を記述
v1 = k1*Input*Gate_Output;
v2 = k2*Output*Gate_Input;

% 微分方程式の右辺を記述
f(1) = -v1+v2; % Input
f(2) = -v1+v2; % Gate_Output
f(3) = v1-v2; % Output
f(4) = v1-v2; % Gate_Input