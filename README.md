<p align="center">
    <img alt="Violet square with rounded corners, featuring a heart in the form of a cloud of dots. Some of the dots are interconnected" src="./docs/images/heart.png" title="Heart" width="128">
</p>

<p align="center">A command-line tool to industrialize web quality measurement.</p>

# Description

Heart is a tool that centralize the use of famous web quality measurement services ([_Google Lighthouse_](https://pagespeed.web.dev/), [_GreenIT Analysis_](https://www.ecoindex.fr/) or [_Mozilla Observatory_](https://observatory.mozilla.org/)) in a unique CLI

With his modular approach, it makes easy to process the analysis results into a database to track metrics over time, or send them into a communication tool like Slack.

Moreover, the command-line interface allows a smooth integration into a CI/CD chain, particularly on GitHub where you can make use of [the dedicated GitHub Action](https://github.com/marketplace/actions/heart-webpages-evaluation).

For more details, see [Heart's website](https://heart.fabernovel.com) and [Heart's repository](https://github.com/fabernovel/heart).

# Usage

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
