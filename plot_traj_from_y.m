% yを受け取って、それから軌道を描画します。
close all
if flag_opt == 0
    y_plot = y0;
elseif flag_opt == 1
    y_plot = yopt;
end

x_node     = reshape(y_plot(1:6*(N)),6,N)';% (N)×6の行列
u_node     = reshape(y_plot(6*(N)+1:6*(N)+4*N),4,N)'/auxdata.coeff_u;% N×4の行列
T_sum = [cumsum(u_node(1:N, 4))];% 0, T1, T1+T2, ...のベクトル

x_all_plot = [];
x_node_end = [];
options = auxdata.options;

figure(1)
axis equal
grid on
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
plot(x_node(1,1), x_node(1,2), 'r*', MarkerSize=10, LineWidth=2)
hold on

for node_num = 1 : N-1
    tspan   = [T_sum(node_num) T_sum(node_num+1)];
    x0 = [x_node(node_num,1:3), x_node(node_num,4:6)+u_node(node_num,1:3)];
    [t, x] = ode45(@(t, x) x_dot_2bp(t, x, auxdata), tspan, x0, options);
    x_all_plot = [x_all_plot;x];
    x_node_end = [x_node_end;x(end,:)];
    figure(1)
    hold on
    plot(x(:,1), x(:,2), Color=[1,0,0], LineWidth=2)% 軌道を赤線で描画
    hold on
    plot(x0(1), x0(2), 'r*', MarkerSize=5, LineWidth=2)% 軌道の始点は赤*
    hold on
    plot(x(end), x(end), 'b*', MarkerSize=5, LineWidth=2)% 軌道の終点は青*
    hold on
    quiver(x_node(node_num,1), x_node(node_num,2), 1e7*u_node(node_num,1), 1e7*u_node(node_num,2), 'LineWidth', 2, 'MaxHeadSize',20, Color=[0 0 0])
    hold on
end
quiver(x_node(N,1), x_node(N,2), 1e7*u_node(N,1), 1e7*u_node(N,2), 'LineWidth', 2, 'MaxHeadSize',20, Color=[0 0 0])


% figure(1)
% axis equal
% grid on
% % 太陽をプロットする（大きさは、半径R_sunを使用）（2次元平面で）
% theta = linspace(0, 2*pi, 100);
% x_sun = auxdata.R_sun_km * cos(theta);
% y_sun = auxdata.R_sun_km * sin(theta);
% fill(x_sun, y_sun, 'r', 'FaceAlpha', 0.5, 'EdgeColor', 'k', 'LineWidth', 2)
% hold on
% % 火星をプロット
% plot(x_all_plot(:,1), x_all_plot(:,2), Color=[1,0,0], LineWidth=2)% 軌道を赤線で描画
% hold on
% plot(x_node(1,1), x_node(1,2), 'r*', MarkerSize=10, LineWidth=2)
% plot(x_node(2:end,1), x_node(2:end,2), 'r*', MarkerSize=5, LineWidth=2)
% plot(x_node_end(:,1), x_node_end(:,2), 'b*', MarkerSize=5, LineWidth=2)
% 
% for i = 1 : N
%     quiver(x_node(i,1), x_node(i,2), u_node(i,1), u_node(i,2), 10, "filled")
% end


%% ΔVの合計  km/s
delta_v = u_node(:, 1:3);
delta_v_sum_km_s = sum(vecnorm(delta_v, 2, 2)); 
disp(['Delta V sum = ', num2str(delta_v_sum_km_s), ' km/s'])