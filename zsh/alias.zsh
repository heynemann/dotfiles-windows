function reload() {
  source ~/.zshrc
}

alias ls="ls --color"

export EDITOR='vim'

alias sz="reload"
alias ea="$EDITOR ~/.alias.zsh;reload"
alias el="$EDITOR ~/.local.zsh;reload"
alias ez="$EDITOR ~/.zshrc;reload"       # alias for Edit Zshrc
alias st="~/.bin/dev-tmux"
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

# git
alias g='git'

# PR Review
alias grev='git diff $(git merge-base master HEAD) | vim - -R +Diffurcate'

# Commit Management
alias ga='git add'
alias gu='git unadd'                      # git config --global alias.unadd reset HEAD
alias grb='git rebase'
alias gcp='git cherry-pick'
# alias gca='git add . && git commit --amend --no-edit && git push -f'
alias gcm='git commit -m'
alias gempty="git commit --allow-empty -m 'empty'"
alias grh='git reset --hard'

gmc() {
  MAIN=$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

  # If current branch is main branch, just rebase remote
  if [ "$CURRENT_BRANCH" = "$MAIN" ]; then
    # Is there an upstream?
    if git config remote.upstream.url > /dev/null; then
      git pull --rebase upstream $MAIN
      git push origin $MAIN
    else
      git pull --rebase origin $MAIN
    fi

    return
  fi

  # Otherwise, if there's upstream, fetch from upstream and sync origin
  if git config remote.upstream.url > /dev/null; then
    git fetch upstream $MAIN:$MAIN
    git push origin $MAIN:$MAIN

    return
  fi

  # If no upstream, just fetch from origin to local main
  git fetch origin $MAIN:$MAIN
}

gca() {
  BRANCH=$(git rev-parse --abbrev-ref HEAD)
  if [ "$BRANCH" = "master" ]; then
    echo "Can't run gca in master branch! It does 'git push -f'! Aborting..."

    return
  fi

  AUTHOR=$(git show -s --format='%ae' HEAD)
  ME="heynemann@gmail.com"
  if [ "$ME" != "$AUTHOR" ]; then
    echo "Can't run gca if the last commit is not yours! You would change someone else's commit and it does 'git push -f'! Aborting..."

    return
  fi

  git add . && git commit --amend --no-edit && git push -f
}

# Branch Management
alias gb='git branch'                     # make _git_push_auto_branch_local
alias gbs='git branch --sort=-committerdate'
alias gr='git remote -v'
alias gf='git fetch'
alias gfa='git fetch --all'

alias gco='checkout'

gnew() {
  BRANCH=$(git rev-parse --abbrev-ref HEAD)
  if [ "$BRANCH" != "main" ]; then
    git checkout -b "$(whoami)/$1"

    return
  fi

  if git config remote.upstream.url > /dev/null; then
    git pull --rebase upstream main
  else
    git pull --rebase origin main
  fi

  git push
  git checkout -b "$(whoami)/$1"
}

alias gp='_git_push_auto_branch'       # git push to origin on current branch if no argument specified. Otherwise, git push to specified remote. (from cb-zsh)
alias gprune="git remote prune origin | grep -o '\[pruned\] origin\/.*$' | sed -e 's/\[pruned\] origin\///' | xargs git branch -D"

# Experimental
alias gpop='git reset --soft head^ && git unadd :/'
alias gsave='git add :/ && git commit -m "save point"'

# Git Status
alias gs='git status -sb'           # short and concise

# Git Log
alias gl='_git_commit_all'          # show all commits (from cb-zsh)
alias gll='git log --stat'          # git log with file info
alias glll='git log --stat -p'      # git log with file info + content

# Git Commits
alias glc='_git_commit_diff'        # show commits diff against (upstream|origin)/master (from cb-zsh)

# Git Diff
alias gd='git diff $(git merge-base main HEAD)'
alias merge-base='git merge-base main HEAD'

# Upstream
alias gup='gmc'
alias gom='git pull --rebase origin master'

git-branch-fzf () {
  git --no-pager branch -vv --sort='-committerdate:iso8601' | fzf +m --preview="git --no-pager log --abbrev-commit -5 {1} | bat --color always --plain" | awk '{print $1}'
}

