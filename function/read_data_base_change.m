clear;
figure(1);clf;
figure(10);clf;

% =========================================================================
% DNA strand displacement reaction % 蛍光色素あたりに特化したやつ
% =========================================================================

flag='base';

% エクセルファイルの読み込み
filename = '../data/base_change.xlsx';
M51 = readmatrix(filename,'Sheet','51'); % 5400sのデータ
M52 = readmatrix(filename,'Sheet','52'); % 5400sのデータ
M31 = readmatrix(filename,'Sheet','31'); % 5400sのデータ
M32 = readmatrix(filename,'Sheet','32'); % 5400sのデータ

% (1) Designate the input time (120s) インプット時間の指定(秒)
tim_in = 120; % ?????? 個々に指定する必要があるかも…

% (2) Designate the data positions データの位置を指定
dd = [3 4 5];  % main data 

% ポジコンとネガコンの位置を指定
pc = [7 8 9];  % pos. con
nc = [11 12 13];  % neg. con

% =========================================================================
% 1st data:DNAの可逆 (5') 出力１本鎖
% =========================================================================

ex=1;
fileID =M31;
dele = 7; % 削除する始めの行
[t_str,y_str] = data_processing(flag,fileID,tim_in,dd,pc,nc,1,3,2,ex); % method 2 データ補正
 % data_processing(flag?,エクセルのシート名,インプット時間,dd,pc,nc,1,グラフの最大本数,どの方法を使うか) 
t_str(dele:end, :) = [];
y_str(dele:end, :) = []; % tのいらない時間を消去 202 ⇒ 1010秒以降
str(ex,:) = {flag; t_str; y_str}; clear t_str y_str;

% =========================================================================
% average and stndard deviation
% =========================================================================
clear ex
for ex=1

    clear t_inter1 y_inter1 t_inter2 y_inter2 t_inter3 y_inter3 y_inter;

    j=1;
    t_inter1 = [min(str{ex,2}(:,j)):1:max(str{ex,2}(:,j))]'; % 時間
    y_inter1 = interp1(str{ex,2}(:,j),str{ex,3}(:,j),t_inter1); % 時間に対応するyの値の抽出

    j=2;
    t_inter2 = [min(str{ex,2}(:,j)):1:max(str{ex,2}(:,j))]';
    y_inter2 = interp1(str{ex,2}(:,j),str{ex,3}(:,j),t_inter2);

    j=3;
    t_inter3 = [min(str{ex,2}(:,j)):1:max(str{ex,2}(:,j))]';
    y_inter3 = interp1(str{ex,2}(:,j),str{ex,3}(:,j),t_inter3);

    clear l_ l_min;
    l_ = [t_inter1(end),t_inter2(end),t_inter3(end)];
    l_min = min(l_);

    t_inter1 = t_inter1(t_inter1 <= l_min);
    y_inter1 = y_inter1(t_inter1 <= l_min);
    t_inter2 = t_inter2(t_inter2 <= l_min);
    y_inter2 = y_inter2(t_inter2 <= l_min);
    t_inter3 = t_inter3(t_inter3 <= l_min);
    y_inter3 = y_inter3(t_inter3 <= l_min);

    y_inter = [y_inter1,y_inter2,y_inter3];

    clear t_ave y_ave y_std % 配列の準備
    t_ave  = zeros(length(t_inter1),1);
    y_ave  = zeros(length(t_inter1),1);
    y_std  = zeros(length(t_inter1),1);

    for k=1:length(t_inter1)
       t_ave(k) = t_inter1(k);
       y_ave(k) = mean(y_inter(k,:));
       y_std(k) = std(y_inter(k,:));   
    end

    str_ave(ex,:) = {flag; t_ave; y_ave; y_std};    

    figure(1);
    subplot(1,4,4);
    ar=area(t_ave,[y_ave-y_std y_std+y_std]); hold on
    set(ar(1),'FaceColor','none','LineStyle','None','ShowBaseLine','off')
    set(ar(2),'FaceColor','r','FaceAlpha',0.2,'LineStyle','None')
    plot(t_ave,y_ave,'b','LineWidth',2);
    %axis([0 t_ave(end)./3600 0 inf]);
    set(gca,'FontSize',16,'linewidth',1.5);
    xlabel('time (sec)','FontSize',16);
    ylabel('conc. (nM)','FontSize',16);
    tmp = strcat('Averaged (',str{ex,1},')');
    title(tmp,'FontSize',16);

    % === summary 1 ===
    figure(10);
    ar=area(t_ave,[y_ave-y_std y_std+y_std]); hold on
    set(ar(1),'FaceColor','none','LineStyle','None','ShowBaseLine','off')
    set(ar(2),'FaceColor','r','FaceAlpha',0.2,'LineStyle','None')
    plot(t_ave,y_ave,'LineWidth',4);
    set(gca,'FontSize',24,'linewidth',2,'FontName','Arial');
    xlabel('time (sec)','FontSize',24);
    ylabel('concentration (nM)','FontSize',24);
    tmp = strcat('Averaged (',str{ex,1},')');
    title(tmp,'FontSize',24);
    axis([0 max(t_ave) -0.2 100])
    % ================
end

%{
% =========================================================================
% =========================================================================
% Export data to file
% =========================================================================
% =========================================================================
for i=1:3
    clear out;
    tmp = strcat(str{i,1},'.txt');tmp = strrep(tmp,')/','-');tmp = strrep(tmp,'(','-');
    for j=1:3
        for k=1:length(str{i,2}(:,j))
            out(k,2*(j-1)+1) = str{i,2}(k,j);
            out(k,2*(j-1)+2) = str{i,3}(k,j);
        end
    end
    writematrix(out,tmp,'Delimiter','tab')
end
%}