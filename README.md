# heart-docker-standard

[![Super-Linter](https://github.com/faberNovel/heart-docker/workflows/lint-code/badge.svg?event=workflow_dispatch)](https://github.com/marketplace/actions/super-linter)

[![Example](https://github.com/faberNovel/heart-docker/workflows/ci-working-example/badge.svg)](https://github.com/marketplace/actions/super-linter)

heart-docker-standard provides a standard docker image of Heart to be used as an internal quality standard for web projects at Fabernovel within Github Actions or any similar CI tool.

Heart is an open-source website quality analysis tool developed by _Fabernovel_, relying on a variety of third-party services such as _Mozilla Observatory_ or _Google Lighthouse_. The heart-docker-standard image only supports use of Heart's Dareboost and Slack modules via Heart's CLI.

For more details, see [Heart's official website](https://heart.fabernovel.com) and [Heart's official GitLab repository](https://gitlab.com/fabernovel/heart).

# Useful commands

## Image build

```
docker build -t fabernovel/heart:<tagname> .
```

## Container start

The folder holding all the configuration files in JSON format is to be mounted to the Docker image, as well as the following environment variables:

- `DAREBOOST_API_TOKEN`: Dareboost API token of the user (API version 0.5 supported).
- `SLACK_API_TOKEN`: Slack API token of the user.
- `SLACK_CHANNEL_ID`: Name of the Slack channel to be notified.

```shell
docker run
    --rm
    --name heart-container
    -v "$(pwd)/ci/heart/config:/usr/heart/config"
    -e SLACK_CHANNEL_ID=<channel-name>
    -e DAREBOOST_API_TOKEN=<darebost-api-token>
    -e SLACK_API_TOKEN=<slack-api-token> fabernovel/heart:standard
```

## Image release to Fabernovel DockerHub

```
docker login --username <your-username>

# Type your password in prompt...

docker push fabernovel/heart:<tagname>

```

## Link to DockerHub

https://hub.docker.com/repository/docker/fabernovel/heart
