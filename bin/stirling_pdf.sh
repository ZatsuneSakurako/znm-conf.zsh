#!/bin/bash
containerName="stirling-pdf"
if [ "$(docker inspect -f '{{.State.Running}}' "$containerName")" == "true" ]; then
	echo "Stirling PDF already running"
else
	docker run --rm --name "$containerName" -p 8080:8080 \
		-e SECURITY_ENABLELOGIN=false \
		-e SYSTEM_DEFAULTLOCALE=en-GB \
		docker.stirlingpdf.com/stirlingtools/stirling-pdf:latest
fi
