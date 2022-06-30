FROM node:14.19.1-alpine

ARG AMP_DOC_TOKEN
# Install dependencies
RUN apk --no-cache add g++ gcc libgcc libstdc++ linux-headers make python3 python3-dev py3-pip yaml-dev git

RUN pip3 install --global-option="--with-libyaml" --force pyyaml && \
    pip3 install grow

WORKDIR /usr/src/app

COPY . .
RUN npm install 


RUN \ 
    mkdir -p dist/static/samples && \
    mkdir -p dist/static/files && \
    cp extras/samples.json dist/static/samples/samples.json

RUN npm run bootstrap

CMD npm run develop



