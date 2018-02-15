set -e

if [ $TRAVIS_PULL_REQUEST == "false" ]; then
  cat config/.ssh/config >> ~/.ssh/config
  ssh-add
  echo "Starting Deploy"
  bundle exec cap stage deploy
  echo "Deploy complete, updating issues for QA"
  bundle exec rake issues:qa_update
fi
