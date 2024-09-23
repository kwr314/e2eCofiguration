Description of the Code
The e2eInit.sh script is designed to set up an end-to-end (E2E) testing environment using Playwright and Allure for reporting. It installs necessary dependencies, configures the testing environment, and sets up reporting tools. Here’s a step-by-step breakdown of what the script does:

Unset NODE_TLS_REJECT_UNAUTHORIZED: Ensures that the environment variable NODE_TLS_REJECT_UNAUTHORIZED is unset.

Install Project Dependencies: Installs all project dependencies listed in package.json using npm install.

Install Playwright: Initializes Playwright in the current directory.

Install Allure Command Line Tool: Installs the Allure command line tool as a development dependency.

Install Allure Reporter for Playwright: Installs the Allure reporter for Playwright as a development dependency.

Create tsconfig.json: Creates a TypeScript configuration file in the e2e_tests directory, extending the root tsconfig.json if it exists.

Create Playwright Configuration: Overwrites playwright.config.ts with a new configuration tailored for the project.

Delete tests-examples Folder: Removes the tests-examples folder if it exists.

Create Necessary Folders: Creates several folders within the e2e_tests directory for organizing tests, tasks, utilities, and data.

Append Paths to .gitignore: Adds specific paths to the .gitignore file to exclude certain files and directories from version control.

Install ESLint and Prettier: Installs ESLint and Prettier along with their configurations for code linting and formatting.

Initialize ESLint Configuration: Runs the ESLint initialization command.

Install Rimraf: Installs rimraf for cross-platform file removal.

Add Scripts to package.json: Adds several scripts to the package.json file for linting, cleaning, testing, and generating reports.

Run Initial Test: Runs an initial Playwright test to verify the setup.

Test Allure Installation: Checks the installed version of Allure.

Generate and Open Allure Report: Generates an Allure report and opens it.


Step-by-Step Instructions
Ensure Prerequisites:

Make sure you have Node.js and npm installed.
Ensure you have Git Bash installed on your Windows machine.
Clone Your Repository:

Run the Script:

If the script is located in a different folder, specify the full path to the script while in your repository directory:
Verify the Setup:

The script will automatically run an initial test and generate an Allure report. Check the output in the terminal to ensure everything is set up correctly.
Use the Added Scripts:

You can now use the added scripts in package.json for various tasks:
By following these steps, other users can set up and utilize the E2E testing environment configured by the e2eInit.sh script.