git-recent-branch-fzf() {
  git reflog show --pretty=format:'%gs ~ %gd' --date=relative | grep 'checkout:' | grep -oE '[^ ]+ ~ .*' | awk -F~ '!seen[$1]++' | head -n 10 | awk -F' ~ HEAD@{' '{printf("%-20s\t%s\n", substr($2, 1, length($2)-1), $1)}' | fzf +m --delimiter "\t" --nth 2 --preview="git --no-pager log --abbrev-commit -5 {2} | bat --color always --plain" | awk ' { print $NF } '
}

git-all-branches-fzf () {
  # git fetch -a
  git --no-pager branch -vv -a --sort='-committerdate:iso8601' | grep -v master | grep -v "origin/HEAD" | grep "remotes/" | fzf +m --preview="git --no-pager log --abbrev-commit -5 {1} | bat --color always --plain" | awk '{print $1}'
}

git-commit-fzf () {
   git log --format='%h %s' --max-count=100 | fzf +m --preview="git --no-pager log --abbrev-commit -5 {1} | bat --color always --plain" | awk '{print $1}'
}

alias gshow='git-commit-fzf | xargs git show'
alias glog='git-commit-fzf | xargs git log'

switch () {
  BRANCH=$(git-all-branches-fzf)
  if [ "$BRANCH" = "" ]; then
    return
  fi

  BRANCH_NAME=$(echo $BRANCH | sed "s@remotes/[^/]*/@@")
  REMOTE=$(echo -n $BRANCH | sed "s@/$(echo -n $BRANCH_NAME)@@" | sed "s@remotes/@@")

  EXISTS=$(git rev-parse --verify $BRANCH_NAME)
  if [ "$EXISTS" != "" ]; then
    echo "Branch $BRANCH_NAME already exists locally. Checking out..."
    git checkout $BRANCH_NAME
    return
  fi
  echo "Pulling branch $REMOTE/$BRANCH_NAME..."
  git switch -c $BRANCH_NAME $REMOTE/$BRANCH_NAME
}

greb() {
  branch=$(git-branch-fzf)
  if [ -z $branch ]; then
    return
  fi

  if ! git diff-index --quiet HEAD; then
    echo "👉 Stashing local changes before rebase 👈"
    echo

    git stash && git rebase $branch; git stash pop

    echo
    echo "🎉 Rebase done and changes unstashed! 🎉"

    return
  fi

  git rebase $branch
}

gc() {
  branch=$(git-branch-fzf)
  if [ -z $branch ]; then
    return
  fi

  if ! git diff-index --quiet HEAD; then
    echo "👉 Stashing local changes before checkout 👈"
    echo

    git stash && git checkout $branch; git stash pop

    echo
    echo "🎉 Checkout done and changes unstashed! 🎉"

    return
  fi

  git checkout $branch
}

alias sw='switch'

# Git checkout branch
# alias gc='git-branch-fzf | xargs git checkout'
# alias gcc='git checkout master'
alias gcr='git-recent-branch-fzf | xargs git checkout'

# Git rebase
#
# alias greb='git-branch-fzf | xargs git rebase'
alias grebo='git-branch-fzf | xargs git rebase -X ours'
alias squash='git rebase -i $(git merge-base master HEAD)'

# Delete branch
alias gbrd='git-branch-fzf | xargs git branch -D'
alias gbd='gbrd'
alias gdel='gbrd'
alias grm='gbrd'

alias st='dev-tmux'
alias sq='square-tmux'
alias hex='hex-tmux'

alias kill-gopls="ps aux | grep gopls | egrep -v grep | awk ' { print \$2 } ' |  xargs kill -9"

alias wip="git commit -m 'WIP'"

alias gowhy='go mod why -m '

function workon() {
    VENV=$1
    if [ -z "$VENV" ]; then echo "Argument is required to workon <name of virtualenv>! Aborting..." && return 1; fi
    ACTIVATE_URL="$PYENV_ROOT/versions/$VENV/bin/activate"
    if [ ! -f $ACTIVATE_URL ]; then
        VERSIONS_FOUND="$(ls -1 $PYENV_ROOT/versions | grep -ve '^\d' | tr '\n' ', ' | sed 's@,$@@')"
        echo "$VENV/bin/activate was not found. Are you sure it is a virtualenv? (versions found: $VERSIONS_FOUND)"
        return 1
    fi
    source "$(echo $ACTIVATE_URL)"
    echo "Virtualenv $VENV activated."
}

