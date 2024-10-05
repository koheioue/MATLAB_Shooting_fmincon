% objfun
function [L] = objfun(y, auxdata)
    N = auxdata.N;
    u_node     = reshape(y(6*(N)+1:6*(N)+4*N),4,N)'/auxdata.coeff_u;% N×4の行列
    thrust_node = u_node(:,1:3);
    coeff_obj = auxdata.coeff_obj;
%     L = 1;% 燃料最小化ではなく、境界条件を達成するだけの問題のときはこちら。 
    L = coeff_obj*sum(sum(thrust_node.^2)); % 燃料最適化したいときに付ける
end