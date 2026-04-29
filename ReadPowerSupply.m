%{
 libm2k API documentation: https://analogdevicesinc.github.io/libm2k/index.html
 libm2k toolbox download: https://www.mathworks.com/matlabcentral/fileexchange/74385-libm2k-matlab
 Analog Device ADALM-2000 with MATLAB: https://wiki.analog.com/university/tools/m2k/matlab

 To set up the programming environment for interfacing ADALM-2000 using
 MATLAB, please follow these steps:
    1. Download MATLAB 2024b (you must use the 2024b version).
    2. Download the M2K driver on your computer.
    (https://wiki.analog.com/university/tools/pluto/drivers/windows)
    3. Download libm2k toolbox.
    4. Add the libm2k library folder to the MATLAB search path.
 
 Please refer to the document, "Libm2k library Setup in MATLAB 2024b.pdf", for 
 more details regarding step 3 and step 4.


 This script will check if you have set up the environment correctly. 
 The program will:
 1. Create an ADALM-2000 (m2k) object
 2. Set the Power Supply (V+) to 1.7V
 3. Use Analog Input 1 (1+) to read the power supply voltage
 4. Plot the power supply voltage
 4. Clear the m2k object

 Before running this program, please connect:
 1+ to V+
 1- to GND
%}

clear
% clib stands for c library, m2k is a pointer to the m2k object
m2k = clib.libm2k.libm2k.context.m2kOpen();
pause(1)

% check m2k connectivity
if clibIsNull(m2k)
    clib.libm2k.libm2k.context.contextCloseAll();
    clear m2k
    error("m2k object is null, please restart MATLAB, check device connection or check search path")
end

% retrieve analog input object and power supply object
analogInputObj = m2k.getAnalogIn();
powerSupplyObj = m2k.getPowerSupply();

% calibrate ADC and DAC
% the readings could be off if these two lines are not included
m2k.calibrateADC();
m2k.calibrateDAC();

% enable power supply channel 0 (V+)
powerSupplyObj.enableChannel(0,true);

% set the voltage on V+ to 1.7V
powerSupplyObj.pushChannel(0,1.7);

% enable analog input channel 0 (1+, 1-)
analogInputObj.enableChannel(0,true)
% read the voltage between 1+ and 1- and display it
disp(analogInputObj.getVoltage(0))

% number of samples to read from each channel
numOfSample = 1024;

% getSamplesInterleaved_matlab() reads voltages from both channels
% get 1024 samples from both channels
% the returned array, clibSamples, is a read-only array
% the clibSamples array includes 2048 data points
% the odd indices, clibSamples([1, 3, 5, ...]) are voltage readings from channel 1 (readings between 1+ and 1-)
% the even indices, clibSamples([2, 4, 6, ...]) are voltage readings from channel 2 (readings between 2+ and 2-)
clibSamples = analogInputObj.getSamplesInterleaved_matlab(numOfSample * 2);

% copy voltage readings from channel 1 to sampleArr
% sampleArr(1) = clibSamples(1)
% sampleArr(2) = clibSamples(3)
% sampleArr(3) = clibSamples(5), etc.
clibSamplesArray = double(clibSamples);
sampleArr = clibSamplesArray(1:2:end);

% plot both arrays
plot(clibSamples)
hold on
x = 1:2:(numOfSample * 2);
plot(x, sampleArr)
title("Voltage Plot");
xlabel("Time Index");
ylabel("Voltage (V)");
legend("Readings from both Channel 1 and Channel 2", "Readings from Channel 1 only")

% clear m2k object
clib.libm2k.libm2k.context.contextCloseAll();
clear m2k
