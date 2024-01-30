SHELL := /bin/bash

deploy-staging:
	serverless deploy --verbose --force --stage staging --region us-east-2 --org f72e1c13062e4f45ad951530acf9e5a7

# install os-level dependencies (arch linux)
deps:
	@. ~/.nvm/nvm.sh; nvm use; node --version
	sudo pacman -Syu --needed docker pyenv
	yay -Syu chromedriver
	sudo systemctl start docker.service
	sudo systemctl enable docker.service
	npm install -g serverless

# install virtual python version and virtual environment in the project
python:
	pyenv install 3.12.0 # install 3.12.0 (matches the build image)
	pyenv local 3.12.0 # set 3.12.0 as the local interpreter to use with pyenv
	pyenv exec python3 -m venv venv # create a local virtual environment with python 3.12.0

# upgrade pip, install pipenv, and
pipenv:
	pip3 install --upgrade pip
	pip3 install pipenv
	pipenv install

invoke-staging:
	serverless invoke --stage staging --region us-east-2 --function demo
