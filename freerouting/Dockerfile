FROM eclipse-temurin:21

LABEL Description="autoroute .kicad_pcb files using freerouting and jre 21"

# used with docker run -v /path/to/your/pcb:/freerouting
# and -e INPUT=pcbname

RUN mkdir /freerouting

WORKDIR /freerouting
RUN wget https://github.com/freerouting/freerouting/releases/download/v2.0.1/freerouting-2.0.1.jar -O /freerouting.jar

CMD java -jar /freerouting.jar \
    --gui.enabled=false \
    -da \
    -mp 25 \
    -us global \
    -de /freerouting/$INPUT.dsn \
    -do /freerouting/$INPUT.ses \
