clear; % 変数をクリア
clc;

% 2A 51 1:5.0*1e-4 2:         = 2
% 2B 52 1:         2:5.0*1e-4 = 1
% 3A 31 1:         2:5.0*1e-4 = 1
% 3B 32 1:5.0*1e-4 2:         = 2

% Read the experimental data　データの読み込み　
run("./function/read_data_base_change.m");

% =====================================================
% base change
% =====================================================

r1 = optimvar('r1',1,"LowerBound",0,"UpperBound",1e-1); % 最適化変数の作成
%r2 = optimvar('r2',1,"LowerBound",0,"UpperBound",1e-2);
r = r1;

clear obj r0 myfcn prob rsol sumsq est;
obj  = 0; 
r0.r1 = 1e-6;
%r0.r2 = 1e-6;

% ==================================
% ex = 1: DNA
% ==================================
for ex = 1 %<=================================注意！！！！
    % ==================
    % i = 1~3: I = 100 nM
    % ==================    
    for i=1:3 %<=================================注意！！！！」
        y0 = [100 100 0 0]; % 初期値
        myfcn = fcn2optimexpr(@RtoODE_rev1,r,str{ex,2}(:,i),y0);
        %myfcn = fcn2optimexpr(@RtoODE_rev2,r,str{ex,2}(:,i),y0);

        str{ex,3}(str{ex,3}(:,i)<0,i) = 0; % negative values are set to zero.
        clear exdat;
        exdat = str{ex,3}(:,i);% ./ max( str{ex,3}(:,i) ); % normalized by the max value

        obj = obj + sum(sum((myfcn - exdat').^2)); % without normalization
        %obj = obj + sum(sum( ((myfcn - exdat')./max(exdat)).^2 )); % with normalization

        % add weights at around steady state
        %off = round(length(exdat)/2);
        %obj = obj + 2 * sum(sum((myfcn(end-off:end) - exdat(end-off:end)').^2)); 
    end
end
    
prob = optimproblem("Objective",obj);
%show(prob);

op = optimoptions('ga');
%op.MaxStallGenerations=10;
%op.MaxGenerations=1;
op.UseParallel=true;  
op.Display='iter';
%op.HybridFcn='patternsearch';
%op.MigrationDirection='both';
%op.ConstraintTolerance=1e-6;
%op.FunctionTolerance=1e-9;
op.PopulationSize=200;

[rsol,sumsq] = solve(prob,r0,'Solver',"ga",'Options',op); %,"ObjectiveDerivative",'finite-differences',"ConstraintDerivative",'finite-differences');
disp(rsol.r1);
%disp(rsol.r2);
%disp(rsol.r1/rsol.r2);
%r_ = [rsol.r1 rsol.r2];
r_ = rsol.r1;
beep;    

% Draw the estimated result
figure(2);clf;
opts = odeset('RelTol',1e-10,'AbsTol',1e-10);
for ex=1%<=================================注意！！！！」
    for i=1:3%<=================================注意！！！！」
        [t,y] = ode15s(@(t,y)diffun_rev_infinite1(t,y,r_),str{ex,2}(:,i),y0,opts); % simple model
        %[t,y] = ode15s(@(t,y)diffun_rev_infinite2(t,y,r_),str{ex,2}(:,i),y0,opts); % simple model

        %subplot(1,2,ex);
        plot(t,y(:,end),'LineWidth',4.0);hold on;
        %plot(str{ex,2}./3600,str{ex,3}(:,i),'o-','LineWidth',1.0);hold on;
        set(gca,'FontSize',24,'linewidth',2,'FontName','Arial')
        xlabel('time (hours)','FontSize',24);
        ylabel('concentration [nM]','FontSize',24);
        %tmp = strcat(str{ex,1},": k_R = ",num2str(r_(1))," k_D = ",num2str(r_(2)));
        %title(tmp,'FontSize',16);

        xlim([0 max(t_ave)]);%ylim([0 100])
    end
end


   