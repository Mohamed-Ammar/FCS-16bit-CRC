`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Mohamed Ammar
// 
// Create Date: 09/28/2021 01:34:31 AM
// Design Name: FCS
// Module Name: FCS
// Project Name: Assignmnet 1
// Target Devices: I used Spartan 7
// Tool Versions: 2019.1
// Description: 16-bit ITU-T CRC , as described in 5.2.1.9 - IEEE 802.15.4-2011 std.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// The generator polynomial is: G(x)=x^16+x^12+x^5+1. 
// 
//////////////////////////////////////////////////////////////////////////////////

module FCS
    (
    input clk,rst,en,data,
    output done,LenError,
    output [15:0] FCS
    );
    
    reg [15:0] r_FCS;
    reg  r_data,r_LenError;
    reg [10:0] counter;     
    
        /*Data Path*/    
    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            r_FCS  <= 0;
            r_data <= 0;
        end
        else if(en)
        begin
            r_data <= data;
            r_FCS <= {r_FCS[14:0],r_data};
            r_FCS[0] <= r_data ^ r_FCS[15];
            r_FCS[5] <= r_FCS[4] ^ r_data  ^ r_FCS[15];
            r_FCS[12] <= r_FCS[11]^ r_data ^ r_FCS[15];
        end
    end
    
        /*Error Handling*/
    always @(posedge clk or posedge rst)
    begin
        if (rst) begin
            counter <= 10'b0;
            r_LenError<=0;
        end
        else if (en)
        begin
            counter <= counter + 1'b1;

            if (counter < 65) r_LenError <= 1'b1;
            else if (counter>1025) r_LenError <= 1'b1;
            else r_LenError <= 1'b0;
        end
    end
    
        /*Assignments*/
    assign LenError =  r_LenError;
    assign done = ~en; 
    assign FCS  = LenError ? 0 : r_FCS;
    
endmodule
