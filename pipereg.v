module pipereg (
    input  wire        clock,
    input  wire        reset,

    // Input Side (Write Port)
    output wire        w_ready, 
    input  wire        w_valid, 
    input  wire [7:0] w_data,

    // Output Side (Read Port)
    input  wire        r_ready, 
    output reg         r_valid, 
    output reg  [7:0] r_data
);

    // Standard Handshake Logic:
    // Ready if downstream is ready OR our register is empty.
    assign w_ready = r_ready || !r_valid;

    always @(posedge clock) begin
        if (reset) begin
            r_valid <= 1'b0;
            r_data  <= 8'b0;
        end else if (w_ready) begin
            r_valid <= w_valid;
            if (w_valid) begin
                r_data <= w_data;
            end
        end
    end

endmodule
