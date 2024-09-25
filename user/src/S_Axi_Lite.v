//Date : 2024-09-24
//Author : shawag
//Module Name: [File Name] - [Module Name]
//Target Device: [Target FPGA or ASIC Device]
//Tool versions: [EDA Tool Version]
//Revision Historyc :
//Revision :
//    Revision 0.01 - File Created
//Description :A brief description of what the module does. Describe its
//             functionality, inputs, outputs, and any important behavior.
//
//Dependencies:
//         List any modules or files this module depends on, or any
//            specific conditions required for this module to function 
//             correctly.
//	
//Company : ncai Technology .Inc
//Copyright(c) 1999, ncai Technology Inc, All right reserved
//
//wavedom

`include "Timesacle.v"

module S_Axi_Lite #(
    parameter integer P_S_AXI_DATA_WIDTH	= 32,
    parameter integer P_S_AXI_ADDR_WIDTH	= 4
)
(       input wire  S_AXI_ACLK,
		// Global Reset Signal. This Signal is Active LOW
		input wire  S_AXI_ARESETN,
		// Write address (issued by master, acceped by Slave)
		input wire [P_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
		// Write channel Protection type. This signal indicates the
    	// privilege and security level of the transaction, and whether
    	// the transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_AWPROT,
		// Write address valid. This signal indicates that the master signaling
    		// valid write address and control information.
		input wire  S_AXI_AWVALID,
		// Write address ready. This signal indicates that the slave is ready
    		// to accept an address and associated control signals.
		output wire  S_AXI_AWREADY,
		// Write data (issued by master, acceped by Slave) 
		input wire [P_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
		// Write strobes. This signal indicates which byte lanes hold
    		// valid data. There is one write strobe bit for each eight
    		// bits of the write data bus.    
		input wire [(P_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
		// Write valid. This signal indicates that valid write
    		// data and strobes are available.
		input wire  S_AXI_WVALID,
		// Write ready. This signal indicates that the slave
    		// can accept the write data.
		output wire  S_AXI_WREADY,
		// Write response. This signal indicates the status
    		// of the write transaction.
		output wire [1 : 0] S_AXI_BRESP,
		// Write response valid. This signal indicates that the channel
    		// is signaling a valid write response.
		output wire  S_AXI_BVALID,
		// Response ready. This signal indicates that the master
    		// can accept a write response.
		input wire  S_AXI_BREADY,
		// Read address (issued by master, acceped by Slave)
		input wire [P_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
		// Protection type. This signal indicates the privilege
    		// and security level of the transaction, and whether the
    		// transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_ARPROT,
		// Read address valid. This signal indicates that the channel
    		// is signaling valid read address and control information.
		input wire  S_AXI_ARVALID,
		// Read address ready. This signal indicates that the slave is
    		// ready to accept an address and associated control signals.
		output wire  S_AXI_ARREADY,
		// Read data (issued by slave)
		output wire [P_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
		// Read response. This signal indicates the status of the
    		// read transfer.
		output wire [1 : 0] S_AXI_RRESP,
		// Read valid. This signal indicates that the channel is
    		// signaling the required read data.
		output wire  S_AXI_RVALID,
		// Read ready. This signal indicates that the master can
    		// accept the read data and response information.
		input wire  S_AXI_RREADY
);
//output reg define
//AW channel
reg [P_S_AXI_DATA_WIDTH-1:0] r_axi_awaddr;
reg                          r_axi_awvalid;
//W channel
reg                          r_axi_wready;
//WR channel
reg [1:0]                    r_axi_bresp;
reg                          r_axi_bvalid;
//AR channel
reg [P_S_AXI_ADDR_WIDTH-1:0] r_axi_araddr;
reg                          r_axi_arready;
reg [P_S_AXI_DATA_WIDTH-1:0] r_axi_rdata;
reg [1:0]                    r_axi_rresp;
//R channel
reg                          r_axi_rvalid;
reg                          r_axi_awready;



//output connection
assign S_AXI_AWADDR = r_axi_awaddr;
assign S_AXI_AWVALID = r_axi_awvalid;
assign S_AXI_WREADY = r_axi_wready;
assign S_AXI_BRESP = r_axi_bresp;
assign S_AXI_BVALID = r_axi_bvalid;
assign S_AXI_ARADDR = r_axi_araddr;
assign S_AXI_ARREADY = r_axi_arready;
assign S_AXI_RDATA = r_axi_rdata;
assign S_AXI_RRESP = r_axi_rresp;
assign S_AXI_RVALID = r_axi_rvalid;
assign S_AXI_AWREADY = r_axi_awready;
//logic define
wire axi_reg_wren = r_axi_wready && S_AXI_WVALID && r_axi_awready && S_AXI_AWVALID;
wire axi_reg_rden = r_axi_arready && S_AXI_ARVALID && ~r_axi_rvalid;
//reg define
reg							 r_aw_valid;

//slave reg define
reg [P_S_AXI_DATA_WIDTH-1:0] r_axi_reg0;
reg [P_S_AXI_DATA_WIDTH-1:0] r_axi_reg1;
reg [P_S_AXI_DATA_WIDTH-1:0] r_axi_reg2;
reg [P_S_AXI_DATA_WIDTH-1:0] r_axi_reg3;


always @(posedge S_AXI_ACLK) begin
    if(~S_AXI_ARESETN)
        r_axi_awready <= 1'b0;   
    else begin
        if(~r_axi_awready && S_AXI_AWVALID && S_AXI_WVALID && r_aw_valid)
            r_axi_awready <= 1'b1;
        else if(S_AXI_BREADY && r_axi_bvalid) 
            r_axi_awready <= 1'b0;
        else
            r_axi_awready <= 1'b0; 
    end
end

always @(posedge S_AXI_ACLK) begin
    if(~S_AXI_ARESETN)
        r_axi_awaddr <= 0;
    else begin
        if(r_axi_awready && S_AXI_AWVALID && S_AXI_WVALID && r_aw_valid)
            r_axi_awaddr <= S_AXI_AWADDR;
        else
            r_axi_awaddr <= r_axi_awaddr;
    end
end

always @(posedge S_AXI_ACLK) begin
	if(~S_AXI_ARESETN)
		r_aw_valid <= 1'b1;
	else begin
		if(~r_axi_awready && S_AXI_AWVALID && S_AXI_WVALID && r_aw_valid)
			r_aw_valid <= 1'b0;
		else if(r_axi_bvalid && S_AXI_BREADY)
			r_aw_valid <= 1'b1;
		else
			r_aw_valid <= r_aw_valid;
	end
	
end

always @(posedge S_AXI_ACLK) begin
    if(~S_AXI_ARESETN)
        r_axi_wready <= 1'b0;
    else begin
       if(~r_axi_awready && S_AXI_AWVALID && S_AXI_WVALID && r_aw_valid)
            r_axi_wready <= 1'b1;
        else
            r_axi_wready <= 1'b0;
    end
end

always @(posedge S_AXI_ACLK) begin
    if(~S_AXI_ARESETN)
        r_axi_bvalid <= 1'b0;
    else begin
        if(r_axi_awready && S_AXI_AWVALID && ~r_axi_bvalid && r_axi_wready && S_AXI_WVALID)
            r_axi_bvalid <= 1'b1;
        else if (r_axi_bvalid && S_AXI_BREADY)
            r_axi_bvalid <= 1'b0;
        else
            r_axi_bvalid <= r_axi_bvalid;
    end
end

always @(posedge S_AXI_ACLK) begin
	if(~S_AXI_ARESETN)
		r_axi_bresp <= 2'b00;
	else begin
		if(r_axi_awready && S_AXI_AWVALID && ~r_axi_bvalid && r_axi_wready && S_AXI_WVALID)
			r_axi_bresp <= 2'b00;
		else
			r_axi_bresp <= 2'b00;
	end
end

always @(posedge S_AXI_ACLK) begin
	if(~S_AXI_ARESETN)
	 	r_axi_arready <= 1'b0;
	else begin
		if(~r_axi_arready && S_AXI_ARVALID)
			r_axi_arready <= 1'b1;
		else
			r_axi_arready <= 1'b0;
	end
end

always @(posedge S_AXI_ACLK) begin
	if(~S_AXI_ARESETN)
		r_axi_araddr <= {P_S_AXI_ADDR_WIDTH{1'b0}};
	else begin
		if(~r_axi_arready && S_AXI_ARVALID)
			r_axi_araddr <= S_AXI_ARADDR;
		else
			r_axi_araddr <= r_axi_araddr;
	end
end

always @(posedge S_AXI_ACLK) begin
	if(~S_AXI_ARESETN)
		r_axi_rvalid <= 1'b0;
	else begin
		if(~r_axi_rvalid && r_axi_arready && S_AXI_ARVALID)
			r_axi_rvalid <= 1'b1;
		else if(r_axi_rvalid && S_AXI_RREADY)
			r_axi_rvalid <= 1'b0;
		else
			r_axi_rvalid <= r_axi_rvalid;
	end
end

always @(posedge S_AXI_ACLK) begin
	if(~S_AXI_ARESETN)
		r_axi_rresp <= 2'b00;
	else begin
		if(~r_axi_rvalid && r_axi_arready && S_AXI_ARVALID)
			r_axi_rresp <= 2'b00;
		else
			r_axi_rresp <= 2'b00;
	end
end

always @(posedge S_AXI_ACLK) begin
	if(~S_AXI_ARESETN) begin
		r_axi_reg0 <= {P_S_AXI_DATA_WIDTH{1'b0}};
		r_axi_reg1 <= {P_S_AXI_DATA_WIDTH{1'b0}};
		r_axi_reg2 <= {P_S_AXI_DATA_WIDTH{1'b0}};
		r_axi_reg3 <= {P_S_AXI_DATA_WIDTH{1'b0}};
	end
	else begin
		if(axi_reg_wren) begin
			case(r_axi_awaddr[1:0]) 
				2'b00: r_axi_reg0 <= S_AXI_WDATA;
				2'b01: r_axi_reg1 <= S_AXI_WDATA;
				2'b10: r_axi_reg2 <= S_AXI_WDATA;
				2'b11: r_axi_reg3 <= S_AXI_WDATA;
				default: begin
					r_axi_reg0 <= r_axi_reg0;
					r_axi_reg1 <= r_axi_reg1;
					r_axi_reg2 <= r_axi_reg2;
					r_axi_reg3 <= r_axi_reg3;
				end
			endcase
		end
		else begin
			r_axi_reg0 <= r_axi_reg0;
			r_axi_reg1 <= r_axi_reg1;
			r_axi_reg2 <= r_axi_reg2;
			r_axi_reg3 <= r_axi_reg3;
		end
	end

end

always @(posedge S_AXI_ACLK) begin
	if(~S_AXI_ARESETN)
		r_axi_rdata <= {P_S_AXI_DATA_WIDTH{1'b0}};
	else begin
		if(axi_reg_rden)
			case(r_axi_araddr[1:0])
			2'b00: r_axi_rdata = r_axi_reg0;
			2'b01: r_axi_rdata = r_axi_reg1;
			2'b10: r_axi_rdata = r_axi_reg2;
			2'b11: r_axi_rdata = r_axi_reg3;
			default: r_axi_rdata = {P_S_AXI_DATA_WIDTH{1'b0}};
			endcase
		else
			r_axi_rdata <= r_axi_rdata;
	end
end



endmodule
