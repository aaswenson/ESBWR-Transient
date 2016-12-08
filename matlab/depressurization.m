%% Coolant Rejection from RPV
% This script analyzes coolant rejection from the ESBWR RPV in a main FW
% full break LOCA.
% 
% This script determines the time to reactor depressurization in the LOCA
% and inventories lost coolant as the reactor levels out at atmospheric
% pressure.
clc; clear; clf;
global RV_T 
%% Parameters

% Geometric Parameters (from NRC Design Certification Book 5)
% Volume of Fluid
V_UP = 281;                % upper plenum volume [m^3]
V_LP = 101;                % lower plenum volume [m^3]
V_core = 96;              % core volume [m^3]
V_dome = 225;              % dome volume [m^3]
V_DC = 256;               % downcomer volume [m^3]


V_RPV = V_UP + V_LP + V_core + V_dome + V_DC; % total RPV volume

D_FW = 0.65;                % main feedwater diameter [m]
A_c = pi*D_FW^2/4;             % cross sectional area FW [m^2]
C_d = 0.8;                  % discharge coefficient [-] (GL Wells, Major Hazards and their Management)

%Thermophysical Parameters

T_ave = 493.9;              % average coolant temperature in RPV [K]
P_init = 7170;              % intial RPV pressure [kPa]
P_atm = 101;                % atmospheric pressure [kPa]
k = 1.311;                  % cp/cv (from EES @ T_ave) [kJ/kg-K]
R = 8.3144598;              % ideal gas constant [kJ/k-kmol]
rho_init = 31.46;           % intial coolant density [kg/m^3]
mass_init = rho_init*V_RPV; % intial coolant mass [kg]
RV_T = R*T_ave/V_RPV;


%% Model Parameters

h = 0.1;                     % time step [s]

t(1) = 0;
i = 1;
m_save = [mass_init];
rho_save = [rho_init];
P_save = [P_init];



%% Finite Differences

while P_save(i) > P_atm;
    P = pressure(m_save(i));
    P_save = [P_save;P];
    rho = m_save(i)/V_RPV;
    rho_save = [rho_save;rho];
    m = m_save(i) - dmdt(pressure(m_save(i)),rho_save(i),A_c,C_d,k)*h;
    m_save = [m_save;m];
    t(i+1) = h*i;
    i = i + 1;
   
end

%% Plots 
figure(1)
plot(t,P_save,'-bl')
figure(2)
plot(t,m_save,'-r')














