module Top_Module_sim #(parameter DATA_WIDTH = 5, parameter DIVISOR = 5) (
    input clk, rst, start,
    input [DATA_WIDTH:0] dividentin,
    input [DIVISOR:0] divisor,
    output ready,
    output [DATA_WIDTH-1:0] remainder,
    output [DATA_WIDTH-2:0] quotient
);

    wire chooseadd, shift_enq, shift_ena, load_enm, load_ena, load_enq, cout;

    Datapath #(DATA_WIDTH, DIVISOR) datapath_inst (
        .clk(clk), .reset(rst), .quotient_dp_out(quotient), .remainder_dp_out(remainder),
        .qin(dividentin), .load_enq(load_enq), .load_enm(load_enm), .shift_enq(shift_enq),
        .shift_ena(shift_ena), .load_ena(load_ena), .chooseadd(chooseadd), .min(divisor),
        .cout(cout)
    );

    Controller #(DATA_WIDTH, DIVISOR) controller_inst (
        .clk(clk), .reset(rst), .start(start), .cout(cout), .chooseadd(chooseadd),
        .load_enq(load_enq), .load_ena(load_ena), .shift_enq(shift_enq), .shift_ena(shift_ena),
        .load_enm(load_enm), .ready(ready)
    );

endmodule
