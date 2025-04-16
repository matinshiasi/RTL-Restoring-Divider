module Controller #(parameter DATA_WIDTH = 5, parameter DIVISOR = 5) (
  input clk, reset, start, cout,
  output reg chooseadd, shift_enq, shift_ena, load_enm, load_enq, load_ena, ready
);

  reg incen, initinc;
  reg [1:0] ps, ns;
  reg [1:0] count;
  reg carry_out = 0;

  parameter [2:0]
      idle = 0,
      loadingp = 1,
      shiftinga = 2,
      shiftingq = 3,
      finaloading = 4;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      ps <= idle;
    end else begin
      ps <= ns;
    end
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      count <= 0;
    end else if (initinc) begin
      count <= 0;
    end else if (incen) begin
      count <= count + 1;
    end
    carry_out <= &count;
  end

  always @(ps, start, carry_out, cout) begin
    {incen, chooseadd, shift_enq, shift_ena, load_enm, load_enq, ready, load_ena, initinc} = 9'd0;

    case (ps)
      idle: begin
        ready = 1'b1;
        ns = start ? loadingp : idle;
      end
      loadingp: begin
        ns = start ? loadingp : shiftinga;
        initinc = 1'b1;
        load_enm = 1'b1;
        load_enq = 1'b1;
        load_ena = 1'b1;
        chooseadd = 1'b0;
        ready = 0;
      end
      shiftinga: begin
        ns = carry_out ? idle : shiftingq;
        {load_enq, load_enm} = 2'b00;
        {incen, initinc} = 2'b00;
        {shift_enq, shift_ena, chooseadd} = 3'b011;
      end
      shiftingq: begin
        ns = shiftinga;
        incen = 1;
        {shift_enq, shift_ena, chooseadd} = 3'b101;
        load_ena = cout;
      end
    endcase
  end
endmodule
