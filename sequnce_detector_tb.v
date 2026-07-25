
`timescale 1ns/1ps

module sequence_detector_tb;

    reg clk;
    reg reset;
    reg serial_in;

    wire detected_overlap;
    wire detected_nonoverlap;


    // Overlapping Detector
    overlapping_detector OVERLAP_DUT (
        .clk(clk),
        .reset(reset),
        .serial_in(serial_in),
        .detected(detected_overlap)
    );


    // Non-overlapping Detector
    nonoverlapping_detector NONOVERLAP_DUT (
        .clk(clk),
        .reset(reset),
        .serial_in(serial_in),
        .detected(detected_nonoverlap)
    );


    // Clock
    initial
    begin
    clk = 1'b0;

   forever
   #5 clk = ~clk;
    end


    // Send one bit per clock
    task send_bit(input bit_value);
    begin
        serial_in = bit_value;

        @(posedge clk);
        #1;
    end
    endtask


    initial
    begin

        reset = 1'b1;
        serial_in = 1'b0;

        #12;

        reset = 1'b0;


        // 110101110101
        send_bit(1);
        send_bit(1);
        send_bit(0);
        send_bit(1);
        send_bit(0);
        send_bit(1);

        send_bit(1);
        send_bit(1);
        send_bit(0);
        send_bit(1);
        send_bit(0);
        send_bit(1);


        #20;

        $stop;

    end

endmodule