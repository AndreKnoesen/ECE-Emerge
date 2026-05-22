% This script tests the hardware of the scale project by measuring the
% output of the INA stage and the final ouput stage at 0g, 250g and 500g.

% The script will prompt the user to change the weight, then display the
% 3-point measurements through a graph.

% The script measures each weight for 1 second.

% Connections:
%   - a complete scale circuit
%   - V+, V- and GND to corresponding power supply pins
%   - CH1 (1+ & 1-) to final output 
%   - CH2 (2+ & 2-) to INA output (pin 10 or pin 11 of INA)

% calibrate M2K
clear;
avgArr = zeros(1, 3); % final output sample means for 0g, 250g, 500g
stdArr = zeros(1, 3); % standard deviation for 0g, 250g, 500g

fprintf("\n\n- Disconnect circuit from M2K.\n");
input('  - Press Enter to calibrate:', 's');
myM2K = M2K();                % create M2K object

% initiate M2K channels
fprintf("\n- Connect circuit with M2K.\n");
input('  - Press Enter to initiate M2K and measure 0g:', 's');
fprintf("  - Initiating channels...\n");
myM2K.enableAnalogIn(1);      % enable Ch1
myM2K.enableAnalogIn(2);      % enable Ch2
myM2K.enablePowerSupply(1);   % enable V+
myM2K.enablePowerSupply(2);   % enable V-

% set the ADC and DAC rates
ADCRate = 100000;        % ADC rate = 100kHz 
myM2K.setAnalogInSampleRate(ADCRate);

myM2K.setPowerSupply(1, 5);         % set V+ to 5V
myM2K.setPowerSupply(2, -5);        % set V- to -5V
fprintf("  - Done.");

% measure 0g
myM2K.clearAnalogInSampleBuffer();
fprintf("\n  - Acquiring 0g measurements...");
[t_received, ch1_samples, ch2_samples] = myM2K.getAnalogInSamples(1);
fprintf("\n  - Done");

t_displayed = t_received;
ch1_displayed = ch1_samples;
ch2_displayed = ch2_samples;

avgArr(1) = mean(ch1_samples);
stdArr(1) = std(ch1_samples);

% measure 250g
fprintf("\n\n- Put 250g on the scale.\n");
input('  - Press Enter to measure:', 's');
myM2K.clearAnalogInSampleBuffer();
fprintf("  - Acquiring 250g measurements...");
[t_received, ch1_samples, ch2_samples] = myM2K.getAnalogInSamples(1);
fprintf("\n  - Done");

t_displayed = [t_displayed, (t_received + 1)];
ch1_displayed = [ch1_displayed, ch1_samples];
ch2_displayed = [ch2_displayed, ch2_samples];

avgArr(2) = mean(ch1_samples);
stdArr(2) = std(ch1_samples);

% measure 500g
fprintf("\n\n- Put 500g on the scale.\n");
input('  - Press Enter to measure:', 's');
myM2K.clearAnalogInSampleBuffer();
fprintf("  - Acquiring 500g measurements...");
[t_received, ch1_samples, ch2_samples] = myM2K.getAnalogInSamples(1);
fprintf("\n  - Done\n");

t_displayed = [t_displayed, (t_received + 2)];
ch1_displayed = [ch1_displayed, ch1_samples];
ch2_displayed = [ch2_displayed, ch2_samples];

avgArr(3) = mean(ch1_samples);
stdArr(3) = std(ch1_samples);

% display results
figure;
plot(t_displayed, ch2_displayed, "LineWidth", 1.2);  hold on;
plot(t_displayed, ch1_displayed, "LineWidth", 1.2);
title(sprintf('Voltage Measurements (0g, 250g, 500g)'));
xlabel('Time (s)');
ylabel('Voltage (V)');
legend('Ch2 - (V_{INA})', 'Ch1 - (V_{out})');

fprintf("\n\nMean (in V) for 0g, 250g and 500g:\n");
disp(avgArr);
fprintf("\n\nStandard deviation (in V) for 0g, 250g and 500g:\n");
disp(stdArr);