#!/bin/sh

source ./config/git_token.sh
source ./config/config.sh

function create_update_local_branches {
  local git_url=$1
  local repo_name=$2

  local branches
  
  cd ${ROOT_PATH}/repos
  create_update_repo ${git_url} ${repo_name}

  cd ${ROOT_PATH}/repos/${repo_name}
  branches=$(git branch -r | grep -v '\->' | sed 's/origin\///g' | sed 's/\ //g')
  if [ -n "${branches}" ]; then
    while IFS='' read -r branch_name || [[ -n "${branch_name}" ]]; do
      create_update_branch ${branch_name}
    done <<< "$branches"
  fi
}

function create_dest_repo {
  local repo=$1

  test -z $repo && echo "Repo name required." 1>&2 && exit 1

  printf "Creating ${repo} repository"

  # Create the project on the destination gitlab server
  # TODO: check if the repo exists before executing this command
  curl -H "Content-Type:application/json" https://${dest_gitlab_server_url}/api/v3/projects?private_token=${git_dest_token} -d "{ \"name\": \"$repo\" }" >/dev/null
}

function push_branches {
  local repo_name=$1
  local dest_repo_name=$2

  create_dest_repo ${dest_repo_name}

  cd ${ROOT_PATH}/repos/${repo_name}
  log_info "Pushing to http://${dest_gitlab_server_url}:${dest_gitlab_port}/${dest_gitlab_user_name}/${dest_repo_name}.git"
  git push -q --all http://${dest_gitlab_server_url}:${dest_gitlab_port}/${dest_gitlab_user_name}/${dest_repo_name}.git
  git push -q --tags http://${dest_gitlab_server_url}:${dest_gitlab_port}/${dest_gitlab_user_name}/${dest_repo_name}.git
}

# clone if the project doesn't exist on local computer
# pull if the project already exists
function create_update_repo {
  local git_url=$1
  local repo_name=$2

  log_info "Synchronizing ${git_url} ..."
  if [ -d ${repo_name} ]; then
    git fetch -q ${git_url}
  else
    git clone -q ${git_url}
  fi
}

function create_update_branch {
  local branch_name=$1
  
  local branch_exists
  branch_exists=$(git branch | grep ${branch_name} | wc -l)
  
  if (( ${branch_exists} )); then
    git checkout -q ${branch_name}
    git pull -q origin ${branch_name}
  else
    git checkout -q -b ${branch_name} origin/${branch_name}
  fi
}

function list_repos {
  curl --header "PRIVATE-TOKEN: ${git_src_token}" http://${src_gitlab_server_url}:${src_gitlab_port}/api/v3/projects | jq -r '.[] | .http_url_to_repo' > ${ALL_REPOS_FILE}
}

