
module overlapping_detector(

input wire clk,
input wire reset,
input wire serial_in,
output reg detected

);

localparam
S0 = 3'd0,
S1 = 3'd1,
S2 = 3'd2,
S3 = 3'd3,
S4 = 3'd4,
S5 = 3'd5,
S6 = 3'd6;

reg [2:0] present_state,next_state;

always @(posedge clk or posedge reset)
begin
    if(reset)
        present_state <= S0;
    else
        present_state <= next_state;
end

always @(*)
begin
next_state = present_state;

case(present_state)

S0:
if(serial_in) next_state=S1;

S1:
if(serial_in) next_state=S2;
else next_state=S0;

S2:
if(!serial_in) next_state=S3;
else next_state=S2;

S3:
if(serial_in) next_state=S4;
else next_state=S0;

S4:
if(!serial_in) next_state=S5;
else next_state=S2;

S5:
if(serial_in) next_state=S6;
else next_state=S0;

S6:
begin
    if(serial_in)
        next_state=S2;   // overlap
    else
        next_state=S0;
end

default:
next_state=S0;

endcase
end

always @(*)
begin
detected = (present_state==S6);
end

endmodule








/////////////////////////////////////////



module nonoverlapping_detector(

input wire clk,
input wire reset,
input wire serial_in,
output reg detected

);

localparam
S0 = 3'd0,
S1 = 3'd1,
S2 = 3'd2,
S3 = 3'd3,
S4 = 3'd4,
S5 = 3'd5,
S6 = 3'd6;

reg [2:0] present_state,next_state;

always @(posedge clk or posedge reset)
begin
    if(reset)
        present_state <= S0;
    else
        present_state <= next_state;
end

always @(*)
begin

next_state = present_state;

case(present_state)

S0:
if(serial_in) next_state=S1;

S1:
if(serial_in) next_state=S2;
else next_state=S0;

S2:
if(!serial_in) next_state=S3;
else next_state=S2;

S3:
if(serial_in) next_state=S4;
else next_state=S0;

S4:
if(!serial_in) next_state=S5;
else next_state=S2;

S5:
if(serial_in)
next_state=S6;
else
next_state=S0;

S6:
next_state=S0;      // non-overlap

default:
next_state=S0;

endcase
end

always @(*)
begin
detected = (present_state==S6);
end

endmodule
