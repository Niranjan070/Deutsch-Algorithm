
import Std.Diagnostics.*;

operation ConstantZeroOracle(y : Qubit) : Unit {
    // f(x) = 0: do nothing
}

operation ConstantOneOracle(y : Qubit) : Unit {
    // f(x) = 1: flip the ancilla
    X(y);
}

operation RunDeutschCase3() : Unit {
    use x = Qubit();
    use y = Qubit();

    // Prepare the ancilla in |1>, then create |-> with H.
    X(y);
    H(x);
    H(y);

    // Oracle for the chosen function f(x) = 1.
    ConstantOneOracle(y);

    // Finish the Deutsch circuit.
    H(x);

    let result = M(x);

    Message("Chosen function: f(x) = 1");
    if (result == Zero) {
        Message("Measured input qubit: 0");
    } else {
        Message("Measured input qubit: 1");
    }
    // Reset measured qubit before releasing it.
    Reset(x);
    Reset(y);
}

operation RunComparison() : Unit {
    use x = Qubit();
    use y = Qubit();

    X(y);
    H(x);
    H(y);

    // Comparison function f(x) = 0.
    ConstantZeroOracle(y);

    H(x);
    let result = M(x);

    Message("Comparison function: f(x) = 0");
    if (result == Zero) {
        Message("Measured input qubit: 0");
    } else {
        Message("Measured input qubit: 1");
    }

    Reset(x);
    Reset(y);
}

@EntryPoint()
operation Main() : Unit {
    // IMPORTANT: Replace these with your team's actual register numbers.
    Message("Team Register Numbers: URK23AI1103, URK23AI1093");

    RunDeutschCase3();
    RunComparison();
}
