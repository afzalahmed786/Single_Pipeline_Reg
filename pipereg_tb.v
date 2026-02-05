`timescale 1ns/1ps

module pipereg_tb(); 

    reg clock, rst;
    reg w_valid, r_ready;
    reg [7:0] w_data;       
    
    wire w_ready, r_valid;
    wire [7:0] r_data;      

    pipereg dut (
        .clock   (clock),
        .reset   (rst),
        .w_ready (w_ready),
        .w_valid (w_valid),
        .w_data  (w_data),
        .r_ready (r_ready),
        .r_valid (r_valid),
        .r_data  (r_data)
    );

    initial clock = 0;
    always #5 clock = ~clock;

    integer i;

    initial begin
        $display("Starting Simulation...");
        $dumpfile("dump.vcd");
        $dumpvars(0, pipereg_tb);

        rst = 1; 
        w_valid = 0; 
        w_data = 0; 
        r_ready = 1; // Downstream starts ready
        
        #20 rst = 0; // Release reset
        @(posedge clock);

        $display("Scenario 1: Sending 10 words sequentially...");
        for (i = 1; i <= 10; i = i + 1) begin
            w_valid = 1;
            w_data = i; 
            
            while (!w_ready) @(posedge clock); 

            @(posedge clock); 
	    repeat(2) @(posedge clock);
        end
        w_valid = 0; 
        repeat(2) @(posedge clock);

        $display("Scenario 2: Testing Backpressure Stall...");
        w_valid = 1;
        w_data = 8'hAA; 
        r_ready = 0;    
        @(posedge clock);
        
        w_data = 8'hFF; 
        repeat(5) @(posedge clock);
        
        $display("Releasing stall. AA should be read before FF.");
        r_ready = 1; 
        @(posedge clock);
        w_valid = 0;

        #50 $display("Simulation Complete. All words processed.");
        $finish;
    end

endmodule
