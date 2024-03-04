# PowerMaster+ Docker container

Runs PowerMaster+ UPS management software from a Docker container. 
Original idea from [Reddit](https://www.reddit.com/r/homelab/comments/13pnjnm/powerwalker_ups_powermaster_software_in_docker/) and Fredrik Jönsson (see https://github.com/fjollberg/rpi-powerwalker-plus)


## PowerMaster+

PowerMaster is the controller software for [BlueWalker/PowerWalker](https://powerwalker.com/)
UPS devices.

The software is organised in a "Local" component, typically run on a computer with
a USB-connection with the UPS device, and a "Remote" component, run on all other
hosts which listens to UPS events "Local" broadcasts.

This container provides the "Local" service.

## Makefile Usage

Before to start check and in case change the Makefile entry:

    PMASTERP_URL="https://powerwalker.com/wp-content/uploads/2022/01/pmp122_linux64.zip"

The Makefile is offering following entrypoints:

    all         -->  Build&Setup  Powerwalker+  image&container
    build       -->  Build        Powerwalker+  image
    setup       -->  Setup        Powerwalker+  container
    start       -->  Start        Powerwalker+  container
    stop        -->  Stop         Powerwalker+  container
    connect     -->  Connect      Powerwalker+  container
    cleanup     -->  Cleanup      Powerwalker+  container&image
    imagedebug  -->  Start        Powerwalker+  (debug-purpose)

## Setup and usage

PowerMaster+ Docker container setup is done issuing:

```make all```

or

```make build```

```make run```

later you can browse to [http://localhost:3052/local](http://localhost:3052/local)

## Stop PowerMaster+ Docker container

You can stop PowerMaster+ Docker container issuing:

```make stop``` 

## Start PowerMaster+ Docker container

Once built You can start PowerMaster+ Docker container issuing:

```make start``` 

## Cleanup PowerMaster+ Docker image & container

You can cleanup PowerMaster+ Docker image & container issuing:

```make cleanup``` 

## "Development" and Testing

### Connecting to the container

```make connect```

### Running the service manually.

Connecting to the container with another shell makes it possible to kill
the java process and start a new manually in order to catch output.

```./jre/bin/java -classpath lib/Startup.jar -Xmx256m -Xms128m -Djava.net.preferIPv4Stack=true -Djava.library.path=./bin -Djava.ext.dirs=./jre/lib/ext com.cyberpowersystems.ppbe.startup.Startup start```

Assuming you use the provided jre and that /opt/pmasterp/data is the current
working directory.
