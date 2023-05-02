## source code files index.html, counter.css and counter.js
## Dockerfile to build image
## docker build . -t amrit96/counter:7
## docker push amrit96/counter:7 ## this will create the required image and push to my dockerhub repository


# goc
## run this counter application locally to check if image works as expected and then only push to dockerhub
docker run -p 8080:80 myimage
