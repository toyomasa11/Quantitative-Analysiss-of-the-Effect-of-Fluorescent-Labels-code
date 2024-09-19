% 変数クリア
clear;

global k1 k2

% 初期値を定義
IN(1) = 100; % Input = 10 [nM]
IN(2) = 100;  % Gate_Output = 0 [nM]
IN(3) = 0;  % Output = 0 [nM]
IN(4) = 0; % Gate_Input = 0 [nM]

% エクセルファイルの読み込み
filename = '../data/base_change.xlsx';
M51 = readmatrix(filename,'Sheet','51'); % 5400sのデータ
M52 = readmatrix(filename,'Sheet','52'); % 5400sのデータ
M31 = readmatrix(filename,'Sheet','31'); % 5400sのデータ
M32 = readmatrix(filename,'Sheet','32'); % 5400sのデータ

fig1 = figure('name', 'change_sim1');
% ode15sによる数値積分(時間は0秒～5400秒)

clear t y
% 5-toehold 1
k1 = 5.0*1e-4; 
k2 = 0.0817; 
[t, y] = ode15s('model_change', [0 100], IN);
% 結果
hold on
plot (t, y(:, 3),'r','LineWidth',2.0);
hold off

% 5-toehold 2
k1 =1.4923e-04; 
k2 = 5.0*1e-4; 
[t, y] = ode15s('model_change', [0 100], IN);
% 結果
hold on
plot (t, y(:, 3),'b','LineWidth',2.0);
hold off

fileID = M51;
[t_ave,y_ave,y_std] = read_data_function(fileID,120);
hold on
    plot(t_ave,y_ave,'--r','LineWidth',2);
    ar=area(t_ave,[y_ave-y_std y_std+y_std]); 
    set(ar(1),'FaceColor','none','LineStyle','None','ShowBaseLine','off')
    set(ar(2),'FaceColor','r','FaceAlpha',0.2,'LineStyle','None')
    %axis([0 t_ave(end)./3600 0 inf]);
    set(gca,'FontSize',16,'linewidth',1.5);
    clear str t_ave y_ave y_std tmp 
hold off

fileID = M52;
[t_ave,y_ave,y_std] = read_data_function(fileID,120);
hold on
    plot(t_ave,y_ave,'--b','LineWidth',2);
    ar=area(t_ave,[y_ave-y_std y_std+y_std]); 
    set(ar(1),'FaceColor','none','LineStyle','None','ShowBaseLine','off')
    set(ar(2),'FaceColor','r','FaceAlpha',0.2,'LineStyle','None')
    %axis([0 t_ave(end)./3600 0 inf]);
    set(gca,'FontSize',16,'linewidth',1.5);
    clear str t_ave y_ave y_std tmp 
hold off

grid on;
axis([0,100,0,100]);
legend({'A', 'B'}, 'Interpreter', 'latex','Location','northwest');
% 軸ラベルの設定
xlabel('Time[s]');
ylabel('Substitution ratio[%]');


fig2 = figure('name', 'change_sim2');
% ode15sによる数値積分(時間は0秒～5400秒)

clear t y
% 3-toehold 1
k1 = 0.0012; 
k2 = 5.0*1e-4; 
[t, y] = ode15s('model_change', [0 100], IN);
% 結果
hold on
plot (t, y(:, 3),'r','LineWidth',2.0);
hold off

clear t y
% 3-toehold 2
k1 = 5.0*1e-4; 
k2 = 0.0156; 
[t, y] = ode15s('model_change', [0 100], IN);
% 結果
hold on
plot (t, y(:, 3),'b','LineWidth',2.0);
hold off

fileID = M31;
[t_ave,y_ave,y_std] = read_data_function(fileID,120);
hold on
    plot(t_ave,y_ave,'--r','LineWidth',2);
    ar=area(t_ave,[y_ave-y_std y_std+y_std]); 
    set(ar(1),'FaceColor','none','LineStyle','None','ShowBaseLine','off')
    set(ar(2),'FaceColor','r','FaceAlpha',0.2,'LineStyle','None')
    %axis([0 t_ave(end)./3600 0 inf]);
    set(gca,'FontSize',16,'linewidth',1.5);
    clear str t_ave y_ave y_std tmp 
hold off

fileID = M32;
[t_ave,y_ave,y_std] = read_data_function(fileID,130);
hold on
    plot(t_ave,y_ave,'--b','LineWidth',2);
    ar=area(t_ave,[y_ave-y_std y_std+y_std]); 
    set(ar(1),'FaceColor','none','LineStyle','None','ShowBaseLine','off')
    set(ar(2),'FaceColor','r','FaceAlpha',0.2,'LineStyle','None')
    %axis([0 t_ave(end)./3600 0 inf]);
    set(gca,'FontSize',16,'linewidth',1.5);
    clear str t_ave y_ave y_std tmp 
hold off

% グリッド線の表示
grid on;
flag = ~flag;

% 応用を表示
grid on
axis([0,100,0,100]);
legend({'A', 'B'},'Interpreter', 'latex','Location','northwest');
% 軸ラベルの設定
xlabel('Time[s]');
ylabel('Substitution ratio[%]');