alias docker-stop="docker container ls -q | awk ' { print $1 } ' | xargs docker stop"
alias docker-rm-volumes="docker volume ls | awk ' { print $2 } ' | grep -v VOLUME | xargs docker volume rm"

docker-ps-fzf () {
  docker ps | fzf +m --layout=reverse --header-lines=1 --preview-window=right,50%,cycle --preview="docker inspect {1} | bat --color always -l json --plain" | awk '{print $1}'
}

docker-ps-a-fzf () {
  docker ps -a | fzf +m --layout=reverse --header-lines=1 --preview-window=right,50%,cycle --preview="docker inspect {1} | bat --color always -l json --plain" | awk '{print $1}'
}

alias ds='docker-ps-fzf | xargs docker stop'
alias dl='docker-ps-a-fzf | xargs docker logs'
alias de="docker-ps-fzf | xargs echo -n | awk '{ print \$1 \" /bin/bash\"}' | xargs -o docker exec -it"
alias docker-rm='docker rm --force $(docker ps --all -q) && docker rmi --force $(docker images --all -q)'
alias docker-nuke='docker system prune --all --force --volumes'
alias docker-prune='docker system prune --all --force --volumes'
alias docker-wsl-fix='sudo rm -rf /mnt/wsl/docker-desktop-bind-mounts/Ubuntu/*'

compose-ps-fzf () {
  docker-compose ps | fzf +m --layout=reverse --header-lines=1 --preview-window=right,50%,cycle --preview="docker inspect {1} | bat --color always -l json --plain" | awk '{print $1}'
}
alias cl="compose-ps-fzf | xargs echo -n | awk ' { print \$1 } ' | xargs docker logs"
alias cs='docker-ps-fzf | xargs docker stop'
alias ce="docker-ps-fzf | xargs echo -n | awk '{ print \$1 \" /bin/bash\"}' | xargs -o docker exec -it"

function togif() {
    SOURCE_FILE=$1
    if [ -z "$SOURCE_FILE" ]; then echo "Source file is required to convert to gif! Aborting..." && return 1; fi
    cp $SOURCE_FILE tmp_video_conversion.mov
    echo "Running ffmpeg conversion..."
    ffmpeg -i tmp_video_conversion.mov -pix_fmt rgb24 -s 1280x770 -r 10 output.gif
    echo "Conversion completed."
}

function togifmp4() {
    SOURCE_FILE=$1
    if [ -z "$SOURCE_FILE" ]; then echo "Source file is required to convert to gif! Aborting..." && return 1; fi
    cp $SOURCE_FILE tmp_video_conversion.mp4
    echo "Running ffmpeg conversion..."
    ffmpeg -i tmp_video_conversion.mp4 -pix_fmt rgb24 -s 585x1266 -r 10 output.gif
    echo "Conversion completed."
}

function tomp4() {
  SOURCE_FILE=$1
  if [ -z "$SOURCE_FILE" ]; then echo "Source file is required to convert to mp4! Aborting..." && return 1; fi
  cp $SOURCE_FILE tmp_video_conversion.mov
  echo "Running ffmpeg conversion..."
  ffmpeg -i tmp_video_conversion.mov -vcodec h264 -acodec mp2 -s 1280x770 output.mp4
  echo "Conversion completed."
}

function quickedit() {
  FILE=/tmp/tempfile$$
  trap "rm $FILE" EXIT
  vim "+set paste" "$FILE" > /dev/tty
  if [ -f "$FILE" ]; then
      cat $FILE
  fi
}

function getstruct() {
  read "PACKAGE?Enter the package name (i.e.: data): "
  read "STRUCTNAME?Enter the struct name to generate: "

  local struct=$(echo $STRUCTNAME | sed "s/[A-Z]/_&/g" | sed "s/^_//")
  local filename="$PACKAGE/${struct:l}.go"

  $(quickedit | quicktype --lang go --top-level $STRUCTNAME --package $PACKAGE --out $filename)
  reset
  echo
  echo "[SUCCESS] $PACKAGE.$STRUCTNAME generated successfully at $filename"
}

