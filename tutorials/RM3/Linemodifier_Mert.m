tic
clear
Value1 = input('Enter the value for wave height (H): ');
Value2 = input('Enter the value for wave period (T): ');

filename = 'wecSimInputFile.m';

% Read the file into a cell array
fileContent = {};
fid = fopen(filename, 'r');
tline = fgetl(fid);
while ischar(tline)
    fileContent{end+1} = tline;
    tline = fgetl(fid);
end
fclose(fid);
scale=1;
% Modify lines 85 and 86 with new wave height and period
fileContent{85} = sprintf('waves.H = scale*%g/Ls;', Value1);
fileContent{86} = sprintf('waves.T = sqrt(scale)*%g/Tsc;', Value2);

% Write the modified content back to the file
fid = fopen(filename, 'w');
for i = 1:length(fileContent)
    fprintf(fid, '%s\n', fileContent{i});
end
fclose(fid);

disp('Successfully updated waves.H and waves.T in wecSimInputFile.m');

wecSim;
% Create a folder named HValue1_TValue2
folder_name = sprintf('H%g_T%g', Value1, Value2);
if ~exist(folder_name, 'dir')
    mkdir(folder_name);
    disp(['Folder created: ', folder_name]);
else
    disp(['Folder already exists: ', folder_name]);
end

% Save Body_out1 in both the current directory and the new folder
if exist('body1_out', 'var')
    % Save in the current directory
    filename_save_current = sprintf('ex_1_H%g_T%g.mat', Value1, Value2);
    save(filename_save_current, 'body1_out');
    disp(['Body_out1 has been saved as ', filename_save_current, ' in the current directory.']);

    % Save in the new folder
    save(fullfile(folder_name, 'body1_out.mat'), 'body1_out');
    disp(['Body_out1 has been saved in folder ', folder_name]);
else
    disp('Body_out1 does not exist in the workspace. Make sure to run the simulation first.');
end

% Now rewrite line 1 of Wave_Analysis_WEC_Sim.m
wave_analysis_filename = 'Wave_Analysis_WEC_Sim.m';

% Read the file into a cell array
fileContent = {};
fid = fopen(wave_analysis_filename, 'r');
tline = fgetl(fid);
while ischar(tline)
    fileContent{end+1} = tline;
    tline = fgetl(fid);
end
fclose(fid);

% Create the new line to load the correct .mat file
new_line = sprintf('load ex_1_H%g_T%g.mat', Value1, Value2);

% Modify line 1
fileContent{1} = new_line;

% Write the modified content back to the file
fid = fopen(wave_analysis_filename, 'w');
for i = 1:length(fileContent)
    fprintf(fid, '%s\n', fileContent{i});
end
fclose(fid);

disp('Successfully updated line 1 in Wave_Analysis_WEC_Sim.m');
wecSim;

% Save other variables (simout, simout1, simout2, simout3, simout4, simout5) into the folder
variables_to_save = {'simout', 'simout1', 'simout2', 'simout3', 'simout4', 'simout5','body1_out'};

for i = 1:length(variables_to_save)
    if exist(variables_to_save{i}, 'var')
        save(fullfile(folder_name, [variables_to_save{i}, '.mat']), variables_to_save{i});
        disp([variables_to_save{i}, ' has been saved in folder ', folder_name]);
    else
        disp([variables_to_save{i}, ' does not exist in the workspace.']);
    end
end

a=cumsum(-simout.data.*simout1.data*5e-4);a(end) % Generator Terminal Power
a=cumsum(-simout.data.*simout2.data*5e-4);a(end) % Back EMF Terminal Power
a=cumsum(simout4.data*5e-4);a(end) % Mechanical Power
toc

format bank
a=cumsum(simout4.data*5e-4);a(end)
mech_en=a;
tt=find(abs(simout4.time-300)<5e-4);
P_Ave=(mech_en(end)-mech_en(end-tt(1)))/simout4.time(tt(1));
Average_Mechanical_Power=P_Ave*15^3.5

elec_pw=-simout.data.*simout1.data;
elec_en=cumsum(elec_pw*5e-4);elec_en(end)
PE_Ave=(elec_en(end)-elec_en(end-tt(1)))/simout4.time(tt(1));
Average_Elec_Power=PE_Ave*15^3.5
Average_Elec_Power/Average_Mechanical_Power