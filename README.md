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
WARNING: this will freely smash pre-existing files in your workspace.
THIS is a feature: you may freely update the script and re-run, until you feel like it is ready to go for your project.
----

Uses normal npm commands to execute & build:

npm start

npm run build

The landing page should look something like this:
![README](README.png)

----
PULL REQUESTS ARE WELCOME!!!

If you wish to add additional files or packages and share them with a pull request, please duplicate app-sauce.sh, add a file called:

app-sauce-XXXXXXX.sh

Where XXXXXXX identifies the purpose of the file, such as:
app-sauce-websockets.sh
----
TODO: add a flag --no-smash-existing-files

TODO: enable cloning this repo and have the script fix it up so that it becomes a new local repo with your folder name

TODO: add a version that includes electron

TODO: add a flag to run buddy scripts for additional technology and support community given scripts.

TODO: update themes to actually use them properly!!!
