`timescale 1ns/1ns

module TB;

  parameter DATA_WIDTH = 5;
  parameter DIVISOR = 5;

  reg clk;
  reg reset;
  reg start;
  reg [DATA_WIDTH:0] dividentin;
  reg [DIVISOR:0] divisor;

  wire ready;
  wire [DATA_WIDTH-1:0] remainder;
  wire [DATA_WIDTH-2:0] quotient;

  Top_Module_sim #(DATA_WIDTH, DIVISOR) uut (
    .clk(clk),
    .rst(reset),
    .start(start),
    .dividentin(dividentin),
    .divisor(divisor),
    .ready(ready),
    .remainder(remainder),
    .quotient(quotient)
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    reset = 1;
    start = 0;
    dividentin = 0;
    divisor = 0;

    #10;
    reset = 0;

    dividentin = 15;
    divisor = 6;

    start = 1;
    #10;
    start = 0;
    wait (ready == 1);
    $display("Dividend: %d, Divisor: %d", dividentin, divisor);
    $display("Quotient: %d, Remainder: %d", quotient, remainder);
    $stop;
  end

endmodule

