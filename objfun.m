% objfun
function [L, gradL] = objfun(y, auxdata)
    N = auxdata.N;
    u_node = reshape(y(6*N+1:6*N+4*N), 4, N)'; % N×4の行列
    thrust_node = u_node(:, 1:3);
    coeff_obj = auxdata.coeff_obj;
    
    % 目的関数の計算
    L = coeff_obj * sum(sum(thrust_node.^2)); % 燃料最適化したいときに付ける

    % ヤコビ行列（勾配）の計算
    gradL = zeros(size(y));
    gradL(6*N+1:6*N+3*N) = 2 * coeff_obj * reshape(thrust_node', [], 1);
end