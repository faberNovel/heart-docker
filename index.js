const { promisify } = require("util");
const { exec } = require("child_process");
const execCmd = promisify(exec);
const glob = promisify(require("glob"));

// Parameter definition

const rootPath = "/usr/heart"
const configDirectory = "config";
const baseCommand = "npx heart dareboost";

// Step 1 : List all configuration files to be used for analysis

const findConfigurationFiles = (directory) =>
  glob(rootPath + "/" + directory + "/**/*.json");

// Step 2 : Launch a series of analyses based on a given list of configuration files

const launchJobs = async (files) => {
  let results = {};

  for (const filePath of files) {
    console.log(`Launching analysis for file: ${filePath}...`);

    const fullCommand = `${baseCommand} --file ${filePath} || true`
    let res = await execCmd(fullCommand);
    results[filePath] = res;

    console.log("Result or current analysis: ")
    console.log(res);
  }

  return results;
};

const runAllSteps = async () => {
  try {
    const files = await findConfigurationFiles(configDirectory);
    console.log("Found configuration files:");
    console.log(files);

    const results = await launchJobs(files);
    console.log("Printing analysis results:");
    console.log(results);

  } catch (error) {
    console.log(error.message);
  }
};

runAllSteps();
