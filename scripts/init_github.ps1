# Run from the root of the ErgoMove project.
# Requires GitHub CLI: https://cli.github.com/

git init
git add .
git commit -m "Initialize ErgoMove ergonomic reminder app"

gh auth login
gh repo create ariaPersian/ergomove --private --source . --remote origin --push
