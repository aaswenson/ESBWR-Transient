%% Coolant Rejection from RPV
% This script analyzes coolant rejection from the ESBWR RPV in a main FW
% full break LOCA.
% 
% This script determines the time to reactor depressurization in the LOCA
% and inventories lost coolant as the reactor levels out at atmospheric
% pressure.
clc; clear; clf;
global RV_T rho_water V_RPV RT
%% Parameters

% Geometric Parameters (from NRC Design Certification Book 5)
% Volume of lower plenum, core, chimney, upper plenum, and dome
% respectively [m^3]
V_components = [101 96 173.8 107.2 225 256];
V_RPV = sum(V_components);  % total RPV volume [m^3]
D_FW = 0.65;                % main feedwater diameter [m]
A_c = pi*D_FW^2/4;          % cross sectional area FW [m^2]

%% Initial Liquid Water Inventory 

H_z_liquid = [4.13 3.77 6.61 2.75 0 14.5]; % equivalent liquid levels in each component
elevations = [0,4.13,7.9,14.5,24.8,27.6]; % elevations of
% Lower plenum, core, chimney, upper plenum, dome and top of RPV
% respectively [m]

% calculate the height (z [m]) of each component
H_z_components = elevations(2:length(elevations)) - elevations(1:length(elevations)-1);
H_z_components = [H_z_components 14.15];
% calculate total liquid volume in core
frac_liquid = H_z_liquid./H_z_components;
V_liquid_init = sum(frac_liquid.*V_components);



%% Thermophysical Parameters

T_ave = 493.9;              % average coolant temperature in RPV [K]
MW_air = 32;                    % molecular mass of air [kg/kmol] 
P_init = 7170;              % intial RPV pressure [kPa]
P_atm = 101;                % atmospheric pressure [kPa]
k = 1.311;                  % cp/cv (from EES @ T_ave) [kJ/kg-K]
R = 8.3144598;              % ideal gas constant [kJ/k-kmol]
rho_water = 1000;           % intial coolant density [kg/m^3]
mass_water_init = rho_water*V_RPV; % intial coolant mass [kg]
RV_T = R*T_ave/V_RPV;
RT = R*T_ave;               % useful constant
C_d = 0.8;                  % discharge coefficient [-] (GL Wells, Major Hazards and their Management)

%% Initial Gas Inventory 
% total gas volume in core
V_air_init = V_RPV - V_liquid_init;
% use ideal gas law to determine mass of air
n_air = P_init/RV_T;
mass_air_init = mass(n_air,MW_air);

%% Model Parameters

h = 0.1;                     % time step [s]

t(1) = 0;
i = 1;
mass_water = [mass_water_init];
rho_air = [mass_air_init/V_air_init];
P_save = [P_init];

%% Finite Differences

while P_save(i) > P_atm && mass_water(i) > 0;
    
    dm = dmdt(P_save(i),A_c,P_atm)*h;
    mass_water = [mass_water ;(mass_water(i) - dm)];
    vol_air = air_vol_RPV(mass_water(i+1));
    p  = pressure(mass_air_init,MW_air,vol_air);
    P_save = [P_save; p];
    i = i + 1;
    t(i) = t(i-1) + i*h;
    
end

%% Plots 
figure(1)
plot(t,P_save,'-bl')
figure(2)
plot(t,mass_water,'-r')














