function number_kmols = kmol(m,MW)
% calculate mols of water in the RPV for use in ideal gas law

% args: Mass, molecular weight
% returns: Mols of element
number_kmols = m/MW;    % returns number of kmols