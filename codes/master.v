module master(input clk,reset,pwrite,ptransfer,input[31:0]paddr,read_data_bus,write_data_bus,output reg penable,psel1,psel2, output reg[31:0]pwdata,prdata);
parameter idle = 2'b00;
parameter setup = 2'b01;
parameter access = 2'b10;
reg pready;
reg[1:0]pstate,nstate;

always@(posedge clk or posedge reset)begin
if(reset)
pstate <= idle;
else 
pstate <= nstate;
end


always@(*)begin
psel1 = 1'b0;
psel2 = 1'b0;
penable = 1'b0;
pready = 1'b1;
prdata = 32'b0;
pwdata = 32'b0;
case(pstate)

idle: begin
psel1 = 1'b0;
psel2 = 1'b0;
penable = 1'b0;
if(ptransfer)
nstate = setup;
else
nstate = idle;
end

setup:begin
penable = 1'b0;
nstate = access;
if(paddr >= 32'h0000_0000 && paddr <= 32'h0000_00FF)
//from 0 to 255 select 1st slave
psel1 = 1'b1;
else if (paddr >= 32'h0000_0100 && paddr <= 32'h0000_0200)
//256 to 512 select 2nd slave
psel2 = 1'b1;
else begin
psel1 = 1'b0;
psel2 = 1'b0;
end
end

access:begin
penable = 1'b1;

if(pready && ptransfer)
nstate = setup;
else
nstate = idle;


if(pwrite && pready)begin
pwdata = write_data_bus;
end
else begin
prdata = read_data_bus;
end
end

endcase
end
endmodule
