%{
 libm2k API documentation: https://analogdevicesinc.github.io/libm2k/index.html
 Analog Device ADALM-2000 with MATLAB: https://wiki.analog.com/university/tools/m2k/matlab
 MATLAB function: https://www.mathworks.com/help/matlab/ref/function.html
 MATLAB class definition: https://www.mathworks.com/help/matlab/matlab_oop/user-defined-classes.html
 App Designer: https://www.mathworks.com/help/matlab/app-designer.html
%}

classdef M2K 
    properties
        m2kObj;
        analogInputObj; % Ch1, Ch2
        powerSupplyObj; % V+, V-
        analogOutputObj; % W1, W2
    end

    methods
        % Constructor
        function obj = M2K()
            obj.m2kObj = obj.registerM2K();
            % retrieve analog input object 
            obj.analogInputObj = obj.m2kObj.getAnalogIn();
            % retrieve power supply object 
            obj.powerSupplyObj = obj.m2kObj.getPowerSupply();
            % retrieve analog output object 
            obj.analogOutputObj = obj.m2kObj.getAnalogOut();
            % set analog in kernel buffer and calibrate the M2K
            obj.calibrateM2K();
        end

        function clearM2K(obj)
            % clear m2k object
            clib.libm2k.libm2k.context.contextCloseAll();
            return
        end
        
        
        function m2k = registerM2K(obj)
            % clear existing m2k object
            obj.clearM2K();
            disp("Registering M2K port...");
            % clib stands for c library, m2k is a pointer to the m2k object
            m2k = clib.libm2k.libm2k.context.m2kOpen();
            pause(1)
        
            % check m2k connectivity
            if clibIsNull(m2k)
                clib.libm2k.libm2k.context.contextCloseAll();
                clear m2k
                error("m2k object is null, please restart MATLAB, check device connection or check search path")
            end
            disp("Done.");
            return
        end

        function calibrateM2K(obj)
            disp("Calibrating M2K...");
            % retrieve the current ADC rate
            original_ADC_rate = obj.getAnalogInSampleRate();
            % set ADC rate to at least 1 MSPS for calibration
            obj.setAnalogInSampleRate(1000000);
            pause(0.1);
            % calibrate ADC and DAC
            % the readings could be off if these two lines are not included
            obj.m2kObj.calibrateADC();
            obj.m2kObj.calibrateDAC();
            % set the ADC rate back to the original value
            obj.setAnalogInSampleRate(original_ADC_rate);
            disp("Done.");
            return
        end
        
        function enableAnalogIn(obj, channelNumber)
            % enable analog input channel 1 and 2
            if channelNumber == 1
                % ch1 is represented by index 0
                obj.analogInputObj.enableChannel(0,true);
            elseif channelNumber == 2
                obj.analogInputObj.enableChannel(1,true);
            else
                warning('enableAnalogIn: Invalid channel number.');
                return
            end
            return
        end
        
        function setAnalogInSampleRate(obj, ADC_rate)
            % analog input (ADC) sample rates: 1k, 10k, 100k, 1M, 10M, 100MSPS
            supportedRates = [1e3, 10e3, 100e3, 1e6, 10e6, 100e6];
            % Check if the input is a scalar, a number, and matches a valid rate
            if ~isscalar(ADC_rate) || ~isnumeric(ADC_rate)
                warning('setAnalogInSampleRate: ADC rate must be a single numeric value.\n');
                return
            elseif ~any(ADC_rate == supportedRates)
                warning('setAnalogInSampleRate: %d Hz is not a standard M2K ADC rate.\n', ADC_rate);
                warning('Common presets: 1k, 10k, 100k, 1M, 10M, 100M.\n');
                return
            end

            % set ADC sample rate for both Ch1 and Ch2
            % if sampleRate = 100k
            % this means the 1+/1-, 2+/2- channels will read 100k values in 1 second
            obj.analogInputObj.setSampleRate(ADC_rate); 
            obj.analogInputObj.enableChannel(0,true);
            pause(1)
            obj.analogInputObj.enableChannel(1,true);
            pause(1) % allow m2k to configure the sample rate
            % confirm the new ADC rate
            ADC_rate = obj.getAnalogInSampleRate();
            disp("Current ADC Rate: " + string(ADC_rate));
            return
        end

        function ADC_rate = getAnalogInSampleRate(obj)
            returned_rate = obj.analogInputObj.getSampleRate();
            ADC_rate = double(returned_rate);
            return
        end

        function clearAnalogInSampleBuffer(obj)
            % clear the buffer by reading
            % clibSamples = obj.analogInputObj.getSamplesInterleaved_matlab(100000);

            % the stop acquisition function destroys the kernel buffers
            obj.analogInputObj.stopAcquisition();
            return
        end

        function [t, ch1SampleArr, ch2SampleArr] = getAnalogInSamples(obj, seconds)
            % Inputs:
            %  - seconds: duration of the capture window in seconds
            % Outputs:
            %  - t: time vector (in seconds) of the retrieved samples
            %  - ch1SampleArr: samples read by Ch1
            %  - ch2SampleArr: samples read by Ch2

            if ~isnumeric(seconds)
                warning("getAnalogInSamples: seconds is not a number");
                return
            end

            ADCRate = obj.getAnalogInSampleRate();

            % getSamplesInterleaved_matlab() reads voltages from both channels
            % the returned array, clibSamples, is a read-only array
            % the odd indices, clibSamples([1, 3, 5, ...]) are voltage readings from channel 1 (readings between 1+ and 1-)
            % the even indices, clibSamples([2, 4, 6, ...]) are voltage readings from channel 2 (readings between 2+ and 2-)
            % the returned number of samples is multiple of 4 based on the API documentation
            clibSamples = obj.analogInputObj.getSamplesInterleaved_matlab(seconds * ADCRate * 2);
            
            % copy voltage readings from channel 1 to ch1SampleArr
            % ch1SampleArr(1) = clibSamples(1)
            % ch1SampleArr(2) = clibSamples(3)
            % ch1SampleArr(3) = clibSamples(5), etc.
            clibSamplesArray = double(clibSamples);
            ch1SampleArr = clibSamplesArray(1:2:end);
            ch2SampleArr = clibSamplesArray(2:2:end);

            num_of_samples = length(ch1SampleArr);
            t = (0:num_of_samples-1) / ADCRate;
            return
        end

        function enablePowerSupply(obj, supplyNumber)
            if supplyNumber == 1
                % enable power supply (V+)
                % (V+ is represented by index 0)
                obj.powerSupplyObj.enableChannel(0,true);
            elseif supplyNumber == 2
                % enable power supply (V-)
                % (V- is represented by index 1)
                obj.powerSupplyObj.enableChannel(1,true);
            else
                warning("enablePowerSupply: invalid supply number.");
                return
            end
            return
        end

        function setPowerSupply(obj, supplyNumber, voltage)
            if ~isnumeric(voltage)
                warning("setPowerSupply: voltage is not a number");
                return
            end

            % set the voltage on V+
            % (V+ is represented by index 0)
            if supplyNumber == 1
                supplyIdx = 0; % V+
            elseif supplyNumber == 2
                supplyIdx = 1; % V-
            else
                warning("setPowerSupply: invalid supply number");
                return
            end

            obj.powerSupplyObj.pushChannel(supplyIdx, voltage);

            return
        end

        function enableAnalogOut(obj, channelNumber)
            if channelNumber == 1
                % enable analog output channel W1 
                % (W1 is represented by index 0)
                obj.analogOutputObj.enableChannel(0,true);
            elseif channelNumber == 2
                % enable analog output channel W2 
                % (W2 is represented by index 1)
                obj.analogOutputObj.enableChannel(1,true);
            else
                warning("enableAnalogOut: invalid channel number");
                return
            end
            return
        end
        
        
        function setAnalogOutSampleRate(obj, DAC_rate)
            % analog output (DAC) sample rates: 750, 7.5k, 75k, 750k, 7.5M, 75MSPS
            supportedRates = [750, 7500, 75e3, 75e4, 75e5, 75e6];

            if ~isscalar(DAC_rate) || ~isnumeric(DAC_rate)
                warning('setAnalogOutSampleRate: DAC rate must be a single numeric value.\n');
                return
            elseif ~any(DAC_rate == supportedRates)
                warning('setAnalogOutSampleRate: %d Hz is not a standard M2K DAC rate.\n', DAC_rate);
                warning('Common presets: 750, 7.5k, 75k, 750k, 7.5M, 75M.\n');
                return
            end

            % set DAC sample rate
            % if sampleRate = 750k
            % the W1 channel will output 750k data points in one second
            obj.analogOutputObj.setSampleRate(0, DAC_rate);
            % the W2 channel will output 750k data points in one second
            obj.analogOutputObj.setSampleRate(1, DAC_rate);
            % read the sample rate to confirm
            DAC_rate = obj.getAnalogOutSampleRate();
            disp("Current DAC Rate: " + string(DAC_rate));
            return
        end

        function DAC_rate = getAnalogOutSampleRate(obj)
             returned_rate = obj.analogOutputObj.getSampleRate();
             DAC_rate = double(returned_rate);
             return
        end

        function setWaveform(obj, channelNumber, signalArray)
            % Inputs:
            %  - channelNumber: 1 for W1, 2 for W2
            %  - signalArray: signal that will be generated at W1/W2

        
            % format the input signal array
            formattedSignal = double(signalArray);

            if channelNumber == 1
                channelIdx = 0;
            elseif channelNumber == 2
                channelIdx = 1;
            else
                warning("setWaveform: invalid channelNumber");
                return
            end

            obj.analogOutputObj.push(channelIdx, formattedSignal);
            return

        end

        
    end
end


