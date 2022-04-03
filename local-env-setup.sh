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

    echo "PRE-BUILD SETUP: CHECK & CREATE DIRECTORY STRUCTURE"
    [ ! -d dist/static/samples ] && mkdir -p dist/static/samples
    [ ! -d dist/static/files ] && mkdir -p dist/static/files
    [ ! -f dist/static/samples/samples.json ] && touch dist/static/samples/samples.json 

    echo "1/3 - Run: NPM INSTALL"
    docker-compose run amp.dev npm install || { echo "NPM INSTALL failed.";exit 1; }
    echo "2/3 - Run: NPM RUN BOOTSTRAP"
    docker-compose run amp.dev npm run bootstrap ||  { echo "NPM RUN BOOTSTRAP failed.";exit 1; }
    echo "3/3 - Run: NPM RUN DEVELOP"
    docker-compose run -p 8080:8080 -p 8083:8083 amp.dev npm run develop ||  { echo "NPM RUN DEVELOP failed.";exit 1; }
}

reload () {
    echo "Run Reload CMD: NPM RUN DEVELOP"
    docker-compose run -p 8080:8080 -p 8083:8083 amp.dev npm run develop || { echo "RELOAD CMD: NPM RUN DEVELOP failed.";exit 1; } 
}
clean () {
    docker system prune 
}

TOTAL_ARGS=$#
[[ $TOTAL_ARGS -ne 1 ]] && { echo "Incorrect usage. See help (--usage)"; exit 1; }


INPUT=$1
LOG_PATH="/tmp/amp-dev-logs.txt"
case $INPUT in 
    --help) 
        usage
        ;;
    --build)
        build | tee -a $LOG_PATH 2>&1
        ;;
    --reload)
        reload | tee -a $LOG_PATH 2>&1
        ;;
    --clean)
        clean
        ;;
    *)
      echo "Sorry dev, I won't let you do that. See usage (--help)"
esac
        

           