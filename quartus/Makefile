PROJECT = hello-adc
TOP_LEVEL_ENTITY = top_level
QSYS_PROJECT = hello_adc

###################################################################
# Part, Family, Boardfile DE1 or DE2
FAMILY = "MAX10"
PART = 10M50DAF484C7G

###################################################################
# Setup your sources here
QSYS_BASE = qsys

QSYS_SYN_FILES = $(addprefix $(QSYS_BASE)/synthesis/$(QSYS_PROJECT),.qip .vhd) \
				 $(shell find $(QSYS_BASE)/synthesis/submodules -type f)
QSYS_SIM_FILES = $(addprefix $(QSYS_BASE)/simulation/$(QSYS_PROJECT),.sip .vhd)

SRCS = $(wildcard ../fpga/src/*.vhd) $(QSYS_SYN_FILES)

###################################################################
# Main Targets
#
# all: build everything
# clean: remove output files and database
# program: program your device with the compiled design
###################################################################
all: smart.log $(PROJECT).asm.rpt $(PROJECT).sta.rpt

clean:
	rm -rf *.rpt *.chg smart.log *.htm *.eqn *.pin *.sof *.pof \
		db incremental_db $(QSYS_PROJECT)

qsys: qsys-syn qsys-sim
qsys-syn: $(QSYS_SYN_FILES)
qsys-sim: $(QSYS_SIM_FILES)
map: smart.log $(PROJECT).map.rpt
fit: smart.log $(PROJECT).fit.rpt
asm: smart.log $(PROJECT).asm.rpt
sta: smart.log $(PROJECT).sta.rpt
smart: smart.log

###################################################################
# QSYS Configuration and Generation
###################################################################
QSYS_SYN_ARGS = --synthesis=VHDL --output-directory=$(QSYS_BASE)

$(QSYS_SYN_FILES): $(QSYS_PROJECT).qsys
	qsys-generate $(QSYS_SYN_ARGS) $(QSYS_PROJECT).qsys

QSYS_SIM_ARGS = --simulation=VHDL --output-directory=$(QSYS_BASE)

$(QSYS_SIM_FILES): $(QSYS_PROJECT).qsys
	qsys-generate $(QSYS_SIM_ARGS) $(QSYS_PROJECT).qsys

###################################################################
# Executable Configuration
###################################################################

MAP_ARGS = --read_settings_files=on --write_settings_files=off \
		   $(addprefix --source=,$(SRCS))

FIT_ARGS = --part=$(PART) --read_settings_files=on --write_settings_files=off
ASM_ARGS =
STA_ARGS =

###################################################################
# Target implementations
###################################################################

STAMP = echo done >

$(PROJECT).map.rpt: map.chg $(SRCS)
	quartus_map $(MAP_ARGS) $(PROJECT)
	$(STAMP) fit.chg

$(PROJECT).fit.rpt: fit.chg $(PROJECT).map.rpt
	quartus_fit $(FIT_ARGS) $(PROJECT)
	$(STAMP) asm.chg
	$(STAMP) sta.chg

$(PROJECT).asm.rpt: asm.chg $(PROJECT).fit.rpt
	quartus_asm $(ASM_ARGS) $(PROJECT)

$(PROJECT).sta.rpt: sta.chg $(PROJECT).fit.rpt
	quartus_sta $(STA_ARGS) $(PROJECT) 

smart.log: $(ASSIGNMENT_FILES) $(SRCS)
	quartus_sh --determine_smart_action $(PROJECT) > smart.log

###################################################################
# Project initialization
###################################################################

#$(ASSIGNMENT_FILES):
#	quartus_sh --prepare -f $(FAMILY) -t $(TOP_LEVEL_ENTITY) $(PROJECT)
#	-cat $(BOARDFILE) >> $(PROJECT).qsf
map.chg:
	$(STAMP) map.chg
fit.chg:
	$(STAMP) fit.chg
sta.chg:
	$(STAMP) sta.chg
asm.chg:
	$(STAMP) asm.chg

###################################################################
# Programming the device
###################################################################

program: $(PROJECT).sof
	quartus_pgm --no_banner --mode=jtag -o "P;$(PROJECT).sof"

program-pof: $(PROJECT).pof
	quartus_pgm --no_banner --mode=jtag -o "BVP;$(PROJECT).pof"
