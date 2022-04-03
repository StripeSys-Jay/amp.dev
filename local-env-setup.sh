#!/bin/bash 

usage () {
echo "
  Usage: ./local-env-setup.sh [options]
  Options:
    --help | --usage: Prints the help message.
    --build: Set up and starts the local dev environment (npm install + npm run bootstrap).
    --reload: Reloads the app (npm run develop)
    --clean: Stops and delete the local dev env; deletes docker
             Images and containers.
      "
}

build () {

    echo "1/3 - Run: NPM INSTALL"
    docker-compose run amp.dev npm install || { echo "NPM INSTALL failed.";exit 1; }
    echo "2/3 - Run: NPM RUN BOOTSTRAP"
    docker-compose run amp.dev npm run bootstrap ||  { echo "NPM RUN BOOTSTRAP failed.";exit 1; }
    echo "3/3 - Run: NPM RUN DEVELOP"
    docker-compose run amp.dev npm run develop ||  { echo "NPM RUN DEVELOP failed.";exit 1; }
}

reload () {
    echo " Run Reload CMD: NPM RUN DEVELOP"
    docker-compose run amp.dev npm run develop || { echo "RELOAD CMD: NPM RUN DEVELOP failed.";exit 1; }
}
clean () {
    echo "This feature is in progress."
}

TOTAL_ARGS=$#
[[ $TOTAL_ARGS -ne 1 ]] && { echo "Incorrect usage. See help (--usage)"; exit 1; }

INPUT=$1

case $INPUT in 
    --help) 
        usage
        ;;
    --build)
        build
        ;;
    --reload)
        reload 
        ;;
    --clean)
        clean
        ;;
    *)
      echo "Sorry dev, I won't let you do that. See usage (--help)"
esac
        

           