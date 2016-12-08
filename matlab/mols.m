function mols_to_mass = mols(mm,MW)

% function to convert mols of a material to mass

% args: number of kmols, molecular weight [kg/kmol]
% returns: mass [kg]

mols_to_mass = mm*MW;