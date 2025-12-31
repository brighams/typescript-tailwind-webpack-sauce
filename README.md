# typescript-tailwind-webpack-sauce
A custom script that builds a fullly functional workspace

Usage:

1. Open a bash shell on windows - linux skip this step!
1. Copy app-sauce.sh to the root of your project folder
2. customize the script as you like
3. execute ./app-sauce.sh
4. It will compile and run!
5. open browser http://127.0.0.1:8003

There are no options. This is meant to be glued to your project, so the customizations will always show up, and you can reference how the project was started.
----
TODO: add a flag --no-smash-existing-files
TODO: enable cloning this repo and have the script fix it up so that it becomes a new local repo with your folder name

----
WARNING: this will freely smash pre-existing files in your workspace.
THIS is a feature: you may freely update the script and re-run, until you feel like it is ready to go for your project.
----

Uses normal npm commands to execute app:

npm start
npm build

The landing page should look like this:
![README](README.png)

----
PULL REQUESTS ARE WELCOME!!!
