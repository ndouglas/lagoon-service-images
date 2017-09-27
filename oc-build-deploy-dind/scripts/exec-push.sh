#!/bin/bash

docker tag ${TEMPORARY_IMAGE_NAME} ${OPENSHIFT_REGISTRY}/${OPENSHIFT_PROJECT}/${IMAGE_NAME}:latest

for i in {1..4}; do docker push ${OPENSHIFT_REGISTRY}/${OPENSHIFT_PROJECT}/${IMAGE_NAME}:latest && break || sleep 5; done

