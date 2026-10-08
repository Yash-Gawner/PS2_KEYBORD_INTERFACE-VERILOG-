module PS2_receiver_tb;

    reg clk;
    reg reset;
    reg PS2_CLK;
    reg PS2_DATA;

    wire error;
    wire [7:0]scan_code;
    wire key_valid;

PS2_receiver uut(
    .clk(clk),
    .reset(reset),
    .PS2_CLK(PS2_CLK),
    .PS2_DATA(PS2_DATA),
    .error(error),
    .scan_code(scan_code),
    .key_valid(key_valid)
);

always #5 clk = ~clk;

task send_bit(input b); 
begin
    PS2_DATA = b;

    #20 PS2_CLK = 0;
    #20 PS2_CLK = 1;
    #20;

end
endtask

always @(posedge clk) begin
    if (key_valid) $display("%0t: key_valid, scan_code = %h", $time, scan_code);
    if (error)     $display("%0t: ERROR", $time);
end

initial begin
    $dumpfile("PS2_receiver_tb.vcd");
    $dumpvars(0, PS2_receiver_tb);
    // $monitor("Time = %0t | clk = %d | ps2_data = %h | scan_code = %h | key_valid = %h | error = %h",
    //           $time , clk , PS2_DATA , scan_code , key_valid , error);

    $monitor( "TIME=%0t | FPGA_CLK=%b | PS2_CLK=%b | DATA=%b | STATE=%b | COUNT=%d | SCAN=%h | VALID=%b | ERROR=%b", 
             $time, clk, PS2_CLK, PS2_DATA, uut.state, uut.bit_counter, scan_code, key_valid, error );
   
   clk = 0;
   reset = 0;
   PS2_CLK = 1;
   PS2_DATA = 1;
   #20;

   reset = 1;
   #50;

   send_bit(1);
   send_bit(1);
   send_bit(0);

   send_bit(0);
   send_bit(0);
   send_bit(1);
   send_bit(1);
   send_bit(1);
   send_bit(0);
   send_bit(0);
   send_bit(0);

   send_bit(0);
   send_bit(1);

   #300 $finish;

end

endmodule