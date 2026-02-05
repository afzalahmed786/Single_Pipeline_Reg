all:
	iverilog -o sim.out pipereg.v pipereg_tb.v
	vvp sim.out
waves:
	gtkwave dump.vcd

# Remove junk
clean:
	rm -f sim.out dump.vcd
