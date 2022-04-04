#!/bin/bash 

usage () {
echo "
  Usage: ./local-env-setup.sh [options]
  Options:
    --help | --usage: Prints the help message.
    --build: Set up and starts the local dev environment (npm install + npm run bootstrap).
    --reload: Reloads the app (npm run develop)
    --clean: Stops (if running) and removes all the amp.dev containers and networks.
             Does not delete amp.dev image(s), volumes and source-code.
    --clean-all: Stops and deletes the amp.dev containers, images and networks. 
                 Does not delete amp.dev volumes and source-code.       
             
      "
}

build () {

    echo "PRE-BUILD CHECKS & SETUP."
    echo "1/2 - Run: Check PAT existence."
    if [ ! -f .env ];then 
    echo "INFO: .env not found, creating it in the current context." 
    echo "Please enter the GitHub PAT."
    read PAT
    echo "AMP_DOC_TOKEN=$PAT" > .env
    else

    PAT=$(grep "AMP_DOC_TOKEN" .env | awk -F"=" '{print $2}')
    if [[ ! -n $PAT ]];then
    echo "INFO: .env exists, but PAT value missing. Please, enter the GitHub PAT."
    read PAT
    echo "AMP_DOC_TOKEN=$PAT" > .env
    fi
    fi 
    echo "1/2 - Run: Check PAT existence...OK"

    echo "2/2 - Run: Check Directory structure."

    [ ! -d dist/static/samples ] && mkdir -p dist/static/samples
    [ ! -d dist/static/files ] && mkdir -p dist/static/files
    [ ! -f dist/static/samples/samples.json ] && touch dist/static/samples/samples.json 
    
    echo "2/2 - Run: Check Directory structure...OK"

    echo "Pre-Build Setup Completed."
    echo
    echo "BUILDING AMP.DEV"
    echo

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
    docker-compose down 
}

clean-all (){
    docker-compose down --rmi local 
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
    --clean-all)
        clean-all
        ;;
    *)
      echo "Sorry dev, I won't let you do that. See usage (--help)"
        ;;
esac
        

           