% File CRC.m
%**************************************************************************
% This script calculates the 16-bit ITU-T CRC, as described in 5.2.1.9 - IEEE 802.15.4-2011 std.
%
% Author: Mohamed Ammar
% Date: 09/28/2021
%
% The generator polynomial is: G(x)=x^16+x^12+x^5+1. 
%
% From the given explanation the steps are:
% 1 - Initialize the remainder register to zero;
% 2 - Shift MHR and payload into the divider (LSB first);
% 3 - Operations are done in the order: a) 3 XORs b) left shift of remainder register 
% 4 - The r register is appended to the message.
% 5 - The remainder register contains the FCS 
%**************************************************************************

x = [1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 1 1 0];  % InputData

r = zeros(1,16);                    % Remainder register initialization - Matlab indices starts from 1 not 0

for itr=1:length(x)
    
    xor1 = bitxor(x(itr),r(1));     % XOR between Remainder(0) and x bit (first XOR)
    xor2 = bitxor(xor1,r(12));      % XOR Remainder(11) (second XOR)
    xor3 = bitxor(xor1,r(5));       % XOR Remainder(4)	(third XOR)
    
    r = [r(2:16) xor1];             % Left shift of r, and r15 update

    r(11)= xor2;                   	% r10 update
    r(4) = xor3;                    % r3 update
end

data_FCS = [x r]                    % data + FCS field
