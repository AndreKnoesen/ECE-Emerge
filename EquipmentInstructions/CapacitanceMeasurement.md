# ECE Emerge: Measuring Capacitance with a Multimeter

**Department of Electrical and Computer Engineering**

**Spring 2025**

## Overview

The purpose of this guide is to:

- Introduce the concept of capacitance and its importance in electronic circuits
- Provide step-by-step instructions for measuring capacitance using the Keysight EDU34450A digital multimeter
- Establish proper techniques for handling capacitors safely
- Emphasize important precautions when working with various types of capacitors

> **IMPORTANT**
>
> This guide focuses on measuring capacitance values typically in the microfarad ($\mu$F) range and above. Measuring very small capacitance values (picofarads or nanofarads) accurately often requires specialized equipment and techniques beyond the scope of this introductory guide.

## 1. What is Capacitance?

Capacitance is the ability of a component (a capacitor) to store an electrical charge. It's measured in farads (F), though in practice, microfarads ($\mu$F), nanofarads (nF), and picofarads (pF) are more commonly used due to the large size of the farad unit.

A capacitor consists of two conductive plates separated by an insulating material (dielectric). The capacitance value depends on the plate area, the distance between plates, and the dielectric material used.

## 2. Why Measure Capacitance?

Accurate capacitance measurement is important for:

- **Circuit Design:** Ensuring capacitors have the correct values for timing circuits, filtering, and other applications
- **Component Testing:** Checking if capacitors are within their specified tolerance range and haven't degraded
- **Troubleshooting:** Identifying faulty capacitors in circuits
- **Quality Control:** Verifying component specifications before installation

## 3. Essential Tools and Materials

- **Keysight EDU34450A Digital Multimeter (DMM):** This multimeter has a dedicated capacitance measurement function
- **Solderless Breadboard:** For mounting the capacitor securely during measurement
- **Capacitors:** A variety of capacitors for practice. Start with values in the microfarad ($\mu$F) range (e.g., 1 $\mu$F, 10 $\mu$F, 100 $\mu$F)
- **Test Leads (Probes):** For connecting the DMM to the capacitor
- **Alligator Clips (Optional but Recommended):** For easier and more stable connections
- **Resistor (1k$\Omega$ to 10k$\Omega$):** For safely discharging capacitors

## 4. Types of Capacitors

Capacitors come in various types, each with specific characteristics:

- **Electrolytic Capacitors:** Usually larger, cylindrical components with polarity markings (+ and -). They typically have higher capacitance values but require correct polarity connection.

- **Ceramic Capacitors:** Small, non-polarized components often shaped like small discs or rectangular blocks. They typically have lower capacitance values.

- **Film Capacitors:** Rectangular or oval-shaped, non-polarized components. They offer good stability and are commonly used in audio applications.

- **Tantalum Capacitors:** Small, polarized components with high capacitance values for their size. They are sensitive to reverse polarity and overvoltage.

> **IMPORTANT**
>
> Always note whether a capacitor is polarized (has a specific + and - orientation) or non-polarized before connecting it in a circuit or taking measurements.

## 5. Safety Precautions

> **WARNING**
>
> Capacitors store electrical energy even when disconnected from a circuit. Larger capacitors can store enough energy to cause electrical shocks or burns if not properly discharged before handling.

- **Discharge Capacitors:** ALWAYS discharge capacitors before handling or measuring them. You can discharge a capacitor by connecting a resistor (e.g., 1k$\Omega$ to 10k$\Omega$) across its terminals for a few seconds. This is especially important for larger capacitors.

- **Observe Polarity:** Electrolytic and tantalum capacitors have specific polarity (+ and -). Ensure you connect them correctly in a circuit and observe the polarity when measuring capacitance. Reversing the polarity can damage the capacitor and potentially cause it to fail catastrophically.

- **Voltage Rating:** Make sure the capacitor's voltage rating is higher than any voltage it might be exposed to in a circuit. Exceeding a capacitor's voltage rating can lead to failure or even explosion in the case of some electrolytic capacitors.

