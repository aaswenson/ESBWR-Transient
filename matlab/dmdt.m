function mass_flow = dmdt(P,A_c,P_contain)

% determine the mass flow rate from choked flow

% args: pressure [kPa],density [kg/m^3], XS area [m^2] 
% returns: mass flow rate [kg/s]
global rho_water
P = P*1000;         % convert pressure to Pa
P_contain = P_contain*1000;
mass_flow = sqrt((2/rho_water)*(P - P_contain))*A_c*rho_water;