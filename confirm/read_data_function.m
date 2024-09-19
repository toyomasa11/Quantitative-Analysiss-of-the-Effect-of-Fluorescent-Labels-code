function [t_ave,y_ave,y_std] = read_data_function(fileID,input_time)

flag='base';

% (1) Designate the input time (120s) インプット時間の指定(秒)
tim_in = input_time; % ?????? 個々に指定する必要があるかも…

% (2) Designate the data positions データの位置を指定
dd = [3 4 5];  % main data 

% ポジコンとネガコンの位置を指定
pc = [7 8 9];  % pos. con
nc = [11 12 13];  % neg. con

% =========================================================================
% 1st data:DNAの可逆 (5') 出力１本鎖
% =========================================================================

ex=1;
dele = 102; % 削除する始めの行
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
end
end

