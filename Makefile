PROJECT=php7
REPO=145351228327.dkr.ecr.eu-west-1.amazonaws.com/${PROJECT}
VERSION=0.5.1

docker-build:
	docker build -t ${PROJECT} .

docker-run: docker-build
	docker run --rm -it -p ${LISTEN_PORT}:80 ${PROJECT}

docker-deploy:
	docker build -t ${PROJECT}:${VERSION} .
	docker tag ${PROJECT}:${VERSION} ${REPO}:${VERSION}
	docker tag ${PROJECT}:${VERSION} ${REPO}:latest
	docker push ${REPO}:${VERSION}
	docker push ${REPO}:latest
