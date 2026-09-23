`timescale 1ns/1ps

module tb_register_pair;

    reg clk=0, rst=1;
    integer checks=0;

    always #5 clk=~clk;

    task step;
    begin
        @(posedge clk);
        #1;
    end
    endtask

    task check(input condition, input [8*100-1:0] description);
    begin
        checks=checks+1;

        if (condition !== 1'b1) begin
            $display("LAB2_FAIL %0s time=%0t",description,$time);
            $fatal(1,"check failed");
        end
    end
    endtask

    task finish;
    begin
        $display("LAB2_PASS register_pair checks=%0d",checks);
        $finish;
    end
    endtask

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,tb_register_pair);
    end

    initial begin
        #100000;
        $fatal(1,"watchdog timeout");
    end

    reg load=0, transfer=0;
    reg [3:0] data_in=0;
    wire [3:0] stored,value;

    register_pair dut(clk,rst,load,transfer,data_in,stored,value);

    initial begin
        step;
        check({stored,value}===8'h00,"reset");
        rst=0;

        data_in=4'ha;
        load=1;
        step;
        check({stored,value}===8'ha0,"load does not transfer");

        load=0;
        data_in=4'h3;
        transfer=1;
        step;
        check({stored,value}===8'haa,"transfer stored not live input");

        load=1;
        step;
        check({stored,value}===8'h3a,"simultaneous uses old stored");

        step;
        check({stored,value}===8'h33,"next edge transfers new stored");

        load=0;
        transfer=0;
        data_in=4'hf;
        step;
        check({stored,value}===8'h33,"both hold");

        rst=1;
        load=1;
        transfer=1;
        step;
        check({stored,value}===8'h00,"reset beats both controls");

        finish;
    end

endmodule
