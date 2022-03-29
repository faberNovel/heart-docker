# heart-docker-standard

heart-docker-standard provides a standard docker image of Heart to be used as an internal quality standard for web projects at Fabernovel.

Heart is an open-source website quality analysis tool developed by _Fabernovel_, relying on a variety of third-party services such as _Mozilla Observatory_ or _Google Lighthouse_. The heart-docker-standard image only supports use of Heart's Dareboost and Slack modules via Heart's CLI.

For more details, see [Heart's official website](https://heart.fabernovel.com) and [Heart's official GitLab repository](https://gitlab.com/fabernovel/heart).

# Useful commands

## Image build

```
docker build -t fabernovel/heart:<tagname> .
```
## Image release to Fabernovel DockerHub

```
docker login --username <your-username>

# Type your password in prompt...

docker push fabernovel/heart:<tagname>

```

## Link to DockerHub

https://hub.docker.com/repository/docker/fabernovel/heart