%tunefig('qiita', fig1);         % 一枚だけ編集
tunefig('qiita', [fig1, fig2]);   % 複数の図を一度に編集

export_fig(gcf, '-dpdf', 'change_5.pdf', fig1);
export_fig(gcf, '-dpdf', 'change_3.pdf', fig2);

function [] = tunefig(style, figs, custom_style)
%RESHAPE_FIGURE figureの見た目を整える
%
%   tunefig(style, figs, custom_style)
%       style:          書式指定('document', 'ppt', %/'custom'/%)
%       figs:           figureハンドル(figure配列)
%       custom_style:   書式設定がcustomの場合のみ手本を指定(cell配列)
%                       custom_style = {fig_st, ax_st, ln_st}
%
%   See also FIGURE, AXES, LINE

% Copyright (c) 2019 larking95(https://qiita.com/larking95)
% Released under the MIT Licence 
% https://opensource.org/licenses/mit-license.php

%% 初期化
style_list = {'document', 'ppt', 'qiita', 'custom'};
style_num = 1;
fig_st = struct([]);
ax_st  = struct([]);
ln_st  = struct([]);

%% デフォルト設定の作成
% ======= document =======
% Type: figure
fig_st(1).Color = 'w';  % 背景色Color = 白'w'

% Type: axis
ax_st(1).Color = 'w';
ax_st(1).Box = 'on';
ax_st(1).GridLineStyle = '-';
ax_st(1).GridColor = [0.15, 0.15,0.15].*1.05;
ax_st(1).MinorGridLineStyle = '-';
ax_st(1).MinorGridAlpha = 0.1;
ax_st(1).LineWidth = 1.5;
ax_st(1).XColor = 'k';
ax_st(1).YColor = 'k';
ax_st(1).ZColor = 'k';
% ax_st(1).GridAlpha = 0.0;
ax_st(1).FontSize= 14;
ax_st(1).FontName = 'arial';
ax_st(1).XLabel.Interpreter = 'latex';
ax_st(1).YLabel.Interpreter = 'latex';
ax_st(1).ZLabel.Interpreter = 'latex';

% Type: line
ln_st(1).LineWidth = 1.5;

% ======= ppt =======
% Type: figure
fig_st(2).Color = 'w';%'none';  % 背景色Color = 透明'none'
% Type: axes
ax_st(2) = ax_st(1);    % axisの設定はdocumentから一旦コピー
ax_st(2).LineWidth = 1.5;   % ライン幅だけ1.5に変更
% Type: line
ln_st(2) = ln_st(1);    % lineの設定はdocumentから一旦コピー
ln_st(2).LineWidth = 1.5;   % ライン幅だけ1.5に変更

% ======= qiita =======
% Type: figure
fig_st(3).Color = 'w';%'none';  % 背景色Color = 透明'none'/ 白 'w'
% Type: axes
ax_st(3) = ax_st(1);    % axisの設定はdocumentから一旦コピー
ax_st(3).LineWidth = 2;   % ライン幅だけに変更
ax_st(3).FontSize= 15;
% Type: line
ln_st(3) = ln_st(1);    % lineの設定はdocumentから一旦コピー
ln_st(3).LineWidth = 2;   % ライン幅だけに変更

%% 引数の確認
style_name = validatestring(style, style_list, 1);
style_num = find(strcmpi(style_name, style_list));
if nargin <= 2 && style_num > length(style_list)
    error('custom_style is not defined');
end
switch nargin
    case 1
        figs = gcf;
        custom_style = gobjects;
    case 2
        custom_style = gobjects;
    case 3
        fig_st(end+1) = custom_style{1};
        ax_st(end+1)  = custom_style{2};
        ln_st(end+1)  = custom_style{3};
end
validateattributes(figs, {'matlab.ui.Figure'}, {'vector'});

%% 整形
ff = fieldnames(fig_st(style_num));
af = fieldnames(ax_st(style_num));
lf = fieldnames(ln_st(style_num));

for f = 1:length(figs)
    for ffidx = 1:length(ff)
        figs(f).(cell2mat(ff(ffidx))) = fig_st(style_num).(cell2mat(ff(ffidx)));
    end
    ax = findobj(figs(f),'Type','axes');
    for a = 1:length(ax)
        for afidx = 1:length(af)
            if isempty(ax_st(style_num).(cell2mat(af(afidx))))
                continue;
            end
            if isstruct(ax_st(style_num).(cell2mat(af(afidx))))
                field1 = cell2mat(af(afidx));
                field2 = cell2mat(fieldnames(ax_st(style_num).(cell2mat(af(afidx)))));
            else
                ax(a).(cell2mat(af(afidx))) = ax_st(style_num).(cell2mat(af(afidx)));
            end
        end
        ln = findobj(ax(a),'Type','Line');
        for l = 1:length(ln)
            for lfidx = 1:length(lf)
                ln(l).(cell2mat(lf(lfidx))) = ln_st(style_num).(cell2mat(lf(lfidx)));
            end
        end
    end
end
end