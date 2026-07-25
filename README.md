# Sequence Detector (Overlapping & Non-Overlapping)

## Overview

This project implements two Moore Finite State Machines (FSMs) that detect the binary sequence:

```
110101
```

The project contains two implementations:

- Overlapping Sequence Detector
- Non-Overlapping Sequence Detector

Both detectors receive one serial input bit every clock cycle and generate a detection pulse once the complete sequence is recognized.

---

# Operation

The FSM starts from the idle state (S0) after reset.

For every rising edge of the clock:

- One serial bit is sampled.
- The FSM moves to the next state depending on the current state and the received bit.
- Each state represents the amount of the target sequence that has been matched so far.
- When the complete sequence **110101** is received, the FSM enters the detection state (S6), where the output signal `detected` becomes HIGH for one clock cycle.

---

# Overlapping Sequence Detector

The overlapping detector is designed to continue searching immediately after a successful detection.

Instead of returning to the initial state, the FSM moves to a state that preserves the longest valid prefix of the detected sequence.

For example, after detecting:

```
110101
```

if the next incoming bits can start another valid sequence, the detector continues without discarding previously matched bits.

This improves detection efficiency when multiple sequences overlap.

---

# Non-Overlapping Sequence Detector

The non-overlapping detector behaves differently after detection.

Once the target sequence is detected, the FSM returns directly to the initial state (S0).

This forces the detector to ignore any overlapping bits and start searching for a completely new sequence.

As a result, two detected sequences can never share input bits.

---

# FSM States

Both implementations use seven states.

| State | Description |
|--------|-------------|
| S0 | Initial state |
| S1 | First bit matched |
| S2 | First two bits matched |
| S3 | First three bits matched |
| S4 | First four bits matched |
| S5 | First five bits matched |
| S6 | Complete sequence detected |

The only difference between the two designs is the transition after S6.

- **Overlapping Detector:** returns to S2.
- **Non-Overlapping Detector:** returns to S0.

---

# Testbench Operation

The testbench verifies both detectors simultaneously.

It performs the following steps:

1. Generates a periodic clock.
2. Applies reset.
3. Sends one serial bit every clock cycle.
4. Applies the same input stream to both FSMs.
5. Observes the detection outputs.

Input sequence:

```
110101110101
```

This sequence was selected because it contains two occurrences of the target pattern, allowing the behavior of both detectors to be compared.

---

# Expected Simulation Results

### Overlapping Detector

- Detects the first sequence.
- Continues from the overlap state.
- Can detect another sequence without restarting from S0.

### Non-Overlapping Detector

- Detects the first sequence.
- Returns to the initial state.
- Starts searching again from the beginning.

---

