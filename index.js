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

// Step 3 : Parse results and set return status based on presence or absence of errors

const checkForErrors = (resultObject) => {
    let errorCounter = 0;
    for (const key in resultObject) {
        if(resultObject[key].stderr !== '') errorCounter++
    }

    if(errorCounter!== 0) {
        console.log(`Error: ${errorCounter} errors encountered.`)
        process.exit(1)
    }
}

const runAllSteps = async () => {
  try {
    const files = await findConfigurationFiles(configDirectory);
    console.log("Found configuration files:");
    console.log(files);

    if(files.length === 0) {
        console.log("Error: No configuration files found!")
        process.exit(1)
    }

    const results = await launchJobs(files);

    const status = checkForErrors(results);
    return status;

  } catch (error) {
    console.log(error.message);
    process.exit(1)
  }
};

runAllSteps();