# Formats JSON pasted into editor
alias jsonf='quickedit | jq'
alias psc='ps aux | fzf'
alias psk="psc | awk ' { print \$2 } ' | xargs kill -9"

# Hit something hard
alias hit='wrk -c 50 -t 10 -d 30s --latency '

function cpfgen() {
  python - << EOF
import sys
import random
cpf = [random.randint(0, 9) for x in range(9)]
for _ in range(2):
    val = sum([(len(cpf) + 1 - i) * v for i, v in enumerate(cpf)]) % 11
    cpf.append(11 - val if val > 1 else 0)
sys.stdout.write('%s%s%s.%s%s%s.%s%s%s-%s%s' % tuple(cpf))
EOF
}

function cnpjgen() {
python - << EOF
import sys
import random
def calculate_special_digit(l):
    digit = 0
    for i, v in enumerate(l):
        digit += v * (i % 8 + 2)
    digit = 11 - digit % 11
    return digit if digit < 10 else 0

cnpj =  [1, 0, 0, 0] + [random.randint(0, 9) for x in range(8)]
for _ in range(2):
    cnpj = [calculate_special_digit(cnpj)] + cnpj

sys.stdout.write('%s%s.%s%s%s.%s%s%s/%s%s%s%s-%s%s' % tuple(cnpj[::-1]))
EOF
}

func vimcmd() {
  CMD=$(quickedit)

  if [ ! -z "$CMD" ]; then
    print -s "$CMD"
    zsh -c "$CMD"
  fi
}

checkout() {
  root=$(git rev-parse --show-toplevel)
  nonstaged=$(git diff --name-only | sed "s/^/M\t/")
  staged=$(git diff --name-only --staged | sed "s/^/A\t/")

  if [ -z "$nonstaged$staged" ]; then
    return
  fi

  query="$nonstaged$staged"
  if [[ ! -z $nonstaged && ! -z $staged ]]; then
    query="$nonstaged\n$staged"
  fi

  result=$(echo "$query" | sed "s@^ @@" | fzf +m --delimiter "\t" --nth 2 --preview="git diff $root/{2} | bat --color always --plain")
  if [ -z "$result" ]; then
    return
  fi

  filename=$(echo $result | awk ' { print $2 }')
  st=$(echo $result | awk ' { print $1 }')

  if [ "$st" = "M" ]; then
    git checkout "$root/$filename"

    return
  fi

  if [ "$st" = "A" ]; then
    git restore --staged "$root/$filename" && git checkout "$root/$filename"

    return
  fi

  echo "Could not determine how to checkout $filename. Aborting..."
}


git-is-merged () {
  merge_destination_branch=$1
  merge_source_branch=$2

  merge_base=$(git merge-base $merge_destination_branch $merge_source_branch)
  merge_source_current_commit=$(git rev-parse $merge_source_branch)
  if [[ $merge_base = $merge_source_current_commit ]]
  then
    echo $merge_source_branch is merged into $merge_destination_branch
    return 0
  else
    echo $merge_source_branch is not merged into $merge_destination_branch
    return 1
  fi
}

alias tmux-stop="tmux ls | awk ' { print \$1 } ' | sed s/:// | xargs -I{} -- tmux kill-session -t {}"

alias vim='nvim'
alias open='wslview'

alias nsx-ghtoken='export GITHUB_TOKEN=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'

alias pip='pip3'
alias fix='nvim -p +/HEAD `git diff --name-only | uniq`'
alias kill-ts="ps aux | grep tsserver | grep -v grep | awk ' { print \$2 } ' | xargs kill -9"

alias prc="gh pr create"
alias prv="gh pr view --web"

alias gt="go test -count=1"
alias gtv="env SILENT_CFG=true go test -v -count=1"
alias python="python3"
alias acs="aws configure sso --profile AdministratorAccess-492684252576"
alias aws="aws --profile AdministratorAccess-492684252576"
