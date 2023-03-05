# customfunctionapp
This project's aim is to demonstrate how to host an application in Azure Functions, where the runtime is not natively supported by the function.
In this example, I'm demonstrating Azure Functions' custom handlers using a custom docker container which executes a Rust, OR an Rscript app.
I have developed and tested these apps, the provisioning, set-up and deployment scripts on a Debian v11 bullseye OS image.

## Prerequisites

1. install Azure CLI (https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
2. install docker (https://docs.docker.com/engine/install/)
3. install azure Functions Core Tools (https://learn.microsoft.com/en-us/azure/azure-functions/functions-run-local)
4. install git (https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
5. allow docker to run without sudo (run setdockerwithoutsudo.sh)
6. make sure you have an active Azure Subscription

## Repository Contents
* SimpleHttpTrigger/function.json - contains the definition and configuration of an HTTP triggered Function inside the main Function App
* src/main.rs - Rust webserver demo application
* .dockerignore - config file for docker, to define a list of files to be ignored while building the container
* .gitignore - config file for git to ignore local files from being source controlled
* Cargo.lock - contains exact information about your dependencies. It is maintained by Cargo and should not be manually edited. (from https://doc.rust-lang.org/)
* Cargo.toml - is about describing your dependencies in a broad sense, and is written by you. (from https://doc.rust-lang.org/)
* Dockerfile - is a text document that contains all the commands a user could call on the command line to assemble an image (from https://docs.docker.com/)
* createazureresources.sh - bash script, which builds the rust application, provisions Azure resources, builds the docker image, and pushes the function app along with the custom docker image into the create Azure function app instance
* handler.r - Rscript demo application
* host.json - function app configuration file; by default it contains the config for the function to execute the compiled Rust app; if you'd like to execute the Rscript app, replace contents of this file with host_rscript.json
* host_rscript.json/host_rust.json - demo config files for running rscript/rust apps inside the function
* setdockerwithoutsudo.sh - bash script to enable running the docker daemon without root user privileges



(from bash)
1. clone this repo
2. go to the cloned repository folder
3. change createazureresources.sh, and replace function app name 'learn-function-docker-function' with your own name
4. run az login
5. run createazureresources.sh
6. test deployed app via https://learn-function-docker-function.azurewebsites.net/api/SimpleHttpTrigger (use replaced name instead of 'learn-function-docker-function' in the URL as well)
