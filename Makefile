.DEFAULT_GOAL := help

# https://www.gnu.org/software/make/manual/make.html


define BROWSER_PYSCRIPT
import os, webbrowser, sys

from urllib.request import pathname2url

webbrowser.open("file://" + pathname2url(os.path.abspath(sys.argv[1])))
endef
export BROWSER_PYSCRIPT


define PRINT_HELP_PYSCRIPT
import re, sys

hits = []
for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		parts = help.split('##', 1)
		if len(parts) == 2:
			params, help = parts[0].strip(), parts[1].strip()
		else:
			params, help = "", help.strip()
		hits.append([target, params, help])
if 1: hits.sort()
if hits:
	print("Available make targets:\n")
for target, params, help in hits:
	if params:
		params2 = " " + params
	else:
		params2 = ""
	print("make %-30s   %s" % (target + params2, help))
epilog = ("""
""")
if epilog:
	print(epilog)
endef
export PRINT_HELP_PYSCRIPT


BROWSER := python -c "$$BROWSER_PYSCRIPT"

.PHONY: help
help:  ## Show this help (default).
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)


.PHONY: build
build:  ## Build Docker container. Example: OUR_IMAGE_TAG=local OUR_IMAGE_SHORT=local make build
	/bin/bash  Dockerfile.build.sh


.PHONY: push_to_ghcr
push_to_ghcr:  ## [OUR_IMAGE_TAG] ## Example: OUR_IMAGE_TAG=local  make  push_to_ghcr
	docker tag ghcr.io/t3docs/render-documentation:$(OUR_IMAGE_TAG)
	docker push ghcr.io/t3docs/render-documentation:$(OUR_IMAGE_TAG)

