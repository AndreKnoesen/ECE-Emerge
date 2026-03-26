# ECE Emerge: Measuring Resistance with a Multimeter

**Department of Electrical and Computer Engineering**

**Spring 2025**

## Overview

The purpose of this guide is to:

- Introduce the concept of electrical resistance and its importance
- Provide step-by-step instructions for measuring resistance using a digital multimeter (DMM)
- Establish proper techniques for using a solderless breadboard in resistance measurements
- Emphasize safety practices and troubleshooting when working with electronic components

## 1. What is Resistance?

Resistance is the opposition to the flow of electric current in a circuit. It's measured in ohms ($\Omega$). Resistors are components specifically designed to provide a controlled amount of resistance in electronic circuits.

> **IMPORTANT**
>
> Understanding resistance is fundamental to analyzing and designing all electronic circuits. It is one of the most basic electrical properties you will measure throughout your engineering career.

## 2. Why Measure Resistance?

Accurate resistance measurement is crucial for:

- **Circuit Design:** Ensuring components have the correct values for proper circuit operation
- **Troubleshooting:** Identifying faulty components (e.g., open or shorted resistors)
- **Understanding Circuit Behavior:** Verifying theoretical calculations against real-world measurements
- **Quality Control:** Verifying component specifications before installation

## 3. Essential Tools and Materials

- **Keysight EDU34450A Digital Multimeter (DMM):** This DMM is capable of measuring various electrical quantities, including resistance.
- **Solderless Breadboard:** A board with interconnected holes that allow you to easily connect components without soldering.
- **Resistors:** A variety of resistors for practice. Common values like 100 $\Omega$, 1 k$\Omega$, 10 k$\Omega$, and 100 k$\Omega$.
- **Test Leads (Probes):** Two insulated wires with probes on each end, used to connect the DMM to the circuit.
- **Alligator Clips (Optional but Recommended):** Helpful for securely connecting the test leads to the resistor or breadboard.

## 4. Safety Precautions

> **WARNING**
>
> Always ensure the circuit is completely powered OFF before measuring resistance. Measuring resistance in a live circuit can damage the DMM and potentially cause injury.

Additional safety considerations:

- **No Voltage:** Verify that there is no voltage across the resistor before connecting the DMM.
- **Proper Connections:** Ensure the test leads are securely connected to the resistor and the DMM. Loose connections can lead to inaccurate readings.
- **Range Selection:** Start with the highest resistance range if unsure about the approximate value to avoid damaging the meter.

## 5. Measuring Resistance — Step by Step

### 5.1 Set Up the Breadboard

Place the resistor on the solderless breadboard. Insert the resistor's leads into separate rows of the breadboard, ensuring they are not shorted together. This provides a stable and convenient way to make connections.

### 5.2 Prepare the DMM

1. Turn on the DMM.
2. Select the resistance measurement function ($\Omega$). The EDU34450A dedicated button for this measurement is $\Omega2W$ which means a 2-wire resistance measurement.
3. The meter might autorange, or you might need to select a range manually. For initial measurements, autoranging is recommended.

<img src="media/FrontPanel.png" alt="Photograph of the Keysight EDU34450A DMM front panel showing all controls, display, and input terminals. Source: Keysight EDU34450A DMM Manual." style="width: 60%; display: block; margin: 0 auto;" />

*Figure 1: Keysight EDU34450A DMM: Front panel. Source: Keysight EDU34450A DMM Manual.*

<img src="media/2WireResistanceView.png" alt="Photograph of the Keysight EDU34450A DMM front panel with the Ω2W button highlighted in the top right, indicating the button to press to select 2-wire resistance measurements. Source: Keysight EDU34450A DMM Manual." style="width: 40%; display: block; margin: 0 auto;" />

*Figure 2: Keysight EDU34450A DMM: To make resistance measurements press the $[\Omega2W]$ on the front panel (top right). Source: Keysight EDU34450A DMM Manual.*

<img src="media/2WireResistanceConnection.png" alt="Diagram showing the correct terminal connections for 2-wire resistance measurement on the Keysight EDU34450A DMM. Source: Keysight EDU34450A DMM Manual." style="width: 40%; display: block; margin: 0 auto;" />

*Figure 3: Keysight EDU34450A DMM: Connect the terminals as shown. Source: Keysight EDU34450A DMM Manual.*

### 5.3 Connect the Test Leads

1. Insert the black test lead into the COM (common) jack of the DMM. The jack on the EDU34450A is the LO (low) jack as shown in Figure 4.

2. Insert the red test lead into the appropriate jack for resistance measurement (typically labeled with $\Omega$). See Figures 1, 2, and 3.

3. **Using Alligator Clips (Recommended):** Attach alligator clips to the ends of the test leads. This will make it easier to connect to the resistor on the breadboard. Using banana-to-alligator cables makes it easy to connect to resistor leads and other components. The Keysight EDU34450A comes with Test Probe Leads (EDU34450-62100). These require more careful handling as you must touch each probe tip to a lead manually.

    > **IMPORTANT**
    >
    > If using these Test Probe Leads, **you should NOT press the probe tip into a breadboard hole** as this will damage both the breadboard and the probe tip. (This same caution applies to oscilloscope probe tips as well.) **Oscilloscope probes and Test Probe Leads are expensive to replace.**

