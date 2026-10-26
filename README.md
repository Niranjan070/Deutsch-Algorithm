# Deutsch Algorithm - Case 3

This project is a small Q# demonstration of the **Deutsch algorithm**. It compares
two one-bit functions:

- A constant-one function, `f(x) = 1`
- A constant-zero function, `f(x) = 0`

The program shows how a quantum computer can identify whether a one-bit function
is constant by evaluating the function once and measuring the input qubit.

## Project contents

```text
quantum project/
├── URK23AI1103_Case3.qs   # Q# source code
├── .vscode/
│   └── launch.json         # VS Code launch configuration (currently empty)
└── README.md               # This guide
```

## What the program demonstrates

### Deutsch's problem

Deutsch's problem considers a function with one input bit and one output bit:

```text
f : {0, 1} -> {0, 1}
```

The function is promised to be either:

- **Constant**: both inputs produce the same output
  - `f(0) = f(1) = 0`, or
  - `f(0) = f(1) = 1`
- **Balanced**: the two inputs produce different outputs
  - `f(0) != f(1)`

Classically, both inputs may need to be tested. Deutsch's algorithm determines
the type of the function with one oracle call by using quantum superposition and
interference.

### Functions implemented in this project

The source file defines two oracle operations:

```qsharp
ConstantZeroOracle(y)
```

This represents `f(x) = 0`. It does nothing to the output qubit.

```qsharp
ConstantOneOracle(y)
```

This represents `f(x) = 1`. It applies an `X` gate to the output qubit, changing
the output from `|0>` to `|1>`.

The project does not include balanced oracles because this case focuses on the
two constant-function examples.

## How the circuit works

Each run uses two qubits:

- `x`: the input qubit
- `y`: the output, or ancilla, qubit

The program performs these steps:

1. Allocate `x` and `y`, initially in the `|0>` state.
2. Apply `X(y)` to prepare the output qubit in `|1>`.
3. Apply `H(x)` and `H(y)` to create the required superposition states.
4. Apply the selected function oracle.
5. Apply `H(x)` again so the phase information interferes on the input qubit.
6. Measure `x`.
7. Print the measured result.
8. Reset both qubits before releasing them.

The output qubit is prepared in the `|->` state. For this state, the oracle's
action appears as a phase rather than as an ordinary bit flip. This is called
**phase kickback**.

For a constant function, the final measurement of `x` is expected to be
`0` (`Zero`). Therefore, both examples in this project should report:

```text
Measured input qubit: 0
```

The measurement result identifies the function as constant. The program labels
each result so that the two oracle cases can be compared easily.

## Source-code walkthrough

### `RunDeutschCase3`

`RunDeutschCase3` runs the main Case 3 example using
`ConstantOneOracle(y)`. It prints:

```text
Chosen function: f(x) = 1
Measured input qubit: 0
```

### `RunComparison`

`RunComparison` repeats the circuit with `ConstantZeroOracle(y)`. It prints:

```text
Comparison function: f(x) = 0
Measured input qubit: 0
```

### `Main`

`Main` is marked with `@EntryPoint()`, so it is the operation executed by the
Q# runner. It first prints the team register numbers and then runs both
experiments:

```text
Team Register Numbers: URK23AI1103, URK23AI1093
```

If the register numbers change, update this message in
`URK23AI1103_Case3.qs`. The register-number message does not affect the quantum
calculation.

## Requirements

You need:

1. **Visual Studio Code**
2. The **Microsoft QDK** extension for VS Code
3. A current Q#-compatible environment provided by the QDK

This is a standalone `.qs` file, so no Python package, `.csproj` file, or
external data file is required.

## Running the program in VS Code

1. Open the project folder in Visual Studio Code:

   ```text
   c:\Users\nirth\Documents\PROJECTS\quantum project
   ```

2. Open `URK23AI1103_Case3.qs`.
3. Make sure the Microsoft QDK extension is installed and enabled.
4. Use the Q# run action provided by the extension, or open the QDK command
   palette and choose the option for running the current Q# program.
5. Review the output in the Q# output panel or integrated terminal.

The expected output is similar to:

```text
Team Register Numbers: URK23AI1103, URK23AI1093
Chosen function: f(x) = 1
Measured input qubit: 0
Comparison function: f(x) = 0
Measured input qubit: 0
```

Whitespace and additional diagnostic messages may vary between QDK versions.

## Running with QDK tools

The QDK also supports running standalone Q# files in tool mode. From the QDK
environment, select `URK23AI1103_Case3.qs` and run the operation marked with
`@EntryPoint()`.

If the command-line syntax differs in your installed QDK version, use the QDK
extension's run command in VS Code. The source file itself does not require
changes for either workflow.

## Understanding the result

The measured value is interpreted in the program as follows:

```qsharp
if (result == Zero) {
    Message("Measured input qubit: 0");
} else {
    Message("Measured input qubit: 1");
}
```

For both constant functions, the ideal Deutsch circuit produces `Zero`.
The result is not the direct output of `f(x)`. Instead, it is the result of
interference after the oracle has encoded the function's behavior into the
phase of the input qubit.

## Important implementation details

- `Qubit()` allocates one qubit at a time.
- `X` is the Pauli-X, or bit-flip, gate.
- `H` is the Hadamard gate.
- `M(x)` measures the input qubit in the computational basis.
- `Reset(x)` and `Reset(y)` return both qubits to `|0>` before they are released.
- Resetting measured or modified qubits is important for clean resource
  management and simulator/runtime compatibility.

## Customizing the project

### Change the function case

To run the constant-zero example as the main case, replace:

```qsharp
ConstantOneOracle(y);
```

with:

```qsharp
ConstantZeroOracle(y);
```

### Add a balanced oracle

A balanced oracle would produce different outputs for `x = 0` and `x = 1`.
For example, an oracle for `f(x) = x` can apply a controlled operation from
`x` to `y`. After adding the oracle, call it in the same position as the
existing constant oracle and compare the final measurement. A balanced
function should produce `Measured input qubit: 1`.

### Change the output messages

The `Message` calls are classical diagnostic output. They can be edited without
changing the quantum circuit.

## Troubleshooting

### The Q# run command is unavailable

- Confirm that the Microsoft QDK extension is installed.
- Confirm that the `.qs` file is open and recognized as Q#.
- Reload the VS Code window after installing or updating the extension.
- Use the QDK command palette rather than the empty `.vscode/launch.json`
  configuration.

### The output does not match the example

- Check that `Main` has the `@EntryPoint()` attribute.
- Confirm that both oracle calls are in the intended order.
- Ensure that the final `H(x)` occurs before `M(x)`.
- Check that the selected QDK profile supports measurement and reset.

### The result is unexpected on a noisy target

The expected results above assume an ideal simulator. Real quantum hardware
and noisy simulation can occasionally produce a different measurement because
of gate errors, decoherence, readout errors, or hardware connectivity
constraints. Repeat the experiment and compare the frequency of each result.

## Learning goals

After working through this project, you should be able to:

- Describe the difference between constant and balanced one-bit functions.
- Explain the role of the Hadamard gate in creating superposition.
- Explain phase kickback at a high level.
- Recognize how interference reveals information about a function.
- Read and run a basic Q# program.
- Reset qubits safely before they are released.

## License

No license has been specified for this project. Add a license file before
redistributing the source code.
