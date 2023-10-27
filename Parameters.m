%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% ---------------------- BATTERY PARAMETERS ----------------------- %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This script allows you to load the battery parameters 
% from the .mat files obtained from the HPPC tests into the workspace.


%% Initialization
% Clear and close
clc; clear all; close all;


%% Loading data parameters from test

% File's names
file_batt_name = {'Cell_1RC_20231018', 'Cell_1RC_20231026', ...
             'Cell_2RC_20230929', 'Cell_2RC_20231026', ...
             'Block_2RC_20230929', 'Block_2RC_20231006', ...
             'Block_2RC_20231010', 'Block_2RC_20231017'}; 

% File directory
file_batt_path = {'Battery_parameters/Cell_1RC_20231018.mat', ...
             'Battery_parameters/Cell_1RC_20231026.mat', ...
             'Battery_parameters/Cell_2RC_20230929.mat', ...
             'Battery_parameters/Cell_2RC_20231026.mat', ...
             'Battery_parameters/Block_2RC_20230929.mat', ...
             'Battery_parameters/Block_2RC_20231006.mat', ...
             'Battery_parameters/Block_2RC_20231010.mat', ...
             'Battery_parameters/Block_2RC_20231017.mat'};

% User select a file
fileIndex_batt = listdlg('PromptString', {'Select a file to extract data from:', ''}, ...
                    'ListString', file_batt_name, 'SelectionMode', 'single');

if isempty(fileIndex_batt)
    disp('No selection made. The program terminates.');
else
    switch fileIndex_batt
    case {1, 2} 
        file_batt_name = file_batt_path{1};
        loadedData = load(file_batt_name);
        Data_Cell = loadedData.battParameters;

        AH_cell = 3000;
        Initial_SOC = 0.8;
        SOC_cell = table2array(Data_Cell{:,3}(:,1));
        V0_cell = table2array(Data_Cell{:,3}(:,2));
        R0_charge_cell = table2array(Data_Cell{:,3}(:,3));

        % for i = 1:length(R0_charge_cell)
        %     if R0_charge_cell(i) < 0
        %         R0_charge_cell(i) = eps;
        %     end
        % end

        R0_discharge_cell = table2array(Data_Cell{:,3}(:,4));
        R_leak_cell = 8000;
        R1_cell = table2array(Data_Cell{:,3}(:,5));
        Tau1_cell = table2array(Data_Cell{:,3}(:,6));

    case {3, 4}
        file_batt_name = file_batt_path{3};
        loadedData = load(file_batt_name);
        Data_Cell = loadedData.battParameters;

        AH_cell = 3000; 
        Initial_SOC = 0.8;
        SOC_cell = table2array(Data_Cell{:,3}(:,1));
        V0_cell = table2array(Data_Cell{:,3}(:,2));
        R0_charge_cell = table2array(Data_Cell{:,3}(:,3));

        % for i = 1:length(R0_charge_cell)
        %     if R0_charge_cell(i) < 0
        %         R0_charge_cell(i) = eps;
        %     end
        % end

        R0_discharge_cell = table2array(Data_Cell{:,3}(:,4));
        R_leak_cell = 8000;
        R1_cell = table2array(Data_Cell{:,3}(:,5));
        Tau1_cell = table2array(Data_Cell{:,3}(:,6));
        R2_cell = table2array(Data_Cell{:,3}(:,7));
        Tau2_cell = table2array(Data_Cell{:,3}(:,8));

     case {5, 6, 7, 8}
        file_batt_name = file_batt_path{5};
        loadedData = load(file_batt_name);
        Data_Block = loadedData.battParameters;
        
        AH_block = 14000;   
        Initial_SOC = 0.8;
        SOC_block = table2array(Data_Block{:,3}(:,1));
        V0_block = table2array(Data_Block{:,3}(:,2));
        R0_charge_block = table2array(Data_Block{:,3}(:,3));
        R0_discharge_block = table2array(Data_Block{:,3}(:,4));
        R_leak_block = 16000;
        R1_block = table2array(Data_Block{:,3}(:,5));
        Tau1_block = table2array(Data_Block{:,3}(:,6));
        R2_block = table2array(Data_Block{:,3}(:,7));
        Tau2_block = table2array(Data_Block{:,3}(:,8))*2;

    otherwise
        error('Wrong selection battery.');
    end
end



%% Import data from Telemetry

% File's names
file_telemetry_name = {'2023_07_24', 'No Data', ...
                       'No Data', 'No Data', ...
                       'No Data', 'No Data'}; 

% User select a file
fileIndex_tel = listdlg('PromptString', {'Select Telemetry:', ''}, ...
                    'ListString', file_telemetry_name, 'SelectionMode', 'single');


if isempty(fileIndex_tel)
    disp('No selection made. The program terminates.');
else
    switch fileIndex_tel
    case 1
       % hv_voltage data
       folder = '../Battery_Pack/Telemetry_data/2023_07_24/hv_voltage.csv';
       file_path_vol = fullfile(folder);
    
       % hv_current data
       folder = '../Battery_Pack/Telemetry_data/2023_07_24/hv_current.csv';
       file_path_curr = fullfile(folder);

    case 2
              % hv_voltage data
       folder = '../Battery_Pack/Telemetry_data/2023_07_24/hv_voltage.csv';
       file_path_vol = fullfile(folder);
    
       % hv_current data
       folder = '../Battery_Pack/Telemetry_data/2023_07_24/hv_current.csv';
       file_path_curr = fullfile(folder);

    otherwise
        error('Wrong selection telemetry.');
    end
end

% Automatic detect import options
opts = detectImportOptions(file_path_vol);
opts.PreserveVariableNames=true;
HV_Voltage = readtable(file_path_vol,opts);     % Import the voltage data
clear opts                                  % Clear temporary variables

% Automatic detect import options
opts = detectImportOptions(file_path_curr);
opts.PreserveVariableNames=true;
HV_Current = readtable(file_path_curr,opts);     % Import the current data
clear opts 

% Correcting the sampling time for voltage
start_voltage = table2array(HV_Voltage(1,1));                % Time 0
time_voltage = (HV_Voltage{:,1} - start_voltage).*10^(-6);   % Total_time
Telemetry_voltage = HV_Voltage.pack_voltage;

% Correcting the sampling time for current
start_current = table2array(HV_Current(1,1));                % Time 0
time_current = (HV_Current{:,1} - start_current).*10^(-6);   % Total_time
Telemetry_current = (HV_Current.current).*(-1);

% Correct any possible offset
for i = 1:length(Telemetry_current)
    if Telemetry_current(i) > -1.5 && Telemetry_current(i) < 3.2
        Telemetry_current(i) = 0;
    end
end


%% Plots 

% Plot Telemetry Voltage
figure(1)
plot(time_voltage, Telemetry_voltage, "blue")
grid on
xlabel('Time (s)');
ylabel('Voltage (V)')
title('Pack Voltage')

% Plot Telemetry Current
figure(2)
plot(time_current, Telemetry_current, "red")
grid on
xlabel('Time (s)');
ylabel('Current (A)')
title('Pack Current')







