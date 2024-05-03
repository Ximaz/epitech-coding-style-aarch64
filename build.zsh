#!/bin/zsh

BANANA_VERA_REPOSITORY="https://${PERSONNAL_ACCESS_TOKEN}@github.com/Epitech/banana-coding-style-checker"
TAG="latest"

build() {
    docker build --no-cache --tag "${DOCKERHUB_REPOSITORY}:${TAG}" .
}

get_banana_vera_profile() {
    rm -rf vera
    git clone "${BANANA_VERA_REPOSITORY}" banana
    mv banana/vera .
    rm -rf banana
}

deploy() {
    echo "${DOCKERHUB_TOKEN}" | docker login -u "${DOCKERHUB_USERNAME}" --password-stdin
    docker push "${DOCKERHUB_REPOSITORY}"
    git push origin main
}

main() {
    get_banana_vera_profile
    build
    rm -rf vera
    deploy
}

main
