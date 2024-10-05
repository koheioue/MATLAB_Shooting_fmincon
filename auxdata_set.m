g0 = 9.8e-3; % #= km/s^2 =#
M_earth  = 5.972e24; % 太陽の質量 (kg)
R_sun_earth = 1.496e8; % 太陽と地球の距離 (km)
R_earth_km  = 6371; % 地球の半径 (km)
R_sun_km = 6.960e5;  % 太陽の半径（km）
R_mars_km = 6734;% km 火星の直径
day_to_sec = 60*60*24;
earth_rev_days = 3.652E+02; % days 地球の公転周期

%% 定数の計算
mu_earth = 398600.4418; % GM of the Earth（地球の重力定数）=# km^3/s^2 =#
mu_sun = 1.327124e+11; % GM of the Sun（太陽の重力定数）=# km^3/s^2 =#
mu_se = mu_earth/(mu_earth + mu_sun);
omega = sqrt((mu_sun + mu_earth) / R_sun_earth^3);

auxdata.g0 = g0;
auxdata.M_earth = M_earth;
auxdata.R_sun_earth = R_sun_earth;
auxdata.R_earth_km = R_earth_km;
auxdata.R_mars_km = R_mars_km;
auxdata.R_sun_km = R_sun_km;
auxdata.mu_earth = mu_earth;
auxdata.mu_sun = mu_sun;
auxdata.mu_se = mu_se;
auxdata.omega = omega;
options = odeset('RelTol',1e-8,'AbsTol',1e-8);
auxdata.options = options;
auxdata.day_to_sec = day_to_sec;

auxdata.N = N;
auxdata.coeff_obj = coeff_obj;
auxdata.y_node_int_all = y_node_int_all;
auxdata.u_node_int_all = u_node_int_all;