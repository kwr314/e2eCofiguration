#!/bin/bash

# Unset NODE_TLS_REJECT_UNAUTHORIZED if it is set
unset NODE_TLS_REJECT_UNAUTHORIZED

# Install project dependencies
echo "Installing project dependencies..."
npm install

# Install Playwright
echo "Installing Playwright..."
npm init playwright@latest --prefix ./

# Install Allure command line tool
echo "Installing Allure command line tool..."
npm install allure-commandline --save-dev --prefix ./

# Install Allure reporter for Playwright
echo "Setting up Allure reporting..."
npm install --save-dev allure-playwright --prefix ./

# Create tsconfig.json within the e2e_tests folder
echo "Creating tsconfig.json file..."
if [ -f "../tsconfig.json" ]; then
  cat <<EOL > e2e_tests/tsconfig.json
{
  "extends": "../tsconfig.json",
  "compilerOptions": {
    "experimentalDecorators": true,
    "sourceMap": true,
    "isolatedModules": false,
    "types": ["node"],
    "paths": {
      "@data/*": ["../e2e_tests/data/*"],
      "@locators/*": ["../e2e_tests/locators/*"],
      "@queries/*": ["../e2e_tests/queries/*"],
      "@questions/*": ["../e2e_tests/questions/*"],
      "@tasks/*": ["../e2e_tests/tasks/*"],
      "@utils/*": ["../e2e_tests/utils/*"]
    }
  },
  "include": [
    "../playwright.config.ts",
    "../e2e_tests/**/*.spec.ts",
    "**/*.feature",
    "../e2e_tests/**/*.ts",
    "../e2e_tests/**/*.json"
  ]}
EOL
else
  cat <<EOL > e2e_tests/tsconfig.json
{
  "compilerOptions": {
    "experimentalDecorators": true,
    "sourceMap": true,
    "isolatedModules": false,
    "types": ["node"],
    "paths": {
      "@data/*": ["../e2e_tests/data/*"],
      "@locators/*": ["../e2e_tests/locators/*"],     
      "@queries/*": ["../e2e_tests/queries/*"],
      "@questions/*": ["../e2e_tests/questions/*"],
      "@tasks/*": ["../e2e_tests/tasks/*"],
      "@utils/*": ["../e2e_tests/utils/*"]
    }
  },
  "include": [
    "../playwright.config.ts",
    "../e2e_tests/**/*.spec.ts",
    "**/*.feature",
    "../e2e_tests/**/*.ts",
    "../e2e_tests/**/*.json"
  ]
}
EOL
fi


# Overwrite playwright.config.ts with the new configuration
echo "Creating Playwright configuration file..."
cat <<EOL > playwright.config.ts
import { PlaywrightTestConfig } from '@playwright/test';
const config: PlaywrightTestConfig = {
  testDir: './e2e_tests',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: 2,
  workers: process.env.CI ? 5 : 10,
  expect: {
    timeout: 20000,
    toHaveScreenshot: {
      maxDiffPixels: 10
    }
  },
  outputDir: './e2e_results',
  reporter: [
    ['line'],
    [
      'allure-playwright',
      {
        detail: true,
        outputFolder: './allure-results',
        suiteTitle: false,
        environmentInfo: {
          E2E_TEST_ENVIRONMENT: process.env.ENVIRONMENT_NAME,
          E2E_NODE_VERSION: process.version,
          E2E_OS: process.platform
        }
      }
    ],
    ['junit', { outputFile: 'e2e_results.xml' }]
  ],
  use: {
    baseURL: process.env.BASE_URL,
    trace: 'on'
  },
  // Test Config
  projects: [
    {
      name: 'Smoke Tests',
      testMatch: '**/*.spec.ts',
      timeout: 120000,
      use: {
        actionTimeout: 15000,
        navigationTimeout: 30000,
        browserName: 'chromium',
        channel: 'chrome',
        headless: true,
        viewport: { width: 1536, height: 960 },
        ignoreHTTPSErrors: true,
        acceptDownloads: true,
        screenshot: 'only-on-failure',
        video: 'retain-on-failure',
        trace: 'retain-on-failure',
        launchOptions: {
          slowMo: 0
        }
      }
    }
  ]
};
export default config;
EOL

# Delete the folder "tests-examples"
echo "Deleting the folder 'tests-examples'..."
rm -rf tests-examples

# Create the specified folders within e2e_tests
echo "Creating folders within e2e_tests..."
mkdir -p e2e_tests/specs/smoke
mkdir -p e2e_tests/tasks
mkdir -p e2e_tests/utils
mkdir -p e2e_tests/data

# Append paths to .gitignore
echo "Appending paths to .gitignore..."
# Paths to be added
paths_to_add=$(cat <<EOL
# e2e
/e2e/dist/*
/test-results/
/blob-report/
/playwright/.cache/
/allure-report/
/allure-results/*
e2e_results.xml
/e2e_results/
EOL
)

# Check if paths exist in .gitignore and append them under # e2e
for path in "${paths_to_search[@]}"; do
  if grep -Fxq "$path" .gitignore; then
    paths_to_add="$paths_to_add
$path"
  fi
done

# Append the paths to the end of the .gitignore file
echo "$paths_to_add" >> .gitignore

# Install ESLint and Prettier
echo "Installing ESLint and Prettier..."
npm install eslint prettier eslint-config-prettier eslint-plugin-prettier --save-dev

# Initialize ESLint configuration
echo "Initializing ESLint configuration..."
npx eslint --init

# Install Prettier dependencies
echo "Installing Prettier dependencies..."
npm install --save-dev prettier

# Install rimraf for cross-platform file removal
echo "Installing rimraf..."
npm install --save-dev rimraf

# Add scripts to package.json
echo "Adding scripts to package.json..."
sed -i 's/"scripts": {/"scripts": {\n    "lint": "eslint .",\n    "knip": "knip",\n    "pw:clean": "rimraf e2e_results\/ e2e_results.xml allure-results\/ allure-report\/",\n    "pw:test": "playwright test --config=playwright.config.ts --project",\n    "pw:report": "allure serve allure-results",\n    "pw:codegen": "playwright codegen"/g' package.json


# Run initial test to verify setup
echo "Running initial test to verify setup..."
npx playwright test

# Test Allure installation
echo "Testing Allure installation..."
npx allure --version

# Generate and open Allure report
echo "Generating Allure report..."
npx allure generate --clean
npx allure open