- **Check for Damage:** Before using a capacitor, visually inspect it for signs of damage such as bulging, leakage, or burn marks. Never use damaged capacitors.

## 6. Step-by-Step Procedure for Keysight EDU34450A Multimeter

This section provides specific instructions for measuring capacitance using the Keysight EDU34450A Digital Multimeter.

### 6.1 Capacitance Measurement with the Keysight EDU34450A

The following procedure details the exact steps for measuring capacitance using the Keysight EDU34450A Digital Multimeter:

1. **Discharge the Capacitor:** Before doing anything else, discharge the capacitor by connecting a resistor (1k$\Omega$ to 10k$\Omega$) across its terminals for several seconds.

2. **Mount the Capacitor:** Place the capacitor on the solderless breadboard. For polarized capacitors like electrolytics, ensure proper orientation with the positive lead in one row and the negative lead in another row.

3. **Select the capacitance measurement function:** Press the [**CAP**] button on the multimeter. For Keysight EDU34450A, see Figure 1, press [Shift] > [Temp] as shown on p. 47 of the Keysight manual.

4. **Connect the leads to the multimeter:**
   - Connect the red test lead to the Input V$\Omega$ terminal
   - Connect the black test lead to the LO terminal

5. **Connect the leads to the capacitor:**
   - For non-polarized capacitors: Connect the test leads to either side of the capacitor
   - For polarized capacitors: Connect the red lead to the positive (+) terminal and the black lead to the negative (-) terminal

6. **Wait for the reading to stabilize:** The multimeter will take a moment to charge and measure the capacitor. Larger capacitors may take longer to provide a stable reading.

7. **Read the display:** The capacitance value will be shown on the screen in farads (F), millifarads (mF), microfarads ($\mu$F), nanofarads (nF), or picofarads (pF) depending on the capacitor's value.

<img src="media/CapacitanceKey1.png" alt="Photograph of the Keysight EDU34450A DMM front panel showing how to access the capacitance measurement function by pressing Shift then Temp." style="width: 40%; display: block; margin: 0 auto;" />

*Figure 1: Keysight EDU34450A: Selecting Capacitance option.*

<img src="media/CapacitanceKey2.png" alt="Connection diagram for capacitance measurement using the Keysight EDU34450A, showing the red test lead connected to the Input VΩ terminal and the black test lead connected to the LO terminal." style="width: 40%; display: block; margin: 0 auto;" />

*Figure 2: Connection diagram for capacitance measurement using the Keysight EDU34450A.*

> **WARNING**
>
> Do not apply any voltage to the instrument inputs until all terminals are properly connected. Plugging or unplugging the test lead while voltage is applied can cause instrument damage and may increase the risk of electric shock.

> **IMPORTANT**
>
> After taking the measurement, always discharge the capacitor again before handling or removing it from the circuit.

### 6.2 Measurement Parameters

The EDU34450A digital multimeter offers the following parameters for capacitance measurements:

- **Measurement Ranges:** 1.000 nF, 10.00 nF, 100.0 nF, 1.000 $\mu$F, 10.00 $\mu$F, 100.0 $\mu$F, 1.000 mF, 10.00 mF

- **Speed:** Fixed measurement speed

- **Default Setting:** Autoranging (the multimeter automatically selects the appropriate range)

- **Measurement Method:** Multi-slope A-to-D converter

- **Input Protection:** 1000 V on all ranges (HI terminal)

> **IMPORTANT**
>
> The multimeter will take more time to measure capacitors with higher capacitance values. The measurement time for a 1000 $\mu$F capacitor may be considerably longer than for a 1 nF capacitor.

## 7. Tips for Accurate Measurements

- **Discharge Thoroughly:** Always ensure capacitors are fully discharged before measurement. This is crucial for safety and measurement accuracy.

- **Clean Connections:** Ensure the capacitor leads and test probes are clean. Oxidation or dirt can affect the readings.

