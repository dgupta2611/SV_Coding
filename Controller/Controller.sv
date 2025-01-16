module MemoryZeroController(clock, reset, zero, cnt_eq, set_busy, clr_busy, ld_cnt, cnt_en, addr_sel, zero_we);
input clock, reset;
input zero;
input cnt_eq;
output set_busy;
output clr_busy;
output ld_cnt;
output cnt_en;
output addr_sel;
output zero_we;

reg set_busy, clr_busy, ld_cnt, cnt_en, addr_sel, zero_we;

enum logic [1:0] {Init, Load, Write} State, NextState;


// Sequential block: reset and update state register
always_ff @(posedge clock)
begin
if (reset)
	State <= Init;
else
	State <= NextState;
end


// Output logic
always_comb
begin
{set_busy, clr_busy, ld_cnt, cnt_en, addr_sel, zero_we} = '0;
case (State) 
	Init:
		begin
		clr_busy = '1;
		end
		
	Load:
		begin			
		set_busy = '1;
		ld_cnt = '1;
		end
		
	Write:
		begin
		zero_we = '1;		
		set_busy = '1;
		cnt_en = '1;
		addr_sel = '1;
		end
endcase
end

// Next state logic
always_comb
begin
NextState = State;
case (State)
	Init:
		if (zero)
			NextState = Load;
			
	Load:
		NextState = Write;
		
	Write:
		if (cnt_eq)
			NextState = Init;
endcase
end
endmodule
