function [t_str,y_str] = data_processing(flag,fileID,tim_in,dd,pc,nc,i_from,i_to,conditionA,ex)

% fileID : excel ./data/~
% fgetl(fileID) : Reading lines from a file
% split(A,["	"]); :Separate text in A with spaces

clear tim y tn yn yn0 yn1 yn2 
tim = fileID(:,1); 
y = fileID; %

for i=i_from:i_to 
    clear buf_nc buf_pc yn0 yn1 y2 yn buf_t tn y_nc y_pc yn3;

    % Draw the raw data
    figure(1)
    subplot(1,4,4*(ex-1)+1); 
    plot(tim,y(:,dd(i)),'o',tim,y(:,pc(i)),'-',tim,y(:,nc(i)),':','LineWidth',1.0);xlim([0 tim(end)]);
    hold on;
    set(gca,'FontSize',16,'linewidth',1.5)
    xlabel('time (s)','FontSize',16);
    ylabel('intensity [a.u.]','FontSize',16);
    tmp = strcat('Raw data (',flag,')');
    title(tmp,'FontSize',16);

    % Step1: Pre-processing (1)... Define the control concentration at t=0
    switch conditionA
        case 1
            % method 1: Average of 10 points after NC data input at time 0 (control).
            buf_nc = y(tim>tim_in,nc(i));   % extract data after NC input... (1)
            yn0 = mean(buf_nc(1:10));       % Mean of first 10 points in (1) = value at time 0
            yn1 = y(tim>tim_in,dd(i));      % Extract data after the main data input... (2)
            yn2=[yn0;yn1];                  % Insert the value at time 0 (control) at the beginning of (2)
        case 2
            % method 2: Average of the 10 points before the main data input is used as the value at time 0 (control).
            buf_nc = y(tim<tim_in,dd(i));       % Extract data before input input of Y... (1)
            if length(buf_nc) < 10
                yn0 = mean(buf_nc(1:end));      % average of last remaining points of (1) = value at time 0
            else
                yn0 = mean(buf_nc(end-10:end)); % average of last 10 points in (1) = value at time 0
            end                
            yn1 = y(tim>tim_in,dd(i));      % Extract data after the main data input... (2)
            yn2=[yn0;yn1];                  % Insert the value at time 0 (control) at the beginning of (2)
        otherwise
            disp('Error!');
    end

    % Step2: Pre-processing (2)... Adjust the time points
    % Policy: The first point after inputting time data should be tim_0 and the first 0 of the time data should be put in the beginning of the time data.
    tim_0  = min(tim(tim>tim_in))-tim_in;             % Time interval from input to next measurement (which is the first data point time)
    buf_t=tim(tim>tim_in)-min(tim(tim>tim_in))+tim_0;
    tn = [0,buf_t'];

    % Step3-a: Compute the time series of NC
    buf_nc = y(tim>tim_in,nc(i));   % Extract data after NC input... (1)
    buf_n0 = mean(buf_nc(1:10));    % Average of first 10 points in (1) = value at time 0
    y_nc=[buf_n0;buf_nc];           % Insert the value at time 0 (control) at the beginning of (2)

    % Step 3-b: Calculate the time series of PC
    buf_pc = y(tim>tim_in,pc(i));   % Extract data after inputting PC input... (1)
    buf_p0 = mean(buf_pc(1:10));    % Average of first 10 points in (1) = value at time 0
    y_pc=[buf_p0;buf_pc];           % Insert the value of time 0 (control) at the beginning of (2)

    subplot(1,4,4*(ex-1)+2); % Change the initial point No correction
    plot(tn,yn2,'o',tn,y_pc,'-',tn,y_nc,':','LineWidth',1.0);xlim([0 tn(end)]);
    hold on;
    set(gca,'FontSize',16,'linewidth',1.5)
    xlabel('time (s)','FontSize',16);
    ylabel('intensity [a.u.]','FontSize',16);
    tmp = strcat('Pre-processing (',flag,')');
    title(tmp,'FontSize',16);
    
    % Step4: Convert the signal intensity to concentration
    dat0 = buf_n0; % How to calculate concentration 0nM is debatable Initial value of negative control
    dat1 = buf_p0; % How to calculate concentration 10nM is debatable Initial value of positive control
    alp = 100 / (dat1 - dat0);
    bet = - dat0 * alp;
    yn3 = alp .* yn2 + bet; % Calculate correction value

    subplot(1,4,4*(ex-1)+3);
    plot(tn,yn3,'o','LineWidth',1.0);xlim([0 tn(end)]);
    hold on;
    set(gca,'FontSize',16,'linewidth',1.5)
    xlabel('time (s)','FontSize',16);
    ylabel('conc. (nM)','FontSize',16);
    tmp = strcat('Normalized (',flag,')');
    title(tmp,'FontSize',16);       

    t_str(:,i) = tn'; y_str(:,i) = yn3;
end
