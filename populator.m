% Clean up
system('rm -rf run_array');
system('rm -f run_script.com');
%% Options
hpc = 1; % Yield HPC script if 1
multiplicate = 1; % multiplicate each dimension up if 1

%% Parameters
param_names = {'min_wid','wid_ratio','depth'};
param_values = {[0.002,0.005,0.007,0.010,0.015],[1.05,1.10,1.15,1.20,1.30,1.40,1.50,1.70,2.00],[7000,10000]};

%% Check inputs
if ~(length(param_names) == length(param_values))
    error('Number of variables mismatch!');
end
tmp = [];
for i=1:length(param_values)
    tmp(end+1) = length(param_values);
end
if (multiplicate==0) && (length(unique(tmp))>1)
    error('Multiplicate is not on and the dimensions of parameter values do not match');
end

%% Script generation
fid = fopen('run_script.com','w');
mkdir('run_array');
lines = {
'#!/bin/bash\n',
'#SBATCH --time=72:00:00\n',
'#SBATCH --ntasks=1\n',
'#SBATCH --nodes=1\n',
'#SBATCH -J "Enceladus-Plumes"\n',
% '#SBATCH --mail-user=sihechen@caltech.edu\n',
% '#SBATCH --mail-type=FAIL\n',
'## /SBATCH -p general # partition (queue)\n',
'## /SBATCH -o slurm.%%N.%%j.out # STDOUT\n',
'## /SBATCH -e slurm.%%N.%%j.err # STDERR\n',
'module load matlab/r2020b \n',
'cp /home/sihechen/csh/Enceladus/2022_Jun_23_Single_Func_Solver/*.m ./',
'matlab -nodisplay -r "composed_main_func(min_wid,wid_ratio,depth); exit;" \n'};
file_list = file_array_generator(lines,param_names,param_values,'run_array/run',hpc);
for i=1:length(file_list)
    fprintf(fid,strcat('cd',32,file_list{i},'\n'));
    tmp = split(file_list{i},'/');
    filn = tmp{end};
    if hpc==1
        fprintf(fid,strcat('sbatch',32,filn,'.sub\n'));
    else
        fprintf(fid,strcat('./',filn,'.sh\n'));
    end
    fprintf(fid,'cd ../../\n');
    fprintf(fid,'\n');
end
fclose(fid);

