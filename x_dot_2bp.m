%% 太陽中心のCR3BPの運動方程式
function dydt = x_dot_2bp(t, y, auxdata)
    % auxdataから変数を呼び出す
    mu_sun = auxdata.mu_sun;

    % 状態ベクトルの分割
    r_sun_sc = y(1:3);% 太陽から見た時の宇宙機の位置
    v_sun_sc = y(4:6);% 太陽から見た時の宇宙機の速度

    % 加速度の計算
    a_sun    = - mu_sun  / norm(r_sun_sc)^3 * r_sun_sc;

    % 微分方程式の設定
    dydt = [v_sun_sc; a_sun];
end
