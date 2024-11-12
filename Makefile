.PHONY: venv

VENV_DIR = .venv
PCB_DIR = ergogen/output/pcbs


main: freeroute

$(VENV_DIR)/bin/activate:
	python3 -m venv $(VENV_DIR)
	$(VENV_DIR)/bin/pip install -r requirements.txt

ergogen: ergogen/config.yaml
	cd ergogen && ergogen .

freerouting-image:
	docker build -t freerouting -f freerouting/Dockerfile .

build: ergogen freerouting-image

dsn: $(VENV_DIR)/bin/activate
	python3 freerouting/export_dsn.py -b $(PCB_DIR)/left.kicad_pcb -o $(PCB_DIR)/left.dsn
	python3 freerouting/export_dsn.py -b $(PCB_DIR)/right.kicad_pcb -o $(PCB_DIR)/right.dsn

freeroute: build dsn
	docker run --rm -e INPUT=left -v $(pwd)/ergogen/output/pcbs:/freerouting freerouting
	docker run --rm -e INPUT=right -v $(pwd)/ergogen/output/pcbs:/freerouting freerouting

clean:
	rm -rf ergogen/output
clean-venv:
	rm -rf $(VENV_DIR)
clean-all: clean
	docker image rm freerouting
