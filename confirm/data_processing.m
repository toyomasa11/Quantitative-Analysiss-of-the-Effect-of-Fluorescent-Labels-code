function [t_str,y_str] = data_processing(flag,fileID,tim_in,dd,pc,nc,i_from,i_to,conditionA,ex)

% fileID : エクセルのシート
% fgetl(fileID) : ファイルからの行の読み込み
% split(A,["	"]); :Aのテキストを空白で区切る

clear tim y tn yn yn0 yn1 yn2 % 関数の初期化

tim = fileID(:,1); % 時間の読み込み
y = fileID; %

for i=i_from:i_to 
    clear buf_nc buf_pc yn0 yn1 y2 yn buf_t tn y_nc y_pc yn3;

    % Step1: Pre-processing (1)... Define the control concentration at t=0
    switch conditionA
        case 1
            % method 1: NCデータのインプット投入後の10点の平均を時刻0の値とする（コントロール）。
            buf_nc = y(tim>tim_in,nc(i));   % NCのインプット投入後のデータを抽出...(1)
            yn0 = mean(buf_nc(1:10));       % (1)の最初の10点の平均＝時刻0の値とする
            yn1 = y(tim>tim_in,dd(i));      % 主データのインプット投入後のデータを抽出...(2)
            yn2=[yn0;yn1];                  % 時刻0（コントロール）の値を(2)の先頭に挿入
        case 2
            % method 2: 主データのインプット投入前の10点の平均を時刻0の値とする（コントロール）。
            buf_nc = y(tim<tim_in,dd(i));       % Yのインプット投入前のデータを抽出...(1)
            if length(buf_nc) < 10
                yn0 = mean(buf_nc(1:end));      % (1)の最後の残りの点の平均＝時刻0の値とする
            else
                yn0 = mean(buf_nc(end-10:end)); % (1)の最後の10点の平均＝時刻0の値とする
            end                
            yn1 = y(tim>tim_in,dd(i));      % 主データのインプット投入後のデータを抽出...(2)
            yn2=[yn0;yn1];                   % 時刻0（コントロール）の値を(2)の先頭に挿入
        otherwise
            disp('Error!');
    end

    % Step2: Pre-processing (2)... Adjust the time points
    % 方針：時刻データのインプット投入後の最初の点をtim_0にし，かつ，時刻データの先頭に0を入れる。
    tim_0  = min(tim(tim>tim_in))-tim_in;             % インプット投入から次の計測までの時間間隔（最初のデータ点時刻となる）
    buf_t=tim(tim>tim_in)-min(tim(tim>tim_in))+tim_0;
    tn = [0,buf_t'];

    % Step3-a: NCの時系列を計算
    buf_nc = y(tim>tim_in,nc(i));   % NCのインプット投入後のデータを抽出...(1)
    buf_n0 = mean(buf_nc(1:10));    % (1)の最初の10点の平均＝時刻0の値とする
    y_nc=[buf_n0;buf_nc];           % 時刻0（コントロール）の値を(2)の先頭に挿入

    % Step3-b: PCの時系列を計算
    buf_pc = y(tim>tim_in,pc(i));   % PCのインプット投入後のデータを抽出...(1)
    buf_p0 = mean(buf_pc(1:10));    % (1)の最初の10点の平均＝時刻0の値とする
    y_pc=[buf_p0;buf_pc];           % 時刻0（コントロール）の値を(2)の先頭に挿入
    
    % Step4: Convert the signal intensity to concentration
    dat0 = buf_n0; % 濃度0nMをどのように計算するかは議論の余地がある ネガコンの初期値
    dat1 = buf_p0; % 濃度10nMをどのように計算するかは議論の余地がある ポジコンの初期値
    alp = 100 / (dat1 - dat0);
    bet = - dat0 * alp;
    yn3 = alp .* yn2 + bet; %補正値の算出

    t_str(:,i) = tn'; y_str(:,i) = yn3;
end
