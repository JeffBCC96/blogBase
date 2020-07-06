#!/bin/bash
if [ $# -lt  1 ]; then
    echo "$0 <require commit message>"
    exit 1
fi

msg="$1"
git add . 
git commit -m "$msg"
if [ $? -ne 0 ]; then
    echo "Failed Commitment "
    exit 1
fi

git push origin master
if [ $? -ne 0 ]; then
    echo "Failed Push"
fi
echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project.
hugo --theme=noteworthy # --baseUrl="https://jeffbcc96.github.io/" --buildDrafts # if using a theme, replace with `hugo -t <YOURTHEME>`
cd public
git add .
git commit -m "$msg"
git push origin master
# Back to the Project Root
cd ..