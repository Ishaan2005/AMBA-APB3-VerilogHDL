module master(input clk,reset,pwrite,ptransfer,output[31:0]paddr,read_data_bus,write_data_bus,output reg penable,psel1,psel2, output reg[31:0]pwdata,prdata);
parameter idle = 2'b00;
parameter setup = 2'b01;
parameter access = 2'b10;
reg pready;
reg[1:0]pstate,nstate;

always@(posedge clk or posedge reset)begin
if(reset)begin
pstate <= idle;
end
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
if(paddr >= 32'h0000_0000 && paddr <= 32'h0000_00FF)begin
//from 0 to 255 select 1st slave
psel1 = 1'b1;
psel2 = 1'b0;
end
else if (paddr >= 32'h0000_0100 && paddr <= 32'h0000_0200)begin
//256 to 512 select 2nd slave
psel2 = 1'b1;
psel1  = 1'b0;
end
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



module slave_one(input clk,reset,psel1,penable,pwrite,input[31:0]pwdata,paddr,output reg pready,output reg[31:0]prdata);
reg[31:0]data1;
always@(*)begin
pready = 1'b1;
prdata = 32'b0;
if(psel1 && penable && ~pwrite)begin
   prdata = data1;
end
end

always@(posedge clk)begin
if(reset)begin
data1 <= 32'b0;
end
else if(psel1 && penable && pwrite)begin
   data1  <= pwdata;
end
end
endmodule

module slave_two(input clk,reset,psel2,penable,pwrite,input[31:0]pwdata,output reg pready,output reg[31:0]prdata);
reg[31:0]data2;
always@(*)begin
pready = 1'b1;
prdata = 32'b0;
if(psel2 && penable && ~pwrite)begin
   prdata = data2;
end
end

always@(posedge clk)begin
if(reset)begin
data2 <= 32'b0;
end
else if(psel2 && penable && pwrite)begin
   data2  <= pwdata;
end
end
endmodule


module instantiation(input clk,reset,input pwrite_top,ptransfer_top, input[31:0]paddr_top,write_bus_top, output[31:0]read_bus_top,output penable_top,psel1_top,psel2_top);

wire psel1_master,psel2_master,penable_master;
wire[31:0]prdata1,prdata2;
wire pready_top = 1'b1;
wire[31:0]prdata_master,pwdata_master;

assign psel1_top = psel1_master;
assign psel2_top = psel2_master;
assign penable_top = penable_master;

assign read_bus_top = psel1_master ? prdata1 : psel2_master ? prdata2 : 32'b0;

master m1(.clk(clk),.reset(reset),.pwrite(pwrite_top),.ptransfer(ptransfer_top),.paddr(paddr_top),.read_data_bus(prdata_master),.write_data_bus(write_bus_top),.penable(penable_master),.psel1(psel1_master),.psel2(psel2_master),.pwdata(pwdata_master),.prdata(prdata_master));
slave_one slo(.clk(clk),.reset(reset),.psel1(psel1_master),.penable(penable_master),.pwrite(pwrite_top),.pwdata(write_bus_top),.pready(pready_top),.prdata(prdata1));
slave_two slt(.clk(clk),.reset(reset),.psel2(psel2_master),.penable(penable_master),.pwrite(pwrite_top),.pwdata(write_bus_top),.pready(pready_top),.prdata(prdata2));
endmodule



module lpw;
reg clk,reset;
wire[31:0]read_bus_top;
reg[31:0]paddr_top,write_bus_top;
reg pwrite_top,ptransfer_top;

instantiation in1(.clk(clk),.reset(reset),.pwrite_top(pwrite_top),.ptransfer_top(ptransfer_top),.paddr_top(paddr_top),.write_bus_top(write_bus_top),.read_bus_top(read_bus_top));

initial begin
reset = 1;
clk = 0;
#10 reset = 0;
end
always #10 clk = ~clk;

initial begin
ptransfer_top = 1;
pwrite_top = 1;
paddr_top = 32'h0x0000_0004;
write_bus_top = 32'hDEADBEEF;

end

endmodule
