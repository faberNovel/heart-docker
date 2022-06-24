# heart-docker-standard

[![Super-Linter](https://github.com/faberNovel/heart-docker/workflows/lint-code/badge.svg?event=workflow_dispatch)](https://github.com/faberNovel/heart-docker/blob/main/.github/workflows/linter.yaml) [![Example](https://github.com/faberNovel/heart-docker/workflows/ci-working-example/badge.svg)](https://github.com/faberNovel/heart-docker/blob/main/.github/workflows/example.yaml)

heart-docker-standard provides a standard docker image of Heart to be used as an internal quality standard for web projects at Fabernovel within Github Actions or any similar CI tool.

Heart is an open-source website quality analysis tool developed by _Fabernovel_, relying on a variety of third-party services such as _Mozilla Observatory_ or _Google Lighthouse_. The heart-docker-standard image only supports use of Heart's Dareboost and Slack modules via Heart's CLI.

For more details, see [Heart's official website](https://heart.fabernovel.com) and [Heart's official GitLab repository](https://gitlab.com/fabernovel/heart).

# Available versions

## Tagging convention

Heart Docker images are versioned with the syntax:

`fabernovel/heart:<A>-<B>-v<major>.<minor>.<patch>`.

`A`: Name of the analysis module used in image, lowercase.
`B`: Name of the listener module(s) used in image, lowercase and separated with a hyphen ("`-`") symbol.

Versioning increments follow the rules of [Semantic Versioning 2.0.0](http://google.com), i.e.:
* **Major**: Breaking change, i.e. not backwards compatible
* **Minor**: New functionality, backwards compatible
* **Patch**: Backward compatible bug fixes


Example:

`fabernovel/heart:dareboost-slack-v1.0.0`


## List of available versions

| Image full name | Description | Latest tag |
|-----------------|-------------|------------|
|`heart:dareboost-slack-vx.x.x`| Parses all JSON files in a configuration folder (and recursively in subfolders), runs **Dareboost** analyses and sends **Slack** notifications once the latter complete.| **dareboost-slack-v1.0.0** |

# How to use heart-docker on my project?

## Step 1 - Create configuration files

Create a configuration folder in your project. The default path for this configuration folder is `ci/heart/config`. Inside this folder, create a `dareboost` folder to hold the JSON configuration files to be provided for a Dareboost analysis. JSON files can be placed in subfolders at will for more clarity.

```
mkdir -p ci/heart/config/dareboost
```

Below is an example of file structure for your configuration folder:

```
├── README.md
├── ci
│   └── heart
│       └── config
│           └── dareboost
│               └── homepage
│                   └── mobile.json
│                   └── desktop.json
│               └── contact
│                   └── mobile.json
│                   └── desktop.json
│               └── userDashboard
│                   └── mobile.json
│                   └── desktop.json
```

The content of each JSON file must follow the [request format API documentation](https://www.dareboost.com/en/documentation-api#analyse), except for the `token` property. Below is a simple example of such a configuration:

```json
{
    "url": "https://www.heart.fabernovel.com/",
    "lang": "fr",
    "location": "Paris",
    "browser": {
        "name": "iPhone 6s/7/8 (BETA)"
    },
    "mobileAnalysis": true,
    "isPrivate": true
  }
```

## Step 2 - Setup secret variables in your project

In order to use Dareboost and Slack, the following variables must be defined and accessible from your CI workflow. Define the following variables in your project's secrets (if not already defined at organization level):

```
DAREBOOST_API_TOKEN=<dareboost-token>
SLACK_API_TOKEN=<slack-token>
SLACK_CHANNEL_ID=<slack-channel-name>
```

## Step 3 - Create a CI workflow

Define a CI workflow in the appropriate folder (for Github, workflows should be defined in the `.github/workflows` folder). Below is an example of workflow making use of the `heart-docker` image (do not forget to set the tag name of the image to be used):

```yaml
name: 'Website performance analysis'

on:
  workflow_dispatch: ~
  schedule:
    # Cron syntax: <min> <hour> <day-of-month> <month> <day-of-week>
    # Examples: https://crontab.guru/
    - cron: '0 9 * * 1'

env:
  CONFIG_DIRECTORY: 'ci/heart/config'       # path to your configuration directory
  CONTAINER_DEFAULT_NAME: 'heart-container' # can be left unchanged

jobs:
  heart-standard:
    name: 'Heart standard batch analysis'
    runs-on: [self-hosted, docker]

    steps:
      # - name: 'Clean workspace before repository checkout'
      #   uses: AutoModality/action-clean@v1

      - uses: actions/checkout@v2
        with:
          fetch-depth: 0

      - name: Heart standard analysis batch
        run: >
          docker run
          --rm
          --name ${{ env.CONTAINER_DEFAULT_NAME }}
          -e DAREBOOST_API_TOKEN=${{ secrets.DAREBOOST_API_TOKEN }}
          -e SLACK_API_TOKEN=${{ secrets.SLACK_API_TOKEN }}
          -e SLACK_CHANNEL_ID=${{ secrets.SLACK_CHANNEL_ID }}
          -v ${{ github.workspace }}/${{ env.CONFIG_DIRECTORY }}:/usr/heart/config
          fabernovel/heart:<image-tag>

      # - name: 'Clean workspace at end of workflow execution'
      #   uses: AutoModality/action-clean@v1
      #   if: ${{ always() }}
```

# Updating and publishing images

## Image build and publishing

```
# Step 1 : Log in
docker login --username <your-username>

# Step 2 : Type your password in prompt...

# Locally build the image to be published (use the above tagging convention for tag definition)
docker build -t fabernovel/heart:<tagname> .

# Push image to public registry
docker push fabernovel/heart:<tagname>
```

## Container start

The container can be started with the following command. The configuration folder holding all configuration files is to be mounted to `/usr/heart/config`. 

```shell
docker run
    --rm
    --name heart-container
    -v "$(pwd)/ci/heart/config:/usr/heart/config"
    -e SLACK_CHANNEL_ID=<channel-name>
    -e DAREBOOST_API_TOKEN=<darebost-api-token>
    -e SLACK_API_TOKEN=<slack-api-token> fabernovel/heart:standard
```

## Link to DockerHub

https://hub.docker.com/repository/docker/fabernovel/heart
