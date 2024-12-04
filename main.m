clear
close all

flag_opt = 0;% 1:最適化後, 0:最適化前

%% multiple shooting の条件
coeff_obj = 1e3;% 目的関数の係数
lsf = 1e8;
tsf = 1e7;
msf = 1;

%% 初期値の設定
y_node_int_all = [0, -1.496e8, 0, 29.78, 0, 0; 
                  1.496e8, 0, 0, 0, 29.78, 0; 
                  0, 1.496e8, 0, -29.78, 0, 0];

u_node_int_all = [0, 0, 0, 0; 
                  0, 0, 0, 3.154e+7/4; 
                  0, 0, 0, 3.154e+7/4];

%% スケーリングファクターを適用
y_node_int_all(:, 1:3) = y_node_int_all(:, 1:3) / lsf; % x, y, z のスケーリング
y_node_int_all(:, 4:6) = y_node_int_all(:, 4:6) * tsf / lsf; % vx, vy, vz のスケーリング
u_node_int_all(:, 1:3) = u_node_int_all(:, 1:3) * tsf / lsf; % vx, vy, vz のスケーリング
u_node_int_all(:, 4) = u_node_int_all(:, 4) /tsf; % T のスケーリング

N = length(u_node_int_all(:,1));
u_node_int_all(:, 4) = u_node_int_all(:, 4) * 1.015;
auxdata_set
auxdata.x_target = [0, 227936640, 0, -24.07, 0, 0]; % 目標点の設定
auxdata.x_target(1:3) = auxdata.x_target(1:3) / lsf; % x, y, z のスケーリング
auxdata.x_target(4:6) = auxdata.x_target(4:6) * tsf / lsf; % vx, vy, vz のスケーリング

%% 最適化に使う用にreshape
x_node_int_vector = reshape(y_node_int_all', [], 1);
u_node_int_vector = reshape(u_node_int_all', [], 1);
y0 = [x_node_int_vector;u_node_int_vector];
plot_traj_from_y

%% 最適化
yL = -[Inf*ones(length(x_node_int_vector),1); Inf*ones(length(u_node_int_vector),1)];
yU =  [Inf*ones(length(x_node_int_vector),1); Inf*ones(length(u_node_int_vector),1)];

%% 初期軌道の図を消す
close all

%% ちゃんと制約条件が適切か確認
confun(y0, auxdata);
objfun(y0, auxdata);

%% 最適化オプションの設定
options = optimoptions('fmincon', ...
    'Algorithm', 'sqp', ...
    'Display', 'iter-detailed', ...
    'UseParallel', false, ... % 並列化を有効にするなら true
    'StepTolerance', 1e-6, ...
    'OptimalityTolerance', 1e-3, ...
    'ConstraintTolerance', 1e-3, ...
    'MaxFunctionEvaluations', 5e5, ...
    'MaxIterations', 3000, ...
    'SpecifyObjectiveGradient', true, ...
    'SpecifyConstraintGradient', true);

% 最適化の実行
tic
[yopt, f, output] = fmincon(@(y) objfun(y, auxdata), y0, [], [], [], [], yL, yU, @(y) confun(y, auxdata), options);
toc
% 2回目の最適化の実行（必要なら）
% y0 = yopt;
% auxdata.coeff_obj = 100*coeff_obj;
% [yopt, f, output] = fmincon(@(y) objfun(y, auxdata), y0, [], [], [], [], yL, yU, @(y) confun(y, auxdata), options);

flag_opt = 1;% 1:最適化後, 0:最適化前
plot_traj_from_y