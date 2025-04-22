// Ein-Bit-Volladdierer-Modul
module fulladder (s, cout, a, b, c);
    input a, b, c;        // Eingang: zwei Summanden und ein Übertragsbit
    output s, cout;       // Ausgang: Summe (s) und Übertrag (cout)
    wire s1, c1, c2;

    // Logikgatter für Volladdierer
    xor g1 (s1, a, b),         // s1 = a XOR b
        g2 (s, s1, c),         // s = s1 XOR c
        g3 (cout, c2, c1);     // cout = c1 OR c2

    and g4 (c1, a, b),         // c1 = a AND b
        g5 (c2, s1, c);        // c2 = s1 AND c
endmodule

// 4-Bit Ripple-Carry-Addierer aus vier Fulladders
module adder4 (s, cout, a, b, cin);
    input [3:0] a, b;     // Zwei 4-Bit-Eingänge
    input cin;            // Übertragsbit (Carry-in)
    output [3:0] s;       // 4-Bit-Summe
    output cout;          // Endübertrag
    wire c1, c2, c3;      // Interne Übertragsleitungen
    wire p0, p1, p2, p3, g0, g1, g2, g3;

    // Kaskadierung von vier 1-Bit-Fulladdierern
    fulladder fa0 (s[0], c1, a[0], b[0], cin);
    fulladder fa1 (s[1], c2, a[1], b[1], c1);
    fulladder fa2 (s[2], c3, a[2], b[2], c2);
    fulladder fa3 (s[3], cout, a[3], b[3], c3);

    /*
    // (Optional) Alternative Implementierung mit Carry-Lookahead-Logik
    assign p0 = a[0]^b[0], p1 = a[1]^b[1], p2 = a[2]^b[2], p3 = a[3]^b[3];
    assign g0 = a[0]&b[0], g1 = a[1]&b[1], g2 = a[2]&b[2], g3 = a[3]&b[3];

    assign c1 = g0 | (p0 & cin);
    assign c2 = g1 | (p1 & g0) | (p1 & p0 & cin);
    assign c3 = g2 | (p2 & g1) | (p2 & p1 & g0) | (p2 & p1 & p0 & cin);
    assign cout = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0) | (p3 & p2 & p1 & p0 & cin);

    assign s[0] = p0 ^ cin;
    assign s[1] = p1 ^ c1;
    assign s[2] = p2 ^ c2;
    assign s[3] = p3 ^ c3;
    */
endmodule

// 16-Bit ALU mit 16-Bit Addition
module alu (
    input [15:0] x, y,         // Zwei 16-Bit Eingänge
    output [15:0] z,           // Ergebnis (Summe)
    output sign, zero, carry, parity, overflow
);

    wire c[3:1]; // Interne Übertragsdrähte zwischen 4-Bit-Blöcken

    // Status-Flags
    assign sign = z[15];         // Vorzeichenbit des Ergebnisses
    assign zero = ~|z;           // 1 wenn z == 0
    assign parity = ~^z;         // Paritätsbit (ungerade/gerade)
    
    // Überlauf-Flag für vorzeichenbehaftete Addition (nur korrekt bei signed interpretation!)
    assign overflow = (x[15] & y[15] & ~z[15]) | (~x[15] & ~y[15] & z[15]);

    // Zusammensetzung der 16-Bit-Addition aus vier 4-Bit Addierern
    adder4 a0 (z[3:0],   c[1], x[3:0],   y[3:0],   1'b0);
    adder4 a1 (z[7:4],   c[2], x[7:4],   y[7:4],   c[1]);
    adder4 a2 (z[11:8],  c[3], x[11:8],  y[11:8],  c[2]);
    adder4 a3 (z[15:12], carry, x[15:12], y[15:12], c[3]);

endmodule
