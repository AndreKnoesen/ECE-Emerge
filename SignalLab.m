classdef SignalLab
    % SignalLab  Signal generation and analysis for ECE labs
    %
    % Provides methods for generating periodic waveforms, computing their
    % frequency spectra, and simulating measurement effects such as noise
    % and ADC quantization. Designed for use with the ADALM2000 (M2K).
    %
    % USAGE
    %   s = SignalLab(amplitude, frequency, samplingRate)
    %   s = SignalLab(amplitude, frequency, samplingRate, phase)
    %
    % CONFIGURATION
    %   s = s.setWave("square")          % change waveform type (must re-assign)
    %   s = s.setWave("square", 75)      % square wave with 75% duty cycle
    %   s.info()                         % display all current settings
    %
    % GENERATION
    %   [t, x] = s.generate(duration)
    %   [t, x] = s.generateHarmonics(N, duration)
    %   [t, x] = s.generateNoisy(duration, noiseAmp)
    %
    % ANALYSIS
    %   A      = s.measureAmplitude(x)
    %   f      = s.measureFrequency(x)
    %   snr_db = s.calculateSNR(x)
    %   xf     = s.filterSignal(x, fLow, fHigh)
    %   xq     = s.quantizeSignal(x, range, bits)
    %
    % PLOTTING
    %   s.plotSignal(t, x)
    %   s.plotSpectrum(x)
    %   s.visualizeSNR(x)
    %   s.plotQuantization(x, range, bits)
    %
    % IMPORTANT: SignalLab is a value class. Methods that modify settings
    % must be re-assigned:  s = s.setWave("square")
    %
    % Version 1.0  |  ECE Emerge Lab

    properties
        amplitude       % Peak signal amplitude (V)
        frequency       % Fundamental frequency (Hz)
        phase           % Phase offset (radians), default 0
        samplingRate    % Sampling rate (Hz)
        waveType        % "sine" | "square" | "triangle" | "sawtooth"
        dutyCycle       % Square wave duty cycle (0–100%), default 50
    end

    % Maximum amplitude before a warning is issued (M2K input range limit)
    properties (Constant, Access = private)
        MAX_AMPLITUDE = 25      % V  — M2K maximum input range
        MAX_FREQUENCY = 1e6     % Hz — practical upper limit for lab use
        MAX_SAMPLING_RATE = 1e8 % Hz — practical upper limit for lab use
    end

    methods

        % -----------------------------------------------------------------
        %  Constructor
        % -----------------------------------------------------------------
        function obj = SignalLab(amplitude, frequency, samplingRate, phase)
            % SignalLab  Create a signal generator/analyser object
            %
            %   s = SignalLab(amplitude, frequency, samplingRate)
            %   s = SignalLab(amplitude, frequency, samplingRate, phase)
            %
            %   amplitude    - Peak amplitude in volts
            %   frequency    - Frequency in Hz  (must be > 0)
            %   samplingRate - Sampling rate in Hz (must be > 0)
            %   phase        - Phase offset in radians (default: 0)
            %
            %   Warnings are issued for:
            %     - Zero amplitude (signal will be all zeros)
            %     - |amplitude| > 25 V (exceeds M2K input range)
            %     - |phase| > 2*pi (outside standard range)
            %     - samplingRate < 2*frequency (violates Nyquist criterion)

            narginchk(3, 4);
            if nargin < 4
                phase = 0;
            end

            % --- Type and basic range checks ---
            if ~isnumeric(amplitude) || ~isscalar(amplitude)
                error("SignalLab:invalidInput", "Amplitude must be a numeric scalar.");
            end
            if ~isnumeric(frequency) || ~isscalar(frequency) || frequency <= 0
                error("SignalLab:invalidInput", "Frequency must be a positive numeric scalar.");
            end
            if frequency > SignalLab.MAX_FREQUENCY
                error("SignalLab:invalidInput", ...
                    "Frequency (%.4g Hz) exceeds the practical limit of %.4g Hz.", ...
                    frequency, SignalLab.MAX_FREQUENCY);
            end
            if ~isnumeric(samplingRate) || ~isscalar(samplingRate) || samplingRate <= 0
                error("SignalLab:invalidInput", "Sampling rate must be a positive numeric scalar.");
            end
            if samplingRate > SignalLab.MAX_SAMPLING_RATE
                error("SignalLab:invalidInput", ...
                    "Sampling rate (%.4g Hz) exceeds the practical limit of %.4g Hz.", ...
                    samplingRate, SignalLab.MAX_SAMPLING_RATE);
            end
            if ~isnumeric(phase) || ~isscalar(phase)
                error("SignalLab:invalidInput", "Phase must be a numeric scalar.");
            end

            % --- Advisory warnings ---
            if amplitude == 0
                warning("SignalLab:zeroAmplitude", ...
                    "Amplitude is zero — the generated signal will be all zeros.");
            end
            if abs(amplitude) > SignalLab.MAX_AMPLITUDE
                warning("SignalLab:amplitudeRange", ...
                    "Amplitude (%.4g V) exceeds the M2K input range of ±%.4g V.", ...
                    amplitude, SignalLab.MAX_AMPLITUDE);
            end
            if abs(phase) > 2*pi
                warning("SignalLab:phaseRange", ...
                    "Phase (%.4g rad) is outside the standard range of ±2*pi. " + ...
                    "Consider using a value in [-2*pi, 2*pi].", phase);
            end
            if samplingRate < 2 * frequency
                warning("SignalLab:nyquist", ...
                    "Sampling rate (%.4g Hz) is below the Nyquist rate (%.4g Hz). " + ...
                    "The signal will be aliased.", ...
                    samplingRate, 2*frequency);
            end

            obj.amplitude    = amplitude;
            obj.frequency    = frequency;
            obj.samplingRate = samplingRate;
            obj.phase        = phase;
            obj.waveType     = "sine";
            obj.dutyCycle    = 50;
        end

        % -----------------------------------------------------------------
        %  Configuration
        % -----------------------------------------------------------------
        function obj = setWave(obj, waveType, dutyCycle)
            % setWave  Change the waveform type
            %
            %   s = s.setWave("sine")
            %   s = s.setWave("square")
            %   s = s.setWave("square", 75)   % 75% duty cycle
            %
            %   Supported types: "sine", "square", "triangle", "sawtooth"
            %
            %   Note: duty cycles of 0% and 100% produce a constant DC
            %   signal. A warning is issued if these values are used.

            validTypes = ["sine", "square", "triangle", "sawtooth"];
            waveType   = lower(string(waveType));   % accept char or string input

            if ~any(waveType == validTypes)
                error("SignalLab:invalidWaveType", ...
                    "Wave type must be: ""sine"", ""square"", ""triangle"", or ""sawtooth"".");
            end
            obj.waveType = waveType;

            if nargin >= 3
                if waveType ~= "square"
                    warning("SignalLab:dutyCycleIgnored", ...
                        "Duty cycle only applies to square waves — ignored for ""%s"".", ...
                        waveType);
                else
                    if ~isnumeric(dutyCycle) || ~isscalar(dutyCycle) || ...
                            dutyCycle < 0 || dutyCycle > 100
                        error("SignalLab:invalidInput", ...
                            "Duty cycle must be a numeric scalar between 0 and 100.");
                    end
                    if dutyCycle == 0 || dutyCycle == 100
                        warning("SignalLab:dutyCycleConstant", ...
                            "Duty cycle of %g%% produces a constant DC signal.", ...
                            dutyCycle);
                    end
                    obj.dutyCycle = dutyCycle;
                end
            end
        end

        function info(obj)
            % info  Display all current signal properties
            %
            %   s.info()
            %
            %   Also shows the Nyquist frequency and the frequency
            %   resolution achievable for a 1-second signal.

            nyquist = obj.samplingRate / 2;

            fprintf("--- SignalLab ---\n");
            fprintf("  Amplitude    : %g V\n",    obj.amplitude);
            fprintf("  Frequency    : %g Hz\n",   obj.frequency);
            fprintf("  Phase        : %g rad\n",  obj.phase);
            fprintf("  Sampling Rate: %g Hz\n",   obj.samplingRate);
            fprintf("  Nyquist Freq : %g Hz\n",   nyquist);
            fprintf("  Wave Type    : %s\n",      obj.waveType);
            if obj.waveType == "square"
                fprintf("  Duty Cycle   : %g%%\n", obj.dutyCycle);
            end
            if obj.samplingRate < 2 * obj.frequency
                fprintf("  *** WARNING: sampling rate is below the Nyquist rate ***\n");
            end
        end

        % -----------------------------------------------------------------
        %  Signal generation
        % -----------------------------------------------------------------
        function [t, x] = generate(obj, duration)
            % generate  Generate the current waveform
            %
            %   [t, x] = s.generate(duration)
            %
            %   duration - Signal duration in seconds (positive scalar)
            %   t        - Time vector (s)
            %   x        - Signal samples (V)
            %
            %   The duration is automatically adjusted to the nearest whole
            %   number of complete periods to avoid spectral leakage.
            %
            %   For sine waves: an error is raised if samplingRate < 2*frequency.
            %   For non-sinusoidal waveforms: same error applies; additionally
            %   a warning is issued if samplingRate < 10*frequency, because
            %   ideal square/triangle/sawtooth waves have infinite bandwidth
            %   and harmonics above Nyquist will fold back into the spectrum.

            obj.validateDuration(duration);
            obj.checkNyquist();

            t   = obj.timeVector(duration);
            tau = mod(2*pi*obj.frequency*t + obj.phase, 2*pi) / (2*pi);

            switch obj.waveType
                case "sine"
                    x = obj.amplitude * sin(2*pi*obj.frequency*t + obj.phase);
                case "square"
                    % +amplitude for first dutyCycle%, -amplitude for remainder
                    x = obj.amplitude * (2*(tau < obj.dutyCycle/100) - 1);
                case "triangle"
                    % Rises from -A to +A in first half period, back in second
                    x = obj.amplitude * (1 - 4*abs(tau - 0.5));
                case "sawtooth"
                    % Rises linearly from -A to +A over one full period
                    x = obj.amplitude * (2*tau - 1);
            end
        end

        function [t, x] = generateHarmonics(obj, N, duration)
            % generateHarmonics  Fourier series approximation up to the Nth harmonic
            %
            %   [t, x] = s.generateHarmonics(N, duration)
            %
            %   N        - Highest harmonic number to include (positive integer)
            %              square/triangle : odd harmonics up to N  (1, 3, 5, …, ≤N)
            %              sawtooth        : all harmonics up to N  (1, 2, 3, …, N)
            %              sine            : N is ignored (sine has no harmonics)
            %   duration - Signal duration in seconds
            %
            %   Fourier series coefficients:
            %     Square  : x(t) = (4A/pi)   * sum_{odd n ≤ N}  sin(2*pi*n*f*t) / n
            %     Triangle: x(t) = (8A/pi^2) * sum_{odd n ≤ N}  (-1)^k * sin(2*pi*n*f*t) / n^2
            %     Sawtooth: x(t) = (2A/pi)   * sum_{n=1}^{N}    (-1)^(n+1) * sin(2*pi*n*f*t) / n
            %
            %   A warning is issued if any harmonic frequency exceeds the
            %   Nyquist limit — those harmonics would be aliased.

            if ~isnumeric(N) || ~isscalar(N) || N < 1 || N ~= floor(N)
                error("SignalLab:invalidInput", "N must be a positive integer.");
            end
            obj.validateDuration(duration);
            obj.checkNyquist();

            % Check that highest harmonic does not exceed Nyquist
            highestFreq = N * obj.frequency;
            if highestFreq > obj.samplingRate / 2
                warning("SignalLab:harmonicAliasing", ...
                    "Harmonic %d (%.4g Hz) exceeds the Nyquist frequency (%.4g Hz) " + ...
                    "and will be aliased. Reduce N or increase the sampling rate.", ...
                    N, highestFreq, obj.samplingRate/2);
            end

            if obj.waveType == "sine" && N > 1
                warning("SignalLab:harmonicsIgnored", ...
                    "A sine wave has no harmonics above the fundamental. " + ...
                    "N = %d is ignored — only the fundamental is generated.", N);
            end

            t = obj.timeVector(duration);
            x = zeros(size(t));

            switch obj.waveType
                case "sine"
                    x = obj.amplitude * sin(2*pi*obj.frequency*t + obj.phase);

                case "square"
                    for n = 1 : 2 : N   % odd harmonics: 1, 3, 5, …, ≤N
                        x = x + sin(2*pi*n*obj.frequency*t + obj.phase) / n;
                    end
                    x = (4*obj.amplitude / pi) * x;

                case "triangle"
                    for n = 1 : 2 : N   % odd harmonics: 1, 3, 5, …, ≤N
                        k = (n - 1) / 2;
                        x = x + (-1)^k * sin(2*pi*n*obj.frequency*t + obj.phase) / n^2;
                    end
                    x = (8*obj.amplitude / pi^2) * x;

                case "sawtooth"
                    for n = 1 : N       % all harmonics: 1, 2, 3, …, N
                        x = x + (-1)^(n+1) * sin(2*pi*n*obj.frequency*t + obj.phase) / n;
                    end
                    x = (2*obj.amplitude / pi) * x;
            end
        end

        function [t, x] = generateNoisy(obj, duration, noiseAmp)
            % generateNoisy  Generate current waveform with added Gaussian noise
            %
            %   [t, x] = s.generateNoisy(duration)
            %   [t, x] = s.generateNoisy(duration, noiseAmp)
            %
            %   noiseAmp - Standard deviation of the noise in volts (default: 0.1)
            %              Must be a non-negative scalar.

            if nargin < 3
                noiseAmp = 0.1;
            end
            if ~isnumeric(noiseAmp) || ~isscalar(noiseAmp) || noiseAmp < 0
                error("SignalLab:invalidInput", ...
                    "Noise amplitude must be a non-negative numeric scalar.");
            end
            [t, x] = obj.generate(duration);
            x = x + noiseAmp * randn(size(x));
        end

        % -----------------------------------------------------------------
        %  Signal analysis
        % -----------------------------------------------------------------
        function A = measureAmplitude(~, x)
            % measureAmplitude  Estimate amplitude as half the peak-to-peak value
            %
            %   A = s.measureAmplitude(x)
            %
            %   x - Signal vector (numeric, at least 2 samples)
            %
            %   Returns the peak amplitude in volts.

            SignalLab.validateSignalInput(x, "measureAmplitude");
            A = (max(x) - min(x)) / 2;
        end

        function f = measureFrequency(obj, x)
            % measureFrequency  Estimate the dominant frequency via FFT
            %
            %   f = s.measureFrequency(x)
            %
            %   x - Signal vector (numeric, at least 4 samples)
            %
            %   Returns the frequency in Hz of the largest spectral peak,
            %   excluding DC.

            SignalLab.validateSignalInput(x, "measureFrequency");
            [f, ~, ~] = obj.computeSpectrum(x);
        end

        function snr_db = calculateSNR(obj, x)
            % calculateSNR  Estimate signal-to-noise ratio in dB
            %
            %   snr_db = s.calculateSNR(x)
            %
            %   x - Signal vector (numeric, at least 4 samples)
            %
            %   Signal power  : spectral energy within ±5% of the dominant
            %                   frequency (minimum bandwidth 5 Hz)
            %   Noise power   : all other spectral energy, excluding DC
            %
            %   Returns Inf if no noise is present.

            SignalLab.validateSignalInput(x, "calculateSNR");

            [fDom, spectrum, freqAxis] = obj.computeSpectrum(x);

            bw      = max(5, 0.05 * fDom);
            inBand  = abs(freqAxis - fDom) <= bw;
            outBand = ~inBand & (freqAxis > 0);

            signalPower = sum(spectrum(inBand).^2);
            noisePower  = sum(spectrum(outBand).^2);

            if noisePower == 0
                snr_db = Inf;
            else
                snr_db = 10 * log10(signalPower / noisePower);
            end
        end

        function xf = filterSignal(obj, x, fLow, fHigh)
            % filterSignal  Ideal rectangular bandpass filter
            %
            %   xf = s.filterSignal(x, fLow, fHigh)
            %
            %   x          - Signal vector (numeric)
            %   fLow, fHigh - Lower and upper cutoff frequencies in Hz
            %                 Must satisfy: 0 ≤ fLow < fHigh
            %
            %   Frequencies outside [fLow, fHigh] are zeroed in the FFT
            %   domain. Returns the filtered signal at the same length as x.
            %
            %   A warning is issued if fHigh exceeds the Nyquist frequency
            %   since no signal energy exists above Nyquist.

            SignalLab.validateSignalInput(x, "filterSignal");

            if ~isnumeric(fLow) || ~isscalar(fLow)
                error("SignalLab:invalidInput", "fLow must be a numeric scalar.");
            end
            if ~isnumeric(fHigh) || ~isscalar(fHigh)
                error("SignalLab:invalidInput", "fHigh must be a numeric scalar.");
            end
            if fLow < 0
                error("SignalLab:invalidInput", "fLow must be non-negative.");
            end
            if fLow >= fHigh
                error("SignalLab:invalidInput", "fLow must be less than fHigh.");
            end
            if fHigh > obj.samplingRate / 2
                warning("SignalLab:nyquist", ...
                    "fHigh (%.4g Hz) exceeds the Nyquist frequency (%.4g Hz). " + ...
                    "No signal energy exists above Nyquist.", ...
                    fHigh, obj.samplingRate/2);
            end

            x    = x(:);
            N    = length(x);
            Y    = fft(x);
            freq = obj.samplingRate * (0:N-1) / N;

            % Build bandpass mask; mirror for the negative-frequency half
            mask = zeros(N, 1);
            for i = 1:N
                f    = freq(i);
                fNeg = obj.samplingRate - f;
                if (f >= fLow && f <= fHigh) || (fNeg >= fLow && fNeg <= fHigh)
                    mask(i) = 1;
                end
            end

            xf = real(ifft(Y .* mask));
        end

        function xq = quantizeSignal(obj, x, range, bits)
            % quantizeSignal  Simulate ADC quantization
            %
            %   xq = s.quantizeSignal(x)
            %   xq = s.quantizeSignal(x, range)
            %   xq = s.quantizeSignal(x, range, bits)
            %
            %   x     - Input signal vector (V)
            %   range - Full-scale ADC input range in volts
            %           Default: 5 V (±2.5 V) — M2K low-voltage range
            %           Use 50 V for the M2K high-voltage range (±25 V)
            %   bits  - ADC resolution in bits (default: 12 — M2K)
            %
            %   Samples outside ±range/2 are clipped before quantization.
            %   LSB size = range / 2^bits
            %
            %   M2K ADC input ranges:
            %     ±2.5 V  (range =  5 V)  — use for signals up to ±2.5 V
            %     ±25  V  (range = 50 V)  — use for signals up to ±25 V

            SignalLab.validateSignalInput(x, "quantizeSignal");

            if nargin < 3, range = 5;  end
            if nargin < 4, bits  = 12; end

            if ~isnumeric(range) || ~isscalar(range) || range <= 0
                error("SignalLab:invalidInput", ...
                    "Range must be a positive numeric scalar (full-scale volts).");
            end
            if ~isnumeric(bits) || ~isscalar(bits) || bits < 1 || bits ~= floor(bits)
                error("SignalLab:invalidInput", "Bits must be a positive integer.");
            end

            nLevels = 2^bits;
            lsb     = range / nLevels;

            % Clip to ADC input range
            xq = max(-range/2, min(range/2, x));

            % Round to nearest quantization level
            xq = round(xq / lsb) * lsb;

            % Clamp upper edge to prevent rounding overshoot beyond +range/2
            xq = min(xq, range/2 - lsb);
        end

        % -----------------------------------------------------------------
        %  Plotting
        % -----------------------------------------------------------------
        function plotSignal(~, t, x)
            % plotSignal  Plot the signal in the time domain
            %
            %   s.plotSignal(t, x)
            %
            %   t - Time vector (s)
            %   x - Signal vector (V); must be the same length as t

            if ~isnumeric(t) || ~isvector(t)
                error("SignalLab:invalidInput", "t must be a numeric vector.");
            end
            if ~isnumeric(x) || ~isvector(x)
                error("SignalLab:invalidInput", "x must be a numeric vector.");
            end
            if length(t) ~= length(x)
                error("SignalLab:invalidInput", ...
                    "t and x must be the same length (t: %d, x: %d).", ...
                    length(t), length(x));
            end

            plot(t, x, "b-", "LineWidth", 1.5);
            xlabel("Time (s)",      "FontSize", 12);
            ylabel("Amplitude (V)", "FontSize", 12);
            title("Time Domain Signal", "FontSize", 14);
            grid on;
            box on;
        end

        function plotSpectrum(obj, x)
            % plotSpectrum  Plot the single-sided magnitude spectrum in dB
            %
            %   s.plotSpectrum(x)
            %
            %   x - Signal vector (numeric, at least 4 samples)
            %
            %   The FFT is computed internally — no prior setup needed.
            %   The spectrum is scaled so that peak values equal the true
            %   signal amplitudes before conversion to dB.

            SignalLab.validateSignalInput(x, "plotSpectrum");
            [~, spectrum, freqAxis] = obj.computeSpectrum(x);

            plot(freqAxis, 20*log10(spectrum + eps), "r-", "LineWidth", 1.5);
            xlabel("Frequency (Hz)", "FontSize", 12);
            ylabel("Magnitude (dB)", "FontSize", 12);
            title("Frequency Spectrum", "FontSize", 14);
            grid on;
            box on;
        end

        function visualizeSNR(obj, x)
            % visualizeSNR  Two-panel figure: time domain + spectrum with signal band
            %
            %   s.visualizeSNR(x)
            %
            %   x - Signal vector (numeric, at least 4 samples)
            %
            %   The signal band (used for SNR calculation) is highlighted
            %   in red on the spectrum panel.

            SignalLab.validateSignalInput(x, "visualizeSNR");

            [fDom, spectrum, freqAxis] = obj.computeSpectrum(x);
            snr_db  = obj.calculateSNR(x);
            bw      = max(5, 0.05 * fDom);
            inBand  = abs(freqAxis - fDom) <= bw;
            t       = (0 : length(x)-1) / obj.samplingRate;

            figure("Position", [100, 100, 800, 600]);

            subplot(2, 1, 1);
            plot(t, x, "b-", "LineWidth", 1.2);
            xlabel("Time (s)");
            ylabel("Amplitude (V)");
            title("Time Domain Signal");
            grid on;

            subplot(2, 1, 2);
            plot(freqAxis, spectrum, "b-", "LineWidth", 1.2);
            hold on;
            plot(freqAxis(inBand), spectrum(inBand), "r-", "LineWidth", 2.5);
            hold off;
            xlabel("Frequency (Hz)");
            ylabel("Magnitude");
            title(sprintf("Frequency Spectrum  —  SNR = %.1f dB", snr_db));
            legend("Full Spectrum", "Signal Band", "Location", "northeast");
            grid on;
        end

        function plotQuantization(obj, x, range, bits)
            % plotQuantization  Visualise the effect of ADC quantization
            %
            %   s.plotQuantization(x)
            %   s.plotQuantization(x, range)
            %   s.plotQuantization(x, range, bits)
            %
            %   x     - Signal vector (numeric, at least 4 samples)
            %   range - Full-scale ADC range in volts (default: 5 V = ±2.5 V)
            %   bits  - ADC resolution in bits (default: 12)
            %
            %   Three-panel figure:
            %     Top    — original vs quantized; clipped samples marked in red;
            %               ADC limits shown as dotted lines
            %     Middle — quantization error with ±LSB/2 bounds
            %     Bottom — magnitude spectrum of original vs quantized;
            %               theoretical noise floor shown in title

            SignalLab.validateSignalInput(x, "plotQuantization");

            if nargin < 3, range = 5;  end
            if nargin < 4, bits  = 12; end

            xq      = obj.quantizeSignal(x, range, bits);
            err     = xq - x;
            t       = (0 : length(x)-1) / obj.samplingRate;
            lsb     = range / 2^bits;
            clipped = abs(x) > range/2;

            figure("Position", [100, 100, 900, 750]);

            % --- Top: original vs quantized, ADC limits and clipping ---
            subplot(3, 1, 1);
            plot(t, x,  "b-",  "LineWidth", 1.2);
            hold on;
            plot(t, xq, "r--", "LineWidth", 1.0);
            if any(clipped)
                plot(t(clipped), x(clipped), "ro", "MarkerSize", 4, ...
                    "DisplayName", "Clipped");
            end
            yline( range/2, "k:", "LineWidth", 1.0);
            yline(-range/2, "k:", "LineWidth", 1.0);
            hold off;
            xlabel("Time (s)");
            ylabel("Amplitude (V)");
            title(sprintf( ...
                "Original vs Quantized  |  %d-bit  |  range = \\pm%.4g V  |  LSB = %.4g mV", ...
                bits, range/2, lsb*1000));
            if any(clipped)
                legend("Original", "Quantized", "Clipped", "Location", "northeast");
            else
                legend("Original", "Quantized", "Location", "northeast");
            end
            grid on;

            % --- Middle: quantization error ---
            subplot(3, 1, 2);
            plot(t, err * 1000, "k-", "LineWidth", 1.0);
            yline( lsb/2 * 1000, "r--", "+LSB/2", "LineWidth", 1.0);
            yline(-lsb/2 * 1000, "r--", "-LSB/2", "LineWidth", 1.0);
            xlabel("Time (s)");
            ylabel("Error (mV)");
            title(sprintf("Quantization Error  |  bounded by \\pm%.4g mV", lsb/2*1000));
            grid on;

            % --- Bottom: spectrum comparison ---
            subplot(3, 1, 3);
            [~, spec_orig, freq] = obj.computeSpectrum(x);
            [~, spec_q,    ~   ] = obj.computeSpectrum(xq);
            plot(freq, 20*log10(spec_orig + eps), "b-",  "LineWidth", 1.2);
            hold on;
            plot(freq, 20*log10(spec_q    + eps), "r--", "LineWidth", 1.2);
            hold off;
            xlabel("Frequency (Hz)");
            ylabel("Magnitude (dB)");
            title(sprintf( ...
                "Spectrum: Original vs Quantized  |  theoretical noise floor \\approx %.1f dB", ...
                -(6.02*bits + 1.76)));
            legend("Original", "Quantized", "Location", "northeast");
            grid on;
        end

    end

    % =====================================================================
    %  Private helpers
    % =====================================================================
    methods (Access = private)

        function t = timeVector(obj, duration)
            % Snap to the nearest whole number of complete periods of the
            % fundamental frequency. This prevents spectral leakage in FFT
            % analysis without requiring the student to choose duration
            % carefully.
            numPeriods = max(1, round(duration * obj.frequency));
            N = round(numPeriods * obj.samplingRate / obj.frequency);
            t = (0 : N-1) / obj.samplingRate;
        end

        function validateDuration(~, duration)
            % Validate that duration is a positive numeric scalar.
            if ~isnumeric(duration) || ~isscalar(duration) || duration <= 0
                error("SignalLab:invalidInput", ...
                    "Duration must be a positive numeric scalar (seconds).");
            end
        end

        function checkNyquist(obj)
            % Raise an error or warning based on the Nyquist criterion.
            %
            % For ALL waveforms:
            %   Error if samplingRate < 2 * frequency.
            %   The fundamental cannot be represented at all.
            %
            % For non-sinusoidal waveforms (square, triangle, sawtooth):
            %   Warning if samplingRate < 10 * frequency.
            %   Ideal non-sinusoidal waveforms have infinite bandwidth and
            %   are never truly bandlimited. The threshold of 10× ensures
            %   at least the 1st through 4th odd harmonics (1, 3, 5, 7 ×f0)
            %   fall below Nyquist. Below this threshold the waveform shape
            %   will be visibly distorted by harmonic aliasing.

            if obj.samplingRate < 2 * obj.frequency
                error("SignalLab:nyquist", ...
                    "Cannot generate signal: sampling rate (%.4g Hz) is below " + ...
                    "the Nyquist rate (%.4g Hz) for frequency %.4g Hz. " + ...
                    "Increase samplingRate or decrease frequency.", ...
                    obj.samplingRate, 2*obj.frequency, obj.frequency);
            end

            if obj.waveType ~= "sine" && obj.samplingRate < 10 * obj.frequency
                highestHarmonic = floor(obj.samplingRate / (2 * obj.frequency));
                warning("SignalLab:harmonicAliasing", ...
                    "%s wave: sampling rate (%.4g Hz) is less than 10× the " + ...
                    "fundamental (%.4g Hz). Only harmonics up to %d are below " + ...
                    "the Nyquist frequency (%.4g Hz); higher harmonics will " + ...
                    "fold back into the spectrum and distort the waveform shape. " + ...
                    "Consider increasing the sampling rate.", ...
                    obj.waveType, obj.samplingRate, obj.frequency, ...
                    highestHarmonic, obj.samplingRate / 2);
            end
        end

        function [fDom, spectrum, freqAxis] = computeSpectrum(obj, x)
            % Compute the single-sided magnitude spectrum and dominant frequency.
            %
            % DC offset is removed before the FFT. The single-sided spectrum
            % is scaled so that peak values correspond to true signal amplitudes.

            x = x(:) - mean(x);
            N = length(x);

            if N < 4
                error("SignalLab:tooShort", ...
                    "Signal must contain at least 4 samples for spectral analysis.");
            end

            Xmag = abs(fft(x) / N);

            nUniq    = floor(N/2) + 1;
            spectrum = Xmag(1:nUniq);
            spectrum(2:end-1) = 2 * spectrum(2:end-1);

            freqAxis = (0 : nUniq-1) * (obj.samplingRate / N);

            % Dominant frequency: largest peak excluding DC (index 1)
            [~, idx] = max(spectrum(2:end));
            fDom = freqAxis(idx + 1);
        end

    end

    % =====================================================================
    %  Static helpers
    % =====================================================================
    methods (Static, Access = private)

        function validateSignalInput(x, callerName)
            % Validate that x is a non-empty numeric vector with at least
            % 2 samples. Raises a descriptive error referencing the caller.
            if ~isnumeric(x) || ~isvector(x)
                error("SignalLab:invalidInput", ...
                    "%s: x must be a numeric vector.", callerName);
            end
            if length(x) < 2
                error("SignalLab:invalidInput", ...
                    "%s: signal must contain at least 2 samples.", callerName);
            end
        end

    end
end
