# ECE Emerge: Measuring DC Voltage with a Multimeter

**Department of Electrical and Computer Engineering**

**Spring 2025**

## Overview

The purpose of this guide is to:

- Introduce the concept of direct current (DC) voltage and its importance in electronic circuits
- Provide step-by-step instructions for measuring DC voltage using the Keysight EDU34450A digital multimeter
- Establish proper techniques for safely measuring voltage in various circuits
- Emphasize important safety precautions when working with electrical systems

## 1. What is DC Voltage?

DC (Direct Current) voltage is an electrical potential difference that remains constant in polarity over time. Unlike alternating current (AC), which periodically changes direction, DC flows consistently in one direction from the higher potential (positive) to the lower potential (negative).

DC voltage is commonly found in batteries, power supplies, and electronic circuits. It's typically measured in volts (V) and represents the electrical pressure that causes electrons to flow through a conductor.

## 2. Why Measure DC Voltage?

Accurate DC voltage measurement is important for:

- **Circuit Design:** Ensuring components receive the proper voltage levels
- **Troubleshooting:** Identifying faulty components or incorrect connections
- **Testing Power Sources:** Verifying the output of batteries, power supplies, and voltage regulators
- **Safety Verification:** Confirming that a circuit is properly powered or de-energized

## 3. Essential Tools and Materials

- **Keysight EDU34450A Digital Multimeter (DMM):** A precision instrument capable of measuring various electrical parameters, including DC voltage
- **Test Leads:** Insulated wires with probes that connect the multimeter to the circuit
- **DC Voltage Source:** For practice, this could be a battery, power supply, or a simple circuit
- **Solderless Breadboard (Optional):** For building simple circuits to measure

## 4. Safety Precautions

> **WARNING**
>
> Do not apply any voltage to the instrument inputs until all terminals are properly connected. Plugging or unplugging the test lead while high voltage is applied can cause instrument damage and may increase the risk of electric shock.

> **IMPORTANT**
>
> Under no circumstances should you make DC voltage measurements exceeding 10 Volt in ECE-Emerge. This is a strict safety limit for this course.

Additional safety considerations:

- **Voltage Limits:** Never exceed the maximum voltage rating of your multimeter (1000V for the EDU34450A)
- **Proper Connections:** Always connect the multimeter in parallel with the component whose voltage you're measuring
- **Insulation:** Ensure test leads have intact insulation with no exposed metal except at the probe tips
- **Hand Placement:** Keep your fingers behind the protective barriers on the test probes
- **Working Environment:** Avoid measuring voltage in wet conditions or when standing on wet surfaces

## 5. Step-by-Step Procedure for Keysight EDU34450A Multimeter

This section provides specific instructions for measuring DC voltage using the Keysight EDU34450A Digital Multimeter. See Figures 1 and 2.

### 5.1 DC Voltage Measurement

1. **Select the DC voltage measurement function:** Press the [**DCV**] button on the multimeter.

2. **Connect the leads to the multimeter:**
   - Connect the red test lead to the Input V$\Omega$ terminal
   - Connect the black test lead to the LO terminal

3. **Connect the leads to the circuit:**
   - Connect the red probe to the point of higher potential (positive side)
   - Connect the black probe to the point of lower potential (negative side or ground)

    > **IMPORTANT**
    >
    > **Do not NOT press the probe tip into a breadboard hole** as this will damage both the breadboard and the probe tip. (This same caution applies to oscilloscope probe tips as well.) **Oscilloscope probes and Test Probe Leads are expensive to replace.**

4. **Read the display:** The DC voltage value will be shown on the screen with VDC units.

5. **Adjust measurement settings if needed:**
   - Press **Resolution** to change the reading speed to either Slow, Medium, or Fast.
   - Press **Input Z** to set the input impedance to either 10M$\Omega$ or Auto.

<img src="media/VoltageKey1.png" alt="Photograph of the Keysight EDU34450A DMM front panel with the DCV button highlighted, indicating the button to press to select DC voltage measurements." style="width: 40%; display: block; margin: 0 auto;" />

*Figure 1: Keysight EDU34450A: To select DC voltage measurement press [DCV] on the front panel.*

<img src="media/VoltageKey2.png" alt="Connection diagram for DC voltage measurement using the Keysight EDU34450A, showing the red test lead connected to the Input VΩ terminal and the black test lead connected to the LO terminal." style="width: 40%; display: block; margin: 0 auto;" />

*Figure 2: Connection diagram for DC voltage measurement using the Keysight EDU34450A.*

> **IMPORTANT**
>
> For high-precision measurements of small DC voltages (below 1V), setting the Input Z to "Auto" provides higher input impedance ($>$10 G$\Omega$), which minimizes the loading effect on the circuit being measured.

