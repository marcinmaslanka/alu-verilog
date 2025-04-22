// Testbench für 16-Bit ALU-Modul
module alu_tb;
    reg  [15:0] x, y;          // Eingänge der ALU
    wire [15:0] z;             // Ausgang: Ergebnis der Operation
    wire s, zr, cy, p, v;      // Status-Flags: Sign, Zero, Carry, Parity, Overflow

    // Instanz der ALU
    alu dut (
        .x(x), .y(y),          // ALU-Eingänge
        .z(z),                 // Ergebnis
        .sign(s), .zero(zr),   // Statusflags
        .carry(cy), .parity(p),
        .overflow(v)
    );

    initial begin
        // Initialisierung der VCD-Datei zur Anzeige in GTKWave
        $dumpfile("alu_tb.vcd");     // Name der Ausgabedatei
        $dumpvars(0, alu_tb);        // Alle Signale dieser Testbench erfassen

        // Anzeige der Eingaben/Ausgaben im Terminal bei jeder Änderung
        $monitor(
            $time, " x=%h, y=%h, z=%h | sign=%b, zero=%b, carry=%b, parity=%b, overflow=%b",
            x, y, z, s, zr, cy, p, v
        );

        // Testfall 1: Vorzeichenbehafteter Überlauf
        #5 x = 16'h8fff; y = 16'h8000;

        // Testfall 2: Einfacher Übertrag mit positivem Ergebnis
        #5 x = 16'hfffe; y = 16'h0002;

        // Testfall 3: Bitmuster-Muster: Parität, Null, etc.
        #5 x = 16'haaaa; y = 16'h5555;

        // Beenden der Simulation
        #5 $finish;
    end
endmodule
