# M2K MATLAB Class — User Guide

The `M2K` class wraps the **libm2k** C library to provide a clean MATLAB interface for the **Analog Devices ADALM-2000 (M2K)** hardware. It manages the device connection and exposes analog input (oscilloscope), analog output (waveform generator), and power supply functionality. You can perform all the operations you have previously done in Scopy by creating objects and calling methods in MATLAB through the `M2K` class.

## References

- [libm2k API documentation](https://analogdevicesinc.github.io/libm2k/index.html)
- [ADALM-2000 with MATLAB](https://wiki.analog.com/university/tools/m2k/matlab)


---

## Class Properties

| Property          | Description                              |
|-------------------|------------------------------------------|
| `m2kObj`          | Handle to the raw libm2k context object  |
| `analogInputObj`  | Controls Ch1 (1+/1−) and Ch2 (2+/2−) oscilloscopes  |
| `powerSupplyObj`  | Controls V+ and V− power supplies    |
| `analogOutputObj` | Controls W1 and W2 waveform generators   |

---

## Methods

### Constructor — `M2K()`

Creates and initializes the M2K object. Automatically:
- Closes any existing M2K connections
- Opens a new connection to the device
- Calibrates both the ADC and DAC

```matlab
myM2K = M2K();
```

> **Note:** If the device is not detected, MATLAB will throw an error. Restart MATLAB, check the USB connection, and verify the search path.

---

### `clearM2K()`

Closes all open M2K context connections. Called internally by the constructor; you can also call it manually for cleanup.

Make sure to **always** include `clearM2K()` at the end of your script to release the M2K port. 

```matlab
myM2K.clearM2K();
```

---

### `calibrateM2K()`

Performs the ADC and DAC calibration routines.

```matlab
myM2K.calibrateM2K();
```

---

### Analog Input (Oscilloscope — Ch1, Ch2)

#### `enableAnalogIn(channelNumber)`

Enables an analog input channel. Must be called before reading samples.

**Inputs:**

| Parameter       | Values | Description        |
|-----------------|--------|--------------------|
| `channelNumber` | `1`    | Enable Ch1 (1+/1−) |
| `channelNumber` | `2`    | Enable Ch2 (2+/2−) |

```matlab
myM2K.enableAnalogIn(1); % Enable Ch1
myM2K.enableAnalogIn(2); % Enable Ch2
```

---

#### `setAnalogInSampleRate(ADC_rate)`

Sets the ADC sample rate for both channels and confirms the new rate in the console.

**Valid rates:** 1k, 10k, 100k, 1M, 10M, 100M (samples per second)

```matlab
myM2K.setAnalogInSampleRate(1e6); % 1 MSPS
```

---

#### `getAnalogInSampleRate()`

Reads the current ADC sampling rate of M2K.

```matlab
curr_ADC_Rate = myM2K.getAnalogInSampleRate();
```

---

#### `clearAnalogInSampleBuffer()`

Flushes the ADC sample buffer by resetting the kernel buffers. Call this before `getAnalogInSamples()` to discard stale data.

```matlab
myM2K.clearAnalogInSampleBuffer();
```

---

#### `[t, ch1Samples, ch2Samples] = getAnalogInSamples(seconds)`

Reads voltage samples from both Ch1 and Ch2 simultaneously. 

**Inputs:**

| Parameter  | Description                                    |
|------------|------------------------------------------------|
| `seconds`  | Duration of the capture window (in seconds)    |


**Returns:**

| Output         | Description                                      |
|----------------|--------------------------------------------------|
| `t`            | Time vector (seconds), same length as the sample arrays |
| `ch1Samples` | Voltage readings from Ch1 (1+/1−) in volts      |
| `ch2Samples` | Voltage readings from Ch2 (2+/2−) in volts      |

```matlab
[t, Vin, Vout] = myM2K.getAnalogInSamples(0.1, 1000000);
```

---

### Analog Output (Waveform Generator — W1, W2)

#### `enableAnalogOut(channelNumber)`

Enables an analog output channel. Must be called before pushing waveforms.

| Parameter       | Values | Description  |
|-----------------|--------|--------------|
| `channelNumber` | `1`    | Enable W1    |
| `channelNumber` | `2`    | Enable W2    |

```matlab
myM2K.enableAnalogOut(1); % Enable W1
myM2K.enableAnalogOut(2); % Enable W2
```

---

#### `setAnalogOutSampleRate(DAC_rate)`

Sets the DAC sampling rate for both W1 and W2, and confirms the new rate in the console.

**Valid rates:** 750, 7.5k, 75k, 750k, 7.5M, 75M (samples per second)

```matlab
myM2K.setAnalogOutSampleRate(750e3); % 750 kSPS
```

---

#### `getAnalogOutSampleRate()`

Reads the current DAC sampling rate of M2K.

```matlab
curr_DAC_Rate = myM2K.getAnalogOutSampleRate();
```

---

#### `setWaveform(channelNumber, signalArray)`

Generates a waveform on W1 or W2.

| Parameter       | Values | Description  |
|-----------------|--------|--------------|
| `channelNumber` | `1`    | Generate signal on W1    |
| `channelNumber` | `2`    | Generate signal on W2    |
| `signalArray` | signal vector in double    | Signal output of the waveform generator    |

The following example requires the SignalLab class.

```matlab
myM2K.setWaveform(1, signalArray);
```

---

### Power Supply (V+, V−)

#### `enablePowerSupply(supplyNumber)`

Enables V+ or V-.

**Inputs:** 
| Parameter       | Values | Description |
|-----------------|--------|-------------|
| `supplyNumber`  | `1`    | Enable V+   |
| `supplyNumber`  | `2`    | Enable V−   |

```matlab
myM2K.enablePowerSupply(1); % Enable V+
myM2K.enablePowerSupply(2); % Enable V-
```

---

#### `setPowerSupply(supplyNumber, voltage)`

Sets the output voltage for a specified power supply.

**Inputs:** 

| Parameter       | Values | Description |
|-----------------|--------|-------------|
| `supplyNumber`  | `1` | Configures V+ |
| `supplyNumber`  | `2`   | Configures V- |
| `voltage`  | `5 - 0` | Voltage range for V+ |
| `voltage`  | `0 - -5` | Voltage range for V- |

```matlab
myM2K.setPowerSupply(1, 3.1); % Set V+ to 3.1V
myM2K.setPowerSupply(2, -2.8); % Set V- to -2.8V
```

> **Note:** V+ accepts positive voltage value only. V- accepts negative voltage value only.

---

## Example — Plotting a Signal in Time and Frequency Domains

This example first generates a sine wave using the `SignalLab` class, pushes the generated signal to M2K's waveform generator (W1), reads W1 through 1+/1-, then plots the received signal in both time and frequency domains.

Make sure to include both the `M2K` class and the `SignalLab` class in your working directory.

**Connect 1+ with W1, 1- with GND.**

```matlab
% Before connecting the M2K with your circuit, run this block fo code.

% This ensures the accuracy of the calibration procedure
myM2K = M2K(); % create M2K object
myM2K.enableAnalogIn(1); % enable Ch1
myM2K.enableAnalogIn(2); % enable Ch2
myM2K.enableAnalogOut(1); % enable W1
```
```matlab
% After connecting M2K with your circuit, run this block of code.

Vpp = 2; % waveform peak to peak is 2V
waveFreq = 1000; % frequency of the waveform is 1 kHz

ADCRate = 1000000; % ADC rate = 1MHz 
DACRate = 750000; % DAC rate = 750kHz

% set the ADC and DAC rates
myM2K.setAnalogOutSampleRate(DACRate);
myM2K.setAnalogInSampleRate(ADCRate);

% use signalLab to generate a 2 Vpp, 1 kHz sine wave
% the sampling frequency is the DAC rate because the generated signal is used by M2K's W1
s_generated = SignalLab(Vpp / 2, waveFreq, DACRate);
s_generated.info()
% generate siganl
[t_generated, samples_generated] = s_generated.generate(0.01);

% plot the generated signal in time and frequency domains 
figure;
s_generated.plotSignal(t_generated, samples_generated);
title(sprintf('Generated %s Signal --- Time Domain', s_generated.waveType));
figure;
s_generated.plotSpectrum(samples_generated);
title(sprintf('Generated %s Signal --- Frequency Domain', s_generated.waveType));

% push the generated signal to M2K waveform generator W1
myM2K.setWaveform(1, samples_generated);
% clear the ADC buffer
myM2K.clearAnalogInSampleBuffer();
% read 10 periods of the received signals from Ch1 and Ch2 
[t_received, ch1_samples, ch2_samples] = myM2K.getAnalogInSamples(10 / waveFreq);


% create another signalLab object with the ADC sampling rate
% the sampling frequency is the ADC rate because the received signal is read by M2K's Ch1(1+/1-)
s_received = s_generated;
s_received.samplingRate = ADCRate;
s_received.info()

% plot the received signal in time and frequency domains 
figure;
s_received.plotSignal(t_received, ch1_samples);
title(sprintf('Received %s Signal --- Time Domain', s_received.waveType));
figure;
s_received.plotSpectrum(ch1_samples);
title(sprintf('Received %s Signal --- Frequency Domain', s_received.waveType));


```

---

## Quick-Reference Card

| Setup                          | Method call                                              |
|-------------------------------|----------------------------------------------------------|
| Connect and calibrate M2K     | `myM2K = M2K()`                                         |
| Manual calibration            | `myM2K.calibrateM2K()`                                  |
| Close device connection       | `myM2K.clearM2K()`                                      |

| Oscilloscope (Ch1, Ch2)                         | Method call                                              |
|-------------------------------|----------------------------------------------------------|
| Enable oscilloscope channel   | `myM2K.enableAnalogIn(1)` or `(2)`                      |
| Set ADC rate                  | `myM2K.setAnalogInSampleRate(rate)`                     |
| Read ADC rate                 | `myM2K.getAnalogInSampleRate()`                         |
| Flush ADC buffer              | `myM2K.clearAnalogInSampleBuffer()`                     |
| Capture samples               | `[t,ch1,ch2] = myM2K.getAnalogInSamples(sec)`            |

| Waveform Generators (W1, W2)                         | Method call                |
|-------------------------------|----------------------------------------------------------|
| Enable waveform generator     | `myM2K.enableAnalogOut(1)` or `(2)`                     |
| Set DAC rate                  | `myM2K.setAnalogOutSampleRate(rate)`                    |
| Read DAC rate                 | `myM2K.getAnalogOutSampleRate()`                         |
| Output waveform voltage       | `myM2K.setWaveform(channelNum, signal)`                                |

| Power Supplies (V+, V-)                         | Method call                |
|-------------------------------|----------------------------------------------------------|
| Enable power supply rail      | `myM2K.enablePowerSupply(1)` or `(2)`                   |
| Set power supply voltages     | `myM2K.setPowerSupply(posV, negV)`                      |

---

## Troubleshooting

* **Can't register M2K**:
1. Check USB connection.
2. Ensure Scopy is closed so it is not holding the serial port.
3. Check if `M2K.m` is in your working directory.
4. Check if `libm2k` is in your search path. 
4. Restart MATLAB.
5. Call `clearM2K()` by the end or at the beginning of your script.

* **Invalid ADC/DAC Rate**
1. Only set the sample rate to a valid value.
2. Valid ADC rates: `1k, 10k, 100k, 1M, 10M, 100M` (samples per second).
3. Valid DAC rates: `750, 7.5k, 75k, 750k, 7.5M, 75M` (samples per second).

* **Captured waveforms are off**
1. Call `clearAnalogInSampleBuffer()` before `getAnalogInSamples()`.
2. Make sure your ADC rate is above the Nyquist rate.
