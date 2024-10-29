% yを受け取って、それから軌道を描画します。
close all
if flag_opt == 0
    y_plot = y0;
elseif flag_opt == 1
    y_plot = yopt;
end

%% ここはまだスケーリングされている、
x_node     = reshape(y_plot(1:6*(N)),6,N)';% (N)×6の行列
u_node     = reshape(y_plot(6*(N)+1:6*(N)+4*N),4,N)';% N×4の行列
x_node_real(:, 1:3) = x_node(:, 1:3) * lsf; % x, y, z のスケーリングを元に戻す
x_node_real(:, 4:6) = x_node(:, 4:6) * lsf / tsf; % vx, vy, vz のスケーリングを元に戻す
u_node_real(:, 1:3) = u_node(:, 1:3) * lsf / tsf; % vx, vy, vz のスケーリングを元に戻す

T_sum = [cumsum(u_node(1:N, 4))];% 0, T1, T1+T2, ...のベクトル
x_node_end = [];
options = auxdata.options;

figure(1)
% 太陽をプロットする（大きさは、半径R_sunを使用）（2次元平面で）
theta = linspace(0, 2*pi, 100);
x_sun = auxdata.R_sun_km * cos(theta);
y_sun = auxdata.R_sun_km * sin(theta);
fill(x_sun, y_sun, 'r', 'FaceAlpha', 0.5, 'EdgeColor', 'k', 'LineWidth', 2)
hold on
% 火星をプロット
x_mars = auxdata.R_mars_km * cos(theta);
y_mars = 227936640 + auxdata.R_mars_km * sin(theta);
fill(x_mars, y_mars, 'r', 'FaceAlpha', 0.5, 'EdgeColor', 'k', 'LineWidth', 2)
hold on
xx_mars = 227936640 * cos(theta);
yy_mars = 227936640 * sin(theta);
plot(xx_mars, yy_mars, '--', Color=[0.5 0.5 0.5])
hold on
% 地球の公転軌道をプロット
xx_earth = 1.496e8 * cos(theta);
yy_earth = 1.496e8 * sin(theta);
plot(xx_earth, yy_earth, '--', Color=[0.5 0.5 0.5])
hold on
plot(x_node_real(:,1), x_node_real(:,2), 'r*', MarkerSize=5, LineWidth=2)
hold on

for node_num = 1 : N-1
    tspan   = [T_sum(node_num) T_sum(node_num+1)];
    x0 = [x_node(node_num,1:3), x_node(node_num,4:6)+u_node(node_num,1:3)];
    [t, x] = ode45(@(t, x) x_dot_2bp(t, x, auxdata), tspan, x0, options);
    x(:, 1:3) = x(:, 1:3) * lsf; % x, y, z のスケーリングを元に戻す
    x(:, 4:6) = x(:, 4:6) * lsf / tsf; % vx, vy, vz のスケーリングを元に戻す
    x_node_end = [x_node_end;x(end,:)];
    figure(1)
    hold on
    plot(x(:,1), x(:,2), Color=[1,0,0], LineWidth=2)% 軌道を赤線で描画
    hold on
    plot(x0(1), x0(2), 'r*', MarkerSize=5, LineWidth=2)% 軌道の始点は赤*
    hold on
    plot(x(end), x(end), 'b*', MarkerSize=5, LineWidth=2)% 軌道の終点は青*
    hold on
    quiver(x_node_real(node_num,1), x_node_real(node_num,2), 1e7*u_node(node_num,1), 1e7*u_node(node_num,2), 'LineWidth', 2, 'MaxHeadSize',20, Color=[0 0 0])
    hold on
end
quiver(x_node_real(N,1), x_node_real(N,2), 1e7*u_node(N,1), 1e7*u_node(N,2), 'LineWidth', 2, 'MaxHeadSize',20, Color=[0 0 0])
axis equal
grid on
% x軸とy軸を追加し、kmと表示
xlabel('x ,km')
ylabel('y ,km')

%% ΔVの合計  km/s
delta_v = u_node_real(:, 1:3);
delta_v_sum_km_s = sum(vecnorm(delta_v, 2, 2)); 
disp(['Delta V sum = ', num2str(delta_v_sum_km_s), ' km/s'])

if flag_opt == 0
    title(['Initial Guess Trajectory (ΔV = ', num2str(delta_v_sum_km_s), ' km/s)'])
elseif flag_opt == 1
    title(['Optimized Trajectory (ΔV = ', num2str(delta_v_sum_km_s), ' km/s)'])
end

%% ホーマン遷移軌道のΔVを解析的に計算
% ホーマン遷移軌道の半長径
a_transfer = (auxdata.R_sun_earth + auxdata.R_sun_mars) / 2;
v_earth_orbit = sqrt(auxdata.mu_sun / auxdata.R_sun_earth);
v_mars_orbit = sqrt(auxdata.mu_sun / auxdata.R_sun_mars);

% ホーマン遷移軌道上の速度（地球出発時）
v_transfer_earth = sqrt(auxdata.mu_sun * (2/auxdata.R_sun_earth - 1/a_transfer));

% ホーマン遷移軌道上の速度（火星到着時）
v_transfer_mars = sqrt(auxdata.mu_sun * (2/auxdata.R_sun_mars - 1/a_transfer));

% 出発ΔV
delta_v_departure = v_transfer_earth - v_earth_orbit;

% 到着ΔV
delta_v_arrival = v_mars_orbit - v_transfer_mars;

% ΔVの合計
delta_v_total = delta_v_departure + delta_v_arrival;

% 結果を表示
disp(['解析解: 地球出発時の ΔV = ', num2str(delta_v_departure * lsf / tsf), ' km/s'])
disp(['解析解: 火星到着時の ΔV = ', num2str(delta_v_arrival * lsf / tsf), ' km/s'])
disp(['解析解: ホーマン遷移軌道の ΔV = ', num2str(delta_v_total * lsf / tsf), ' km/s'])