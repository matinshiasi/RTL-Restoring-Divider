module load_register #(parameter N = 8) (
    input wire clk, reset, load_en,
    input wire [N-1:0] d,
    output reg [N-1:0] q
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 0;
        end else if (load_en) begin
            q <= d;
        end
    end
endmodule

module shift_registerp #(parameter N = 8) (
    input wire serial_in, clk, reset, load_en, shift_en,
    input wire [N-1:0] parallel_in,
    output reg [N-1:0] q
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 0;
        end else if (shift_en) begin
            q <= {q[N-2:0], serial_in};
        end else if (load_en) begin
            q <= parallel_in;
        end
    end
endmodule