4. Connect the test leads (or alligator clips) across the resistor. Place one probe on each end of the resistor, making sure they contact the resistor leads.

> **IMPORTANT**
>
> Never measure resistance in a powered circuit. Always disconnect power sources and verify no voltage is present before measuring resistance.

### 5.4 Read the Measurement

The DMM will display the measured resistance value. Note the units displayed:

- $\Omega$ (ohms)
- k$\Omega$ (kilohms, 1 k$\Omega$ = 1,000 $\Omega$)
- M$\Omega$ (megohms, 1 M$\Omega$ = 1,000,000 $\Omega$)

### 5.5 Record and Disconnect

1. Record the measured resistance value, including the units.
2. After taking the measurement, disconnect the test leads from the resistor and the breadboard.

## 6. Understanding the Display

- **Overload (OL):** If the DMM displays "Overload" or a similar message, it means the resistance value is higher than the selected range. If you're not autoranging, select a higher range.
- **Units:** Pay attention to the units displayed (e.g., $\Omega$, k$\Omega$, M$\Omega$).
- **Fluctuating Reading:** Small fluctuations are normal, especially for high-value resistors.

## 7. Tips for Accurate Measurements

- **Clean Connections:** Ensure the resistor leads and test probes are clean. Oxidation or dirt can affect the readings.
- **Firm Contact:** Make sure the test leads have good contact with the resistor.
- **Avoid Touching the Leads:** Your body can conduct electricity and affect the resistance measurement. Try not to touch the metal parts of the test probes while taking a measurement.
- **Check the Resistor's Tolerance:** Resistors have a tolerance rating (e.g., ±5%, ±1%). The measured value may differ slightly from the nominal value within this tolerance.

> **Lab Deliverable #1**
>
> Measure and record the resistance values of at least three different resistors. Note both the color code value and the measured value. Calculate the percent difference between the nominal value (from the color code) and the measured value.

## 8. Troubleshooting

- **No Reading:** Check the connections. Make sure the DMM is set to the correct function and range. Try a different resistor.
- **Inconsistent Readings:** Check for loose connections. The resistor might be faulty or have high tolerance.
- **"OL" Display:** The resistor may be open or have a value higher than the meter can measure. Verify the resistor is not damaged and the leads are properly connected.
- **Very Low Reading:** The resistor may be shorted or there might be an unintended connection on the breadboard. Check that the resistor leads are in separate rows.

## 9. Self-Assessment Questions

Test your understanding with these questions:

1. What is the most important safety precaution when measuring resistance?
2. What does "OL" on the DMM display typically indicate?
3. If a resistor has a nominal value of 1.0 k$\Omega$ with a tolerance of $\pm$5%, what range of values would be acceptable?
4. Why is it important to avoid touching the metal parts of the test probes during measurement?
5. What might cause fluctuating resistance readings?

## 10. Useful References

- **Keysight EDU34450A User's Guide:** Consult the user manual for specific instructions on using the DMM's resistance measurement function. This is the most important reference. You can find it on the Keysight website: [EDU34450A Digital Multimeter User's Guide](https://www.keysight.com/us/en/assets/9921-01392/user-manuals/EDU3445A). In particular, look at 2-wire resistance measurements.
- **SparkFun Electronics:** <https://www.sparkfun.com/> (Excellent tutorials and resources on electronics, including multimeter usage and breadboarding.)
- **Adafruit:** <https://www.adafruit.com/> (Similar to SparkFun, with helpful guides.)

> **IMPORTANT**
>
> This document provides a basic introduction. Hands-on practice is essential for mastering resistance measurement. Don't hesitate to ask your instructors for assistance.

---

## Appendix A: Resistor Color Code Chart

<img src="media/Resistor_Color_Code.png" alt="Resistor color code chart showing the meaning of each band. The first two or three bands indicate the significant digits, followed by a multiplier band, and then tolerance and temperature coefficient bands. Image source: Wikimedia Commons (CC0)." style="width: 60%; display: block; margin: 0 auto;" />

*Figure 4: Resistor color code chart showing the meaning of each band. The first two or three bands indicate the significant digits, followed by a multiplier band, and then tolerance and temperature coefficient bands. Image source: Wikimedia Commons (CC0).*

**Note:** Download the resistor color code chart from <https://commons.wikimedia.org/wiki/File:Resistor_Color_Code.svg> and save it as a PDF in your graphics folder.

| **Color** | **Value (1st, 2nd digits)** | **Multiplier** |
|---|---|---|
| Black | 0 | $\times 10^0$ |
| Brown | 1 | $\times 10^1$ |
| Red | 2 | $\times 10^2$ |
| Orange | 3 | $\times 10^3$ |
| Yellow | 4 | $\times 10^4$ |
| Green | 5 | $\times 10^5$ |
| Blue | 6 | $\times 10^6$ |
| Violet | 7 | $\times 10^7$ |
| Grey | 8 | $\times 10^8$ |
| White | 9 | $\times 10^9$ |
| Gold | — | $\times 0.1$ |
| Silver | — | $\times 0.01$ |

**Tolerance Bands:**

- Brown: ±1%
- Red: ±2%
- Gold: ±5%
- Silver: ±10%
- No band: ±20%
