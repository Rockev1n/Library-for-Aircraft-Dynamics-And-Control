function structurePlotEigenmode(structure,num_eigenmode,varargin)
% structurePlotEigenmode creates a 3D plot of the specified eigenmode and
% visualizes the structure deformation.
% 
% Inputs:
%   structure       structure struct as defined in
%                   structureCreateFromNastran or structureGetReduced
%   num_eigenmode  	number of the eigenmode that should be visualized
%                   (sorted by eigenfrequency)
% 

% Disclamer:
%   SPDX-License-Identifier: GPL-2.0-only
% 
%   Copyright (C) 2020-2022 Yannic Beyer
%   Copyright (C) 2022 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

% factor that amplifies the structure deformation
if isempty(varargin)
    factor = 1;
else
    factor = varargin{1};
end

% check if the eigenmodes have already been computed (save time)
fieldnames_ = fieldnames(structure);
modal_analysis_required = true;
for i = 1:length(fieldnames_)
    if strcmp(fieldnames_{i},'modal')
        if length(structure.modal.omega_red) >= num_eigenmode
            modal_analysis_required = false;
            break;
        end
    end
end
if modal_analysis_required
    structure_red = structureGetReduced(structure,num_eigenmode);
else
    structure_red = structure;
end

% compute new node positions
state_vector = structure_red.modal.T(:,num_eigenmode);
Delta_x = state_vector(1:6:end);
Delta_y = state_vector(2:6:end);
Delta_z = state_vector(3:6:end);
Delta_xyz = [Delta_x';Delta_y';Delta_z'] * factor;

% plot rigid structure (for comparison)
plot3(structure_red.xyz(1,:),structure_red.xyz(2,:),structure_red.xyz(3,:),'ko')

hold on

% plot deformed structure
structure.xyz = structure.xyz + Delta_xyz;
structurePlot(structure);

end
