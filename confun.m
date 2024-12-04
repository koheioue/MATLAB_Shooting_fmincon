function [c, ceq, gradc, gradceq] = confun(y, auxdata)
    % 入力パラメータの分解
    N = auxdata.N;                   % ノード数
    options = auxdata.options;       % ODEソルバーの設定
    x_node_int = reshape(y(1:6*N), 6, N)'; % 状態変数 (N×6 行列)
    u_node = reshape(y(6*N+1:6*N+4*N), 4, N)'; % 制御変数 (N×4 行列)
    T_sum = cumsum(u_node(:, 4));    % 時間積算

    % 等式制約の初期化
    ceq_node = [auxdata.y_node_int_all(1, 1:6) - x_node_int(1, :)]; % 初期条件の差
    x_all_plot = [];  % 軌道データ保存用
    
    % 制約条件の計算（各ノード間）
    for rev = 1:N-1
        % 時間範囲と初期状態
        tspan = [T_sum(rev), T_sum(rev+1)];
        x0 = [x_node_int(rev, 1:3), x_node_int(rev, 4:6) + u_node(rev, 1:3)];
        
        % ODEの解法
        [~, x] = ode15s(@(t, x) x_dot_2bp(t, x, auxdata), tspan, x0, options);
        x_all_plot = [x_all_plot; x];  % 軌道データの保存
        
        % ノード間の差を等式制約に追加
        ceq_node = [ceq_node; x(end, :) - x_node_int(rev+1, :)];
    end
    
    % 最終状態の制約を追加
    ceq_node = [ceq_node; x(end, 1:3) - auxdata.x_target(1:3), ...
                         x(end, 4:6) + u_node(N, 1:3) - auxdata.x_target(4:6)];
    ceq = reshape(ceq_node', [], 1); % 等式制約ベクトル
    c = [];                          % 不等式制約は無し

    % gradceqの初期化
    gradceq = zeros(length(ceq), length(y));
    
    % 初期条件のヤコビ行列
    gradceq(1:6, 1:6) = -eye(6);
    
    % ノード間のヤコビ行列
    for rev = 1:N-1
        % 状態変数のヤコビ行列
        [~, A] = x_dot_2bp(0, x_node_int(rev, :)', auxdata);
        time_diff = T_sum(rev+1) - T_sum(rev); % 時間差
        
        % 現在のノードの影響
        gradceq(6*rev+1:6*(rev+1), 6*rev+1:6*(rev+1)) = eye(6) + A * time_diff;
        
        % 次のノードへの影響
        gradceq(6*rev+1:6*(rev+1), 6*(rev+1)+1:6*(rev+2)) = -eye(6);
        
        % 制御変数のヤコビ行列
        gradceq(6*rev+1:6*(rev+1), 6*N+4*rev+1:6*N+4*rev+4) = [zeros(3, 4); eye(3), zeros(3, 1)];
    end
    
    % 最終状態のヤコビ行列
    gradceq(end-6+1:end, 6*N-6+1:6*N) = [eye(3), zeros(3, 3); zeros(3, 3), eye(3)];
    gradceq(end-6+1:end, 6*N+4*(N-1)+1:6*N+4*N) = [zeros(3, 3), zeros(3, 1); eye(3), zeros(3, 1)];
    
    % 転置
    gradceq = transpose(gradceq);
    gradc   = [];
end