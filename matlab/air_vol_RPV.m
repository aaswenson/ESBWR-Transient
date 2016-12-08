function volume_gas_RPV = air_vol_RPV(mass_water)

% calculate the volume of air in the RPV given a mass of liquid

global V_RPV rho_water

volume_gas_RPV = V_RPV - (mass_water/rho_water);