- **Correct Polarity:** For polarized capacitors, always observe the proper polarity when connecting to the multimeter.

- **Hand Capacitance:** Your body can affect small capacitance measurements. Try not to touch the capacitor leads or test probes while taking a reading.

- **Allow Time to Stabilize:** Larger capacitors might take longer to charge and give a stable reading. Be patient and wait for the reading to settle.

- **Lead Resistance:** For very low capacitance measurements, the resistance and capacitance of the test leads themselves can affect the reading. This is why specialized equipment is needed for precise measurement of very small capacitance values.

- **Ambient Conditions:** Temperature and humidity can affect capacitance measurements, especially for ceramic capacitors which can have significant temperature coefficients.

## 8. Troubleshooting

- **No Reading or "OL" Display:**
  - Check connections and DMM settings
  - Ensure the capacitor is within the measurement range of the multimeter
  - The capacitor might be open (failed). For an open circuit, the display shows a very low capacitance reading which is not stable (range 0.013nF – 0.036nF).

- **Unstable Reading:**
  - Allow more time for the reading to stabilize
  - Check for loose connections
  - The capacitor might have high leakage (internal resistance)

- **Reading Significantly Different from Nominal Value:**
  - The capacitor might be out of tolerance (check its tolerance specification)
  - The capacitor might be degraded or damaged
  - For electrolytic capacitors, aging can reduce capacitance over time

- **Negative or Erratic Readings for Polarized Capacitors:**
  - Check that the polarity is correctly observed
  - The capacitor might be damaged

> **Lab Deliverable #1**
>
> Measure and record the capacitance values of at least three different capacitors. Note both the marked value and the measured value. Calculate the percent difference between the nominal value and the measured value. For electrolytic capacitors, note the tolerance specified by the manufacturer and determine if the measured value falls within this tolerance.

## 9. Self-Assessment Questions

Test your understanding with these questions:

1. What is the most important safety precaution when measuring capacitance?
2. What are the typical units used for measuring capacitance, and how do they relate to each other?
3. How can you identify whether a capacitor is polarized or non-polarized?
4. What might cause a capacitor to give an unstable reading on a multimeter?
5. Why is it particularly important to observe the voltage rating of a capacitor?

## 10. Useful References

- **Keysight EDU34450A User's Guide:** Consult the user manual for specific instructions on using the DMM's capacitance measurement function. This is the most important reference. You can find it on the Keysight website: [EDU34450A Digital Multimeter User's Guide](https://www.keysight.com/us/en/assets/9921-01392/user-manuals/EDU3445A). In particular, look at the Measuring Capacitance section.
- **SparkFun Electronics:** <https://www.sparkfun.com/> (Excellent tutorials and resources on electronics, including multimeter usage and capacitor information.)
- **Adafruit:** <https://www.adafruit.com/> (Similar to SparkFun, with helpful guides on component testing.)

> **IMPORTANT**
>
> This document provides a basic introduction. Hands-on practice is essential for mastering capacitance measurement. Don't hesitate to ask your instructors for assistance.

---

## Appendix A: Capacitor Markings and Codes

Understanding capacitor markings is essential for identifying their values:

- **Electrolytic Capacitors:** Usually marked directly with their capacitance value in $\mu$F and their voltage rating (e.g., "100$\mu$F 25V"). They also have a stripe or "-" symbol indicating the negative terminal.

- **Ceramic and Film Capacitors:** Often use a numeric code:
  - Two-digit number: Value in pF (e.g., "47" = 47 pF)
  - Three-digit number: First two digits are significant figures, third digit is the multiplier (e.g., "104" = 10 × $10^4$ pF = 100,000 pF = 100 nF)
  - Letter codes may indicate tolerance (e.g., J = 5%, K = 10%)

- **Surface Mount Capacitors:** Often use a letter-number code or a simplified marking system. Refer to manufacturer datasheets for specific coding.
