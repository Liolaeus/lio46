.PHONY: help

PCB_DIR = ergogen/output/pcbs

main: help

help:
	@echo "help              Show this help message"
	@echo "ergogen           Generate the PCBs from the ergogen config"
	@echo "freerouting-image Build the docker image for freerouting"
	@echo "dsn               Export the DSN files from the PCBs"
	@echo "ses               Run freerouting on the DSN files"
	@echo "ses-import        Import the SES files back into the PCBs"
	@echo "clean             Clean the generated .kicad_pcb, .dsn and .ses files"
	@echo "clean-all         Clean everything"


$(PCB_DIR)/left.kicad_pcb: ergogen/config.yaml ergogen/footprints/*
	@cd ergogen && ergogen . && cd ../

$(PCB_DIR)/right.kicad_pcb: ergogen/config.yaml ergogen/footprints/*
	@cd ergogen && ergogen . && cd ../

ergogen: $(PCB_DIR)/left.kicad_pcb $(PCB_DIR)/right.kicad_pcb


freerouting-image: freerouting/Dockerfile
	@docker build -t freerouting -f freerouting/Dockerfile .

dsn: ergogen $(PCB_DIR)/left.kicad_pcb $(PCB_DIR)/right.kicad_pcb
	@python3 freerouting/export_dsn.py -b $(PCB_DIR)/left.kicad_pcb -o $(PCB_DIR)/left.dsn
	@python3 freerouting/export_dsn.py -b $(PCB_DIR)/right.kicad_pcb -o $(PCB_DIR)/right.dsn

ses: dsn freerouting-image $(PCB_DIR)/left.dsn $(PCB_DIR)/right.dsn
	@docker run --name freertouting-left --rm -e INPUT=left -v ./ergogen/output/pcbs:/freerouting freerouting& \
	docker run --name freertouting-right --rm -e INPUT=right -v ./ergogen/output/pcbs:/freerouting freerouting

ses-import: ses $(PCB_DIR)/left.kicad_pcb $(PCB_DIR)/right.kicad_pcb $(PCB_DIR)/left.ses $(PCB_DIR)/right.ses
	@python3 freerouting/import_ses.py -b $(PCB_DIR)/left.kicad_pcb -s $(PCB_DIR)/left.ses -o $(PCB_DIR)/left_routed.kicad_pcb
	@python3 freerouting/import_ses.py -b $(PCB_DIR)/right.kicad_pcb -s $(PCB_DIR)/right.ses -o $(PCB_DIR)/right_routed.kicad_pcb

all: ergogen ses ses-import

clean:
	rm -rf ergogen/output
clean-all: clean
	docker image rm freerouting
