<?php

/**
 * @file
 * Drush aliases.
 *
 * @see https://github.com/drush-ops/drush/blob/master/examples/example.drushrc.php
 */

$options['shell-aliases'] = [];

// Supply backup.sql.gz and optionally files.tar.gz for a local restore point
// for development.

$options['shell-aliases']['fresh'] = '!( ' . implode(" ) && \n ( ", [
  "echo '\nInstalling PHP packages...'",
  "cd ..; composer install; cd docroot",

  "echo '\nRemoving old files and Extracting reference files, if any...'",
  "bash -c '[ -f ../reference/files.tar.gz ] && \n rm -rf sites/default/files/* && \n tar -xzf ../reference/files.tar.gz -C sites/default/files || exit 0'",

  "echo '\nDropping the database...'",
  "drush sql-drop -y",

  "echo '\nImporting reference database...'",
  "gunzip < ../reference/backup.sql.gz | sed '/INSERT INTO `cache.*` VALUES/d' | drush sql-cli",

  "echo '\nSetting admin password...'",
  "drush user-password 1 --password=admin",
]) . " )";

$options['shell-aliases']['local'] = "!( " . implode(" ) && \n ( ", [
  "echo '\nUpdating database...'",
  "drush updatedb -y",

  "echo '\nRebuilding cache...'",
  "drush cache-rebuild",

  "echo '\nImporting configuration...'",
  "drush config-import sync -y",

  "echo '\nApplying pending entity schema updates...'",
  "drush entity-updates -y",
]) . " )";

$options['shell-aliases']['prod'] = "!( " . implode(" ) && \n ( ", [
  "echo '\nUpdating database...'",
  "drush updatedb -y",

  "echo '\nRebuilding cache...'",
  "drush cache-rebuild",

  "echo '\nImporting configuration...'",
  "drush config-import sync -y",

  "echo '\nApplying pending entity schema updates...'",
  "drush entity-updates -y",
]) . " )";
