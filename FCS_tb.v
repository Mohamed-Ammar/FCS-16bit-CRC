`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mohamed Ammar
// 
// Create Date: 09/28/2021 03:07:30 AM
// Design Name: 
// Module Name: FCS_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testing the FCS module (CRC)
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module FCS_tb();

reg clk,rst,en,data;    //inputs
wire done,LenError;     //outputs
wire [15:0] FCS;

parameter dataLength = 64;      // input data length for testing
reg [dataLength-1:0] i_data;    // holding the input data in that reg

FCS UUT (.clk(clk),.rst(rst),.en(en),.data(data),.done(done),.LenError(LenError),.FCS(FCS));

integer i;  //loop iterator

initial 
begin
    clk<=0;rst<=1;en<=0;data<=0;en<=0;
    #109.375 rst <=0; en<=1;    // wait 100 for the global reset, wait 5 for the first +ve edge
    test;
    #62.5 rst <=0; en<=1;
    data = 0;
    test;
    #31.25 rst <=0; en<=1;
    test;
    #31.25 $finish;
end

task test; 
    begin
    i_data = $random;
    //$monitor ("data=0x%0h",data,$time);
    #31.25;
    for (i = dataLength-1; i >= 0 ; i = i-1)
    begin
        data = i_data[i];
    #31.25;
    end
    #31.25 en = 0;
    #62.5 rst = 1'b1;
         i=0;data=0;
    end
endtask

    always #15.625 clk=~clk;    // 32 MHz

endmodule
