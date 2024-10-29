%% 定数の定義（kmやkgなどの単位で定義）
g0_km_s2         = 9.8e-3;       % 重力定数 (km/s^2)
M_earth_kg       = 5.972e24;     % 地球の質量 (kg)
R_sun_earth_km   = 1.496e8;      % 太陽と地球の平均距離 (km)
R_sun_mars_km    = 227936640; % 火星の公転軌道半径 (km)
R_earth_km       = 6371;         % 地球の半径（km）
R_sun_km         = 6.960e5;      % 太陽の半径（km）
R_mars_km        = 6734;         % 火星の半径（km）
day_to_sec       = 60*60*24;     % 1日の秒数
earth_rev_days   = 3.652E+02;    % 地球の公転周期（日）

%% スケーリングファクターを適用
g0               = g0_km_s2 * tsf^2 / lsf; % 重力定数（スケーリング後）
R_sun_earth      = R_sun_earth_km / lsf;   % 太陽と地球の距離（スケーリング後）
R_sun_mars       = R_sun_mars_km  / lsf;   % 太陽と火星の距離（スケーリング後）
R_earth          = R_earth_km / lsf;       % 地球の半径（スケーリング後）
R_sun            = R_sun_km / lsf;         % 太陽の半径（スケーリング後）
R_mars           = R_mars_km / lsf;        % 火星の半径（スケーリング後）

%% 定数の計算（lsf, tsfでスケーリング）
mu_earth         = 398600.4418 / (lsf^3 / tsf^2); % 地球の重力定数（スケーリング後）
mu_sun           = 1.327124e+11 / (lsf^3 / tsf^2); % 太陽の重力定数（スケーリング後）
mu_se            = mu_earth / (mu_earth + mu_sun); % 地球と太陽の重力定数の比
omega            = sqrt((mu_sun + mu_earth) / R_sun_earth^3); % 角速度（rad/s）

%% auxdataに定数を格納
auxdata.lsf             = lsf;
auxdata.tsf             = tsf;
auxdata.g0              = g0;
auxdata.M_earth         = M_earth_kg;
auxdata.R_sun_earth     = R_sun_earth;
auxdata.R_sun_mars      = R_sun_mars;
auxdata.R_sun           = R_sun;
auxdata.R_earth         = R_earth;
auxdata.R_mars          = R_mars;
auxdata.R_earth_km      = R_earth_km;
auxdata.R_mars_km       = R_mars_km;
auxdata.R_sun_km        = R_sun_km;
auxdata.R_sun_earth_km  = R_sun_earth_km;
auxdata.R_sun_mars_km   = R_sun_mars_km;
auxdata.mu_earth        = mu_earth;
auxdata.mu_sun          = mu_sun;
auxdata.mu_se           = mu_se;
auxdata.omega           = omega;
auxdata.day_to_sec      = day_to_sec;
auxdata.earth_rev_days  = earth_rev_days;

% その他のパラメータをauxdataに格納
auxdata.N               = N;
auxdata.coeff_obj       = coeff_obj;
auxdata.y_node_int_all  = y_node_int_all;
auxdata.u_node_int_all  = u_node_int_all;

% ODE solver options
options = odeset('RelTol', 1e-8, 'AbsTol', 1e-8);
auxdata.options = options;