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


# PowerMaster+ URL zip file
#--------------------------
PMASTERP_URL="https://powerwalker.com/wp-content/uploads/2022/01/pmp122_linux64.zip"


#------------------------------------------------------------------
#------------------------------------------------------------------
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
help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sed -n 's/^\(.*\): \(.*\)##\(.*\)/\1\3/p' \
	| column -t  -s ' '

all: build setup ## ✅ Build&Setup Powerwalker+

build: ## 🏗️ ️Build Powerwalker+ image$container
	@echo "$(COLOUR_YELLOW)-----------------------------------------$(COLOUR_END)"
	@echo "$(COLOUR_YELLOW)🏗️ Build PowerMaster+ Docker container...$(COLOUR_END)"
	@echo "$(COLOUR_YELLOW)-----------------------------------------$(COLOUR_END)"
	sudo mkdir -p /opt/pmasterp
	docker build \
	--force-rm=true \
	--build-arg PMASTERP_URL=$(PMASTERP_URL) \
	--tag rpi-powerwalker-plus:latest \
	-f Dockerfile .

connect: ## 🖧 Connect Powerwalker+ container
	@echo "$(COLOUR_GREEN)-------------------------------------------$(COLOUR_END)"
	@echo "$(COLOUR_GREEN)🖧 Connect PowerMaster+ Docker container...$(COLOUR_END)"
	@echo "$(COLOUR_GREEN)-------------------------------------------$(COLOUR_END)"
	@docker exec -it powermaster /bin/bash

cleanup: ## 🧹 Cleanup Powerwalker+ container&image
	@echo "$(COLOUR_GREEN)-------------------------------------------$(COLOUR_END)"
	@echo "$(COLOUR_GREEN)🧹 Cleanup PowerMaster+ Docker container...$(COLOUR_END)"
	@echo "$(COLOUR_GREEN)-------------------------------------------$(COLOUR_END)"
	-docker stop powermaster
	-docker rm powermaster
	-docker rmi rpi-powerwalker-plus:latest
	sudo rm -fr /opt/pmasterp

setup: ## 🔧 Setup Powerwalker+ container
	@echo "$(COLOUR_BLUE)-----------------------------------------$(COLOUR_END)"
	@echo "$(COLOUR_BLUE)🔧 Setup PowerMaster+ Docker container...$(COLOUR_END)"
	@echo "$(COLOUR_BLUE)-----------------------------------------$(COLOUR_END)"
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
	@sleep 20
	@echo "$(COLOUR_GREEN)------------------------------------$(COLOUR_END)"
	@echo "$(COLOUR_GREEN)Connect http://localhost:3052/local $(COLOUR_END)"
	@echo "$(COLOUR_GREEN)------------------------------------$(COLOUR_END)"

start: ## 🚀 Start Powerwalker+ container
	@echo "$(COLOUR_GREEN)--------------------------------------------$(COLOUR_END)"
	@echo "$(COLOUR_GREEN)🚀 Starting PowerMaster+ Docker container...$(COLOUR_END)"
	@echo "$(COLOUR_GREEN)--------------------------------------------$(COLOUR_END)"
	@docker start powermaster
	@echo "Startup in progress, please wait..."
	@sleep 5
	@echo "$(COLOUR_GREEN)------------------------------------$(COLOUR_END)"
	@echo "$(COLOUR_GREEN)Connect http://localhost:3052/local $(COLOUR_END)"
	@echo "$(COLOUR_GREEN)------------------------------------$(COLOUR_END)"

status: ## 🔎 Status Powerwalker+ container
	@echo "$(COLOUR_GREEN)--------------------------------------------$(COLOUR_END)"
	@echo "$(COLOUR_GREEN)🔎 Status PowerMaster+ Docker container...$(COLOUR_END)"
	@echo "$(COLOUR_GREEN)--------------------------------------------$(COLOUR_END)"
	@docker ps -f name=powermaster --format '{{.Status}}'

stop: ## 🛑 Stop Powerwalker+ container
	@echo "$(COLOUR_GREEN)--------------------------------------------$(COLOUR_END)"
	@echo "$(COLOUR_GREEN)🛑 Stopping PowerMaster+ Docker container...$(COLOUR_END)"
	@echo "$(COLOUR_GREEN)--------------------------------------------$(COLOUR_END)"
	@docker stop powermaster

imagedebug: ## 🐞 Start Powerwalker+ (debug-purpose)
	@echo "$(COLOUR_RED)------------------------------------------$(COLOUR_END)"
	@echo "$(COLOUR_RED)🐞 Imagedebug PowerMaster+ Docker image...$(COLOUR_END)"
	@echo "$(COLOUR_RED)------------------------------------------$(COLOUR_END)"
	docker run -it --entrypoint /bin/bash rpi-powerwalker-plus -s

logs: ## 📜 Logs Powerwalker+ container
	@echo "$(COLOUR_GREEN)--------------------------------------------$(COLOUR_END)"
	@echo "$(COLOUR_GREEN)📜 Logs for PowerMaster+ Docker container...$(COLOUR_END)"
	@echo "$(COLOUR_GREEN)--------------------------------------------$(COLOUR_END)"
	@ID=$$(docker ps -f name=powermaster |tail -1 |colrm 12) && docker logs $$ID
###############################################################################
# End Of File                                                                 #
###############################################################################
