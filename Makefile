create:
	sls create --template-url "https://github.com/umihico/docker-selenium-lambda/tree/main" --path docker-selenium-lambda && cd $_

deploy-staging:
	serverless deploy --verbose --stage staging --region us-east-2 --org f72e1c13062e4f45ad951530acf9e5a7

deps:
	sudo pacman -Syu docker
	sudo systemctl start docker.service
	sudo systemctl enable docker.service

invoke-staging:
	serverless invoke --stage staging --region us-east-2 --function demo
