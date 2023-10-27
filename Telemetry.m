%% Telemetry 
% This script is divided into two sections:

% The first section enables the evaluation of voltage by extracting 
% data from the CSV, storing it, and ultimately creating a plot.

% The second section allows for the assessment of current, with data
% extraction from the CSV, data storage, and plot generation as well.


%% Clear all
% clc; clear all; close all;


%% Import data from csv file  *** VOLTAGE ***

% Script for importing data from the following HV_VOLTAGE file:
folder = '../Battery_Pack/Telemetry_data/2023_07_24/';
file = 'hv_voltage.csv';
file_path = fullfile(folder, file);

% Automatic detect import options
opts = detectImportOptions(file_path);
opts.PreserveVariableNames=true;

% Import the data
HV_Voltage = readtable(file_path,opts);

% Clear temporary variables
clear opts

% Correcting the sampling time
start_voltage = table2array(HV_Voltage(1,1));   % Time 0
time_voltage = (HV_Voltage{:,1} - start_voltage).*10^(-6);   % Total_time
Telemetry_voltage = HV_Voltage.pack_voltage;

% Plot data 
figure(1)
plot(time_voltage, Telemetry_voltage, "blue")
grid on
xlabel('Time (s)');
ylabel('Voltage (V)')
title('Pack Voltage')


%% Import data from csv file  *** CURRENT ***

% Script for importing data from the following HV_CURRENT file:
folder = '../Battery_Pack/Telemetry_data/2023_07_24/';
file = 'hv_current.csv';
file_path = fullfile(folder, file);

% Automatic detect import options
opts = detectImportOptions(file_path);
opts.PreserveVariableNames=true;

% Import the data
HV_Current = readtable(file_path,opts);

% Clear temporary variables
clear opts

% Correcting the sampling time
start_current = table2array(HV_Current(1,1));   % Time 0
time_current = (HV_Current{:,1} - start_current).*10^(-6);   % Total_time
Telemetry_current = (HV_Current.current).*(-1);

% for i = 1:length(Telemetry_current)
%     if Telemetry_current(i) > -1.5 && Telemetry_current(i) < 3.2
%        Telemetry_current(i) = 0;
%     end
% end

% Plot data 
figure(2)
plot(time_current, Telemetry_current, "red")
grid on
xlabel('Time (s)');
ylabel('Current (A)')
title('Pack Current')



%% Import data from csv file  *** VOLTAGE_SIMULATE ***

% Script for importing data from the following HV_VOLTAGE file:

folderPath = '../Battery_Pack/';
matFiles = dir(fullfile(folderPath, '*.mat'));

filePath = fullfile(folderPath, matFiles.name);
V_sim = struct2array(load(filePath))';

% Plot data 
figure(3)
plot(time_voltage, Telemetry_voltage, "blue")
hold on
plot(V_sim(:,1), V_sim(:,2), "red")
grid on
xlabel('Time (s)');
ylabel('Voltage (V)')
title('Pack Voltage')
legend('Telemetry\_Voltage', 'Simulation\_Voltage')
hold off



Initial_SOC = 0.8;