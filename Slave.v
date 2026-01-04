module slave_one(input psel1,penable,pwrite,input[31:0]pwdata,output reg pready,output reg[31:0]prdata);
reg[31:0]data1;
always@(*)begin
pready = 1'b1;
if(psel1 && penable)begin
 if(pwrite)
   data1  = pwdata;
 else
   prdata = data1;
end
end
endmodule

module slave_two(input psel2,penable,pwrite,input[31:0]pwdata,output reg pready,output reg[31:0]prdata);
reg[31:0]data2;
always@(*)begin
pready = 1'b1;
if(psel2 && penable)begin
 if(pwrite)
   data2  = pwdata;
 else
   prdata = data2;
end
end
endmodule