### 5.2 Measurement Parameters

The EDU34450A digital multimeter offers the following parameters for DC voltage measurements:

- **Measurement Ranges:** 100.000 mV, 1.00000 V, 10.0000 V, 100.000 V, 1000.00 V

- **Speed Options:**
  - Slow: Highest accuracy, longer measurement time
  - Medium: Balanced accuracy and measurement time
  - Fast: Quickest measurement, reduced accuracy

- **Default Setting:** Autoranging, Slow measurement speed

- **Measurement Method:** Sigma Delta A-to-D converter

- **Input Impedance:**
  - $>$10 G$\Omega$ for the 0.1 V and 1 V ranges (when Auto is selected)
  - $\approx$10 M$\Omega$ for all ranges (when 10M$\Omega$ is selected or for ranges above 1 V)

- **Input Protection:** 1000 V on all ranges (HI terminal)

## 6. Understanding Polarity

When measuring DC voltage:

- A positive reading indicates the red probe is at a higher potential than the black probe
- A negative reading indicates the red probe is at a lower potential than the black probe

If you see a negative reading and expect a positive value, simply reverse the position of your test leads. However, in many cases, knowing the actual polarity is important information.

## 7. Tips for Accurate Measurements

- **Select the Appropriate Range:** Start with the highest range and work down if using manual ranging, or allow autoranging for convenience

- **Input Impedance Setting:** Use the "Auto" setting for measuring sensitive circuits or very small voltages (below 1V) to minimize the loading effect

- **Measurement Speed:** Use "Slow" for the most accurate readings, especially for noise-sensitive measurements

- **Firm Contact:** Ensure the test probes make good contact with the measurement points

- **Stable Reading:** Wait for the reading to stabilize before recording the measurement

- **Consider Load Effect:** Be aware that connecting a multimeter to a high-impedance circuit can affect the circuit's behavior

## 8. Troubleshooting

- **No Reading or "OL" Display:**
  - Check connections and DMM settings
  - Verify the circuit is powered
  - Ensure the voltage is within the measurement range

- **Unstable Reading:**
  - Check for loose connections
  - The circuit might have fluctuating voltage due to design or malfunction
  - Try using the "Slow" measurement speed to average out fluctuations

- **Unexpected Voltage Values:**
  - Verify measurement points are correct
  - Check for ground loops or improper grounding
  - Look for damaged components in the circuit

> **Lab Deliverable #1**
>
> Measure and record the DC voltage of at least three different sources (e.g., AA battery, 9V battery, power supply output). For each measurement, document the measured value, the measurement settings used (resolution, input impedance), and calculate the percent difference from the nominal value if applicable.

## 9. Self-Assessment Questions

Test your understanding with these questions:

1. Why must you connect a voltmeter in parallel with the component being measured?
2. What is the advantage of using the "Auto" input impedance setting when measuring small DC voltages?
3. How does the measurement speed setting affect the accuracy and response time of voltage measurements?
4. What safety precautions must be observed when measuring voltages above 30V DC?
5. What might cause a digital multimeter to display a negative voltage when measuring a DC source?

## 10. Useful References

- **Keysight EDU34450A User's Guide:** Consult the user manual for specific instructions on using the DMM's DC voltage measurement function. This is the most important reference. You can find it on the Keysight website: [EDU34450A Digital Multimeter User's Guide](https://www.keysight.com/us/en/assets/9921-01392/user-manuals/EDU3445A).
- **SparkFun Electronics:** <https://www.sparkfun.com/> (Excellent tutorials and resources on electronics, including multimeter usage.)
- **Adafruit:** <https://www.adafruit.com/> (Similar to SparkFun, with helpful guides on basic electronic measurements.)

> **IMPORTANT**
>
> This document provides a basic introduction. Hands-on practice is essential for mastering voltage measurement. Don't hesitate to ask your instructors for assistance.

---

## Appendix A: Common DC Voltage Sources and Expected Values

This reference table provides expected voltage values for common DC sources:

| **Source** | **Nominal Voltage** | **Typical Measured Range** |
|---|---|---|
| AA, AAA, C, D Batteries (fresh) | 1.5 V | 1.5 - 1.6 V |
| AA, AAA, C, D Batteries (depleted) | 1.5 V | 0.9 - 1.4 V |
| 9V Battery (fresh) | 9 V | 9.0 - 9.6 V |
| CR2032 Coin Cell | 3 V | 2.9 - 3.2 V |
| USB Port (standard) | 5 V | 4.75 - 5.25 V |
| Arduino Board 5V Pin | 5 V | 4.8 - 5.2 V |
| Arduino Board 3.3V Pin | 3.3 V | 3.2 - 3.4 V |
| Typical Bench Power Supply | Variable | Within ±1% of setting |
