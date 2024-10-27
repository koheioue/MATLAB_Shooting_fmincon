function [c, ceq] = confun(y, auxdata)

N = auxdata.N;
options = auxdata.options;
x_node_int = reshape(y(1:6*(N)),6,N)';% (N)×6の行列
u_node     = reshape(y(6*(N)+1:6*(N)+4*N),4,N)'/auxdata.coeff_u;% N×4の行列
T_sum = [cumsum(u_node(1:N, 4))];% 0, T1, T1+T2, ...のベクトル

ceq_node = [auxdata.y_node_int_all(1,1:6)-x_node_int(1,:)];
x_all_plot = [];

for rev = 1 : N-1
    tspan   = [T_sum(rev) T_sum(rev+1)];
    x0 = [x_node_int(rev,1:3), x_node_int(rev,4:6)+u_node(rev,1:3)];
    [t, x] = ode45(@(t, x) x_dot_2bp(t, x, auxdata), tspan, x0, options);
    x_all_plot = [x_all_plot;x];
    ceq_node = [ceq_node;x(end,:)-x_node_int(rev+1,:)];
end
ceq_node = [ceq_node;x(end,1:3)-auxdata.x_target(1:3), x(end,4:6)+u_node(N, 1:3)-auxdata.x_target(4:6)];
ceq = reshape(ceq_node', [], 1);% 等式制約
c = [];% 不等式制約は今回無し

figure(1)
% close
axis equal
% 太陽をプロットする（大きさは、半径R_sunを使用）（2次元平面で）
theta = linspace(0, 2*pi, 20);
x_sun = auxdata.R_sun * cos(theta);
y_sun = auxdata.R_sun * sin(theta);
fill(x_sun, y_sun, 'r', 'FaceAlpha', 0.5, 'EdgeColor', 'k', 'LineWidth', 2)
hold on
plot(x_all_plot(:,1), x_all_plot(:,2), Color=[1,0,0], LineWidth=2)% 軌道を赤線で描画
hold on
plot(x_node_int(:,1), x_node_int(:,2), 'b*', MarkerSize=10)

end