# pll
phased locked loops
## **What is a phase-locked loop (PLL)?**

A phase-locked loop (PLL) is an electronic circuit with a voltage or voltage-driven oscillator that constantly adjusts to match the frequency of an input signal.

[What is a Phase-locked Loop (PLL)?](https://www.techtarget.com/searchnetworking/definition/phase-locked-loop)

### **Components and Detailed Working of a PLL**

1. **Phase Detector (PD)/ Phase Comparator:**
    - **Function:** Compares the phase of the input reference signal with the feedback signal from the Voltage-Controlled Oscillator (VCO).
    - **Operation:** Generates an error signal proportional to the phase difference between the input and feedback signals. This error signal indicates whether the VCO needs to increase or decrease its frequency to align with the reference signal.
2. **Low-Pass Filter (LPF):**
    - **Function:** Processes the error signal from the phase detector.
    - **Operation:** Removes high-frequency noise components, producing a smooth control voltage. This filtered signal is crucial for the stable operation of the VCO, ensuring that only the desired frequency components influence its output.
3. **Voltage-Controlled Oscillator (VCO):**
    - **Function:** Generates an output signal whose frequency is determined by the input control voltage.
    - **Operation:** Adjusts its output frequency based on the control voltage received from the LPF. The VCO continues to modify its frequency until its output is phase-aligned with the reference signal, achieving a locked state.
4. **Feedback Path:**
    - **Function:** Routes the VCO's output back to the phase detector.
    - **Operation:** Ensures continuous comparison between the VCO output and the reference signal, enabling the system to dynamically correct any deviations and maintain phase alignment.

### **Operational Phases of a PLL**

1. **Free Running:**
    - Without an input signal, the VCO operates at its natural frequency.
2. **Capture:**
    - Upon introducing an input signal, the PLL adjusts the VCO frequency to match the input frequency.
3. **Phase Lock:**
    - The VCO output becomes phase-aligned with the input signal, and the PLL maintains this synchronization.

## Phase Comparator

### What is a comparator?

The comparator produces a error signal proportional to the phase/frequency difference between two signals which is then fed to vco which adjusts its o/p according to the i/p.

CD4046B Phase-Locked Loop uses two types of comparator, one a simple xor gate and secone one a more complex digital circuit with four d flops and two mos devices. First one can used when pll is in lock out phase as it enables pll to stay in lock in despite high amount of noises. Second one is used when signals are out of phase or have different frequencies, when i/p signal has more frequency than vco o/p signal the pmos circuit is on continously which pulls up the vco o/p to same level as i/p and in second case nmos is on. If frequencies are same but the i/p signal lags the vco o/p the nmos is on for a time corresponding to the phase difference and if it leads the pmos is on.  This type of comparator is used because it has no phase difference between i/p and o/p over entire vco frequency range and the power dissipation due to lpf reduces as both pmos and nmos are off for most of signal i/p range. 

## VCO

VCO of CD4046B  has a current mirror consisting of p1 and p2, and p3 and p4 on either sides of c1 and a nor based flip flop. The current enters through p1 and current mirrors in p2 and enters the circuit, the flip flop pulls each side of c1 to the ground. In each half cycle, one side of C1 is held at ground, while the other side is charged by the constant current from p2. The oscillator flips at the same threshold up and down creating symmetrical on/off times. Current mirror provides a stable and predictable current source. There are 8 inverters, 4 on either sides of c1, the slow ramp is fed into c1 and then into inverters 1 and 5. The inverters sharpen the slow edges into fast digital transistion. THe inverters 2-4 and 6-8 add delay so as ensure smooth transitions.

I have also uploaded some documents for reference.
