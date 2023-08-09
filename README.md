<p align="center">
    <img alt="Violet square with rounded corners, featuring a heart in the form of a cloud of dots. Some of the dots are interconnected" src="./docs/images/heart.png" title="Heart" width="128">
</p>

<p align="center">A command-line tool to industrialize web quality measurement.</p>

# Description

Heart is a tool that centralize the use of famous web quality measurement services ([_Google Lighthouse_](https://pagespeed.web.dev/), [_GreenIT Analysis_](https://www.ecoindex.fr/) or [_Mozilla Observatory_](https://observatory.mozilla.org/)) in a unique CLI

With his modular approach, it makes easy to process the analysis results into a database to track metrics over time, or send them into a communication tool like Slack.

Moreover, the command-line interface allows a smooth integration into a CI/CD chain.

For more details, see [Heart's website](https://heart.fabernovel.com) and [Heart's repository](https://github.com/fabernovel/heart).

# Usage

I want to:

- analyze <https://heart.fabernovel.com/> using the _Google Lighthouse_ service.
- get the main metrics and advices on a `heart` Slack channel when the analysis is over.
- check that the page grade reaches a minimum of 85 over 100.

## Run the container as an executable

In the following commands:

- replace `xoxb-remaining_token` by your Slack API token.
- replace `fabernovel/heart:<version>` by the Docker image tag you want to use, example: `fabernovel/heart:4.0.0`

### With the configuration as an inlined JSON

```shell
docker run --rm --env HEART_SLACK_API_TOKEN=xoxb-remaining_token fabernovel/heart:<version> lighthouse --config '{"url":"https://heart.fabernovel.com"}' --only-listeners=slack
```

💡 Heart as been designed to trigger all installed listener modules. The philosophy behind this is that you only install the modules you need. But in order to provide all module feature through a single Docker image, all modules had to be installed. So if you don't want to trigger all listener modules, don't forget to use the `--only-listeners` or `--except-listeners` option.

### With the configuration as a file on the host machine

Instead of an inlined JSON given to the `--config` option, you could prefer to specify the path to a file located on your host machine.

To achieve that, you will have to map the host filesystem with the one from te container with the `--volume` option of the docker run command:

```shell
docker run --rm --volume "$(pwd)/ci/config:/usr/heart/config" --env HEART_SLACK_API_TOKEN=xoxb-remaining_token fabernovel/heart:<version> lighthouse --config config/lighthouse.json --only-listeners=slack
```

💡 Explainations:

- `$(pwd)/ci/config` is the path on your host machine where the lighthouse.json file is located
- `/usr/heart` is the path inside the container where Heart is located

## Integration in a CI/CD chain

Take a look at the [GitHub Action]((https://github.com/marketplace/actions/heart-webpages-evaluation)) as an exemple of how to integrate this Docker image.
