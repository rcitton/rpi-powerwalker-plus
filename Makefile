#!/usr/bin/env make
# -----------------------------------------------------------------
#
#    NAME
#      PowerMaster+ Docker container
#
#    DESCRIPTION
#      PowerMaster+ Docker container makefile
#
#    AUTHOR:
#      rcitton@gmail.com 
#
#    NOTES
#
#    MODIFIED   (MM/DD/YY)
#    rcitton     03/02/24 - creation
#
# -----------------------------------------------------------------


# PowerMaster+ zip file
#------------------------------
PMASTERP_ZIP=pmp122_linux64.zip


###########################
## Colors definition     ##
###########################
COLOUR_GREEN=\033[0;32m
COLOUR_RED=\033[0;31m
COLOUR_YELLOW=\033[0;33m
COLOUR_BLUE=\033[0;34m
COLOUR_END=\033[0m

.DEFAULT_GOAL := help
.PHONY: help

###############################################################################
#  MAIN CONTAINERS SECTION                                                    #
###############################################################################
all: build setup

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sed -n 's/^\(.*\): \(.*\)##\(.*\)/\1\3/p' \
	| column -t  -s ' '

build: ## --> Build Powerwalker+
	@echo "$(COLOUR_YELLOW)--------------------------------------$(COLOUR_END)"
	@echo "$(COLOUR_YELLOW)Build PowerMaster+ Docker container...$(COLOUR_END)"
	@echo "$(COLOUR_YELLOW)--------------------------------------$(COLOUR_END)"
ifeq (,$(wildcard $(PMASTERP_ZIP)))
	@echo "$(COLOUR_RED)Missing required $(PMASTERP_ZIP) $(COLOUR_END)"
	exit 1
endif
	sudo mkdir -p /opt/pmasterp
	docker build \
	--force-rm=true \
	--build-arg PMASTERP_ZIP=$(PMASTERP_ZIP) \
	--tag rpi-powerwalker-plus:latest \
	-f Dockerfile .

setup: ## --> Setup Powerwalker+
	@echo "$(COLOUR_BLUE)--------------------------------------$(COLOUR_END)"
	@echo "$(COLOUR_BLUE)Setup PowerMaster+ Docker container...$(COLOUR_END)"
	@echo "$(COLOUR_BLUE)--------------------------------------$(COLOUR_END)"
	docker run --detach \
	--name powermaster \
	--hostname pmasterp \
	-p 3052:3052 \
	-p 3052:3052/udp \
	-p 53568:53568/udp \
	-p 162:162/udp \
	-p 53566:53566/udp \
	-v /opt/pmasterp:/opt/pmasterp/data \
	--privileged rpi-powerwalker-plus:latest
	@echo "Setup in progress, please wait..."
	sleep 20
	@echo "$(COLOUR_GREEN)------------------------------------$(COLOUR_END)"
	@echo "$(COLOUR_GREEN)Connect http://localhost:3052/local $(COLOUR_END)"
	@echo "$(COLOUR_GREEN)------------------------------------$(COLOUR_END)"

start: ## --> Start Powerwalker+
	@echo "$(COLOUR_GREEN)--------------------------------------$(COLOUR_END)"
	@echo "$(COLOUR_GREEN)Start PowerMaster+ Docker container...$(COLOUR_END)"
	@echo "$(COLOUR_GREEN)--------------------------------------$(COLOUR_END)"
	docker start powermaster
	@echo "Sleep 5 secs..."
	sleep 5
	@echo "$(COLOUR_GREEN)------------------------------------$(COLOUR_END)"
	@echo "$(COLOUR_GREEN)Connect http://localhost:3052/local $(COLOUR_END)"
	@echo "$(COLOUR_GREEN)------------------------------------$(COLOUR_END)"

stop: ## --> Stop Powerwalker+
	@echo "$(COLOUR_GREEN)-------------------------------------$(COLOUR_END)"
	@echo "$(COLOUR_GREEN)Stop PowerMaster+ Docker container...$(COLOUR_END)"
	@echo "$(COLOUR_GREEN)-------------------------------------$(COLOUR_END)"
	docker stop powermaster

connect: ## --> Connect Powerwalker+
	@echo "$(COLOUR_GREEN)----------------------------------------$(COLOUR_END)"
	@echo "$(COLOUR_GREEN)Connect PowerMaster+ Docker container...$(COLOUR_END)"
	@echo "$(COLOUR_GREEN)----------------------------------------$(COLOUR_END)"
	docker exec -it powermaster /bin/bash

cleanup: ## --> Cleanup Powerwalker+
	@echo "$(COLOUR_GREEN)----------------------------------------$(COLOUR_END)"
	@echo "$(COLOUR_GREEN)Cleanup PowerMaster+ Docker container...$(COLOUR_END)"
	@echo "$(COLOUR_GREEN)----------------------------------------$(COLOUR_END)"
	-docker stop powermaster
	-docker rm powermaster
	-docker rmi rpi-powerwalker-plus:latest
	sudo rm -fr /opt/pmasterp

imagedebug: ## --> Start Powerwalker+ image for debug purpuse
	@echo "$(COLOUR_RED)---------------------------------------$(COLOUR_END)"
	@echo "$(COLOUR_RED)Imagedebug PowerMaster+ Docker image...$(COLOUR_END)"
	@echo "$(COLOUR_RED)---------------------------------------$(COLOUR_END)"
	docker run -it --entrypoint /bin/bash rpi-powerwalker-plus -s
###############################################################################
# End Of File                                                                 #
###############################################################################
