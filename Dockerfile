FROM alpine/helm:3.5.3

LABEL version="1"
LABEL repository="https://github.com/almed4/helm-check-action"
LABEL maintainer="Igor Gabaydulin"

LABEL com.github.actions.name="GitHub Action for Helm Templates Validation and Packaging"
LABEL com.github.actions.description="Checks if helm templates are valid and packages"
LABEL com.github.actions.icon="cloud"
LABEL com.github.actions.color="blue"

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["sh", "/entrypoint.sh"]

