#/bin/sh

BRANCH_LIST=$(git branch)

function branch_func () {
  ACTION=$(echo "$(gum choose \
  "Create new branch" \
  "Delete branch" \
  "Cancel")" \
  | sed -e '1 D')

  case $ACTION in
    "Create new branch")
      NEW_BRANCH=$(echo "$(gum input --placeholder "New branch")" | sed -e '1 D')
      git branch $NEW_BRANCH
    ;;
    "Delete branch")
      TARGET_BRANCH=$(echo "$(gum choose $(echo "$BRANCH_LIST" \
      | sed -e 's/ //g' -e '/*/d'))" | sed -e '1 D')
      gum confirm "Delete branch? ($TARGET_BRANCH)" \
      && git branch -D $TARGET_BRANCH
    ;;
  esac
}

function switch_func () {
  echo "[Info] Current branch is $(echo "$BRANCH_LIST" \
  | grep \* \
  | sed -e 's/ //g' -e 's/*//g')"
  NEW_BRANCH=$(echo "$(gum choose $(echo "$BRANCH_LIST" \
  | sed -e 's/ //g' -e '/*/d') "Create new branch" "Cancel" )" | sed -e '1 D')

  case $NEW_BRANCH in
    "Create new branch")
      NEW_BRANCH=$(echo "$(gum input --placeholder "New branch")" | sed -e '1 D')
      git switch -c $NEW_BRANCH
    ;;
    "Cancel")
    ;;
    *)
      git switch $NEW_BRANCH
    ;;
  esac
}

case $1 in
  branch)
    branch_func
  ;;
  switch)
    switch_func
  ;;
  *)
  ;;
esac
