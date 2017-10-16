<?php

/**
 * @file
 * CircleCI Drush Aliases.
 */

$aliases['local'] = array(
  'uri' => 'circleci.local',
  'root' => "/home/ubuntu/{{CIRCLE_PROJECT_REPONAME}}/docroot",
);
