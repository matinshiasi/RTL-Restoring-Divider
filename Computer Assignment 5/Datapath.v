module Datapath #(parameter DATA_WIDTH = 5, parameter DIVISOR = 5) (
  input wire clk, reset, load_ena, load_enq, load_enm, shift_enq, shift_ena, chooseadd,
  input wire [DATA_WIDTH-2:0] qin,
  input wire [DIVISOR-1:0] min,
  output wire [DIVISOR-2:0] quotient_dp_out,
  output wire [DATA_WIDTH-1:0] remainder_dp_out,
  output wire cout
);

  wire [DIVISOR-1:0] mout;
  wire [DIVISOR-2:0] qout;
  wire [DIVISOR-1:0] moutp;
  wire [DATA_WIDTH-1:0] aout;
  wire [DATA_WIDTH-1:0] addresult;
  wire [DATA_WIDTH-1:0] ainput;

  assign moutp = ~mout;
  assign {cout, addresult} = moutp + aout + 5'b00001;
  assign remainder_dp_out = aout;
  assign quotient_dp_out = qout;
  assign ainput = chooseadd ? addresult : 5'b0;

    shift_registerp #(.N(5)) a (
        .clk(clk),
        .reset(reset),
        .load_en(load_ena),
        .serial_in(qout[3]),
        .shift_en(shift_ena),
        .parallel_in(ainput),
        .q(aout)
    );
    load_register #(.N(5)) m (
        .clk(clk),
        .reset(reset),
        .load_en(load_enm),
        .d(min),
        .q(mout)
    );
    shift_registerp #(.N(4)) q (
        .clk(clk),
        .reset(reset),
        .shift_en(shift_enq),
        .serial_in(cout),
        .q(qout),
        .parallel_in(qin),
        .load_en(load_enq)
    );

endmodule
