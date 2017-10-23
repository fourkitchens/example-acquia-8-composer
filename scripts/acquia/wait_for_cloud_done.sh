#!/bin/bash
# Runs an acquia task, and waits for the task to complete before continuing.
# This is a helper script, to be used in others as needed.
#
# @see https://gist.github.com/heathdutton/cc29284de3934706acd1

if [[ $1 = "" ]] || [[ $2 = "" ]]
then
  echo "Runs an acquia drush command, waiting for the results before continuing."
  echo "Can be used as a replacement for drush."
  echo
  echo "    Usage:    $0 <site-alias> <ac-drush-command>"
  echo "    Example:  $0 @site.prod ac-database-instance-backup site"
  exit 1
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

ac_command="$2"
drush_command="drush "$@""

if [[ $ac_command = "ac-code-deploy" ]] ||
   [[ $ac_command = "ac-code-path-deploy" ]] ||
   [[ $ac_command = "ac-database-add" ]] ||
   [[ $ac_command = "ac-database-copy" ]] ||
   [[ $ac_command = "ac-database-delete" ]] ||
   [[ $ac_command = "ac-database-instance-backup" ]] ||
   [[ $ac_command = "ac-database-instance-backup-delete" ]] ||
   [[ $ac_command = "ac-database-instance-backup-restore" ]] ||
   [[ $ac_command = "ac-domain-add" ]] ||
   [[ $ac_command = "ac-domain-delete" ]] ||
   [[ $ac_command = "ac-domain-move" ]] ||
   [[ $ac_command = "ac-domain-purge" ]] ||
   [[ $ac_command = "ac-environment-install" ]] ||
   [[ $ac_command = "ac-files-copy" ]]
then
  echo "${0//.sh/}:"
  echo "    Command: $drush_command"
  jsonfile=$(mktemp /tmp/wait_for_cloud_done.XXXXXX)
  $drush_command --format=json > $jsonfile
  id="$( php -r "\$json = json_decode(file_get_contents('$jsonfile')); echo \$json->id;" )"

  echo "    Task: $id"
  rm $jsonfile;

  oldlogs=""
  COUNTER=0
  # Hard timeout at 10 minutes
  while [[ $state != "done" && $state != "error"  && $COUNTER -lt 60 ]]
  do
    # Checking consumes resources, so wait for 10 seconds between checks.
    sleep 10
    let COUNTER=COUNTER+1
    jsonfile=$(mktemp /tmp/wait_for_cloud_done.XXXXXX)
    drush $1 ac-task-info $id --format=json > $jsonfile
    if [[ $? -gt 0 ]]
    then
      echo "drush ac-task-info Command Failed"
      exit 1
    elif [[ -z "$(cat $jsonfile)" ]]
    then
      echo "drush ac-task-info didn't return any data."
    fi
    state="$( php -r "\$json = json_decode(file_get_contents('$jsonfile')); echo \$json->state;" )"
    newlogs="$( php -r "\$json = json_decode(file_get_contents('$jsonfile')); echo \$json->logs;" )"
    rm $jsonfile
    if [[ $newlogs != $oldlogs ]]
    then
      logdiff=${newlogs//"$oldlogs"/}
      logdiff=${logdiff//"\n"/}
      if [[ $logdiff != "" ]]
      then
        echo "    $logdiff"
      fi
    fi
    oldlogs="$newlogs"
  done

  if [[ $state != "error" ]]
  then
    echo -e "    State: ${GREEN}$state${NC}"
  else
    echo -e "    State: ${RED}$state${NC}"
    exit 1
  fi
else
  # Fall back to standard drush command if this is not a known asyncronous command
  drush "$@"
fi
