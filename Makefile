SHELL := /bin/bash

deploy-staging:
	serverless deploy --verbose --force --stage staging --region us-east-2 --org f72e1c13062e4f45ad951530acf9e5a7

deps:
	@. ~/.nvm/nvm.sh; nvm use; node --version
	sudo pacman -Syu --needed docker pyenv
	sudo systemctl start docker.service
	sudo systemctl enable docker.service
	npm install -g serverless

python:
	pyenv install 3.12.0
	python3 -m venv venv

pipenv:
	#python3 -m ensurepip --upgrade
	pip3 install --upgrade pip
	pip3 install pipenv
	pipenv --python 3.12

invoke-staging:
	serverless invoke --stage staging --region us-east-2 --function demo
