<?php

/**
 * @file
 * Main settings file.
 */

$databases = array();
$config_directories = array();
$secrets_directory = $app_root . '/' . $site_path;
$settings['update_free_access'] = FALSE;
$settings['container_yamls'][] = $app_root . '/' . $site_path . '/services.yml';
$settings['file_scan_ignore_directories'] = [
  'node_modules',
  'bower_components',
];

$settings['entity_update_batch_size'] = 50;
$config_directories['sync'] = '../config/default';

// Get Acquia database settings.
if (file_exists('/var/www/site-php')) {
  require '/var/www/site-php/testlight4k/testlight4k-settings.inc';
}

if (isset($_ENV['AH_SITE_ENVIRONMENT'])) {
  $secrets_directory = '/mnt/gfs/home/' . '/' . $_ENV['AH_SITE_GROUP'] . '/' . $_ENV['AH_SITE_ENVIRONMENT'] . '/nobackup';
}

if (file_exists($secrets_directory)) {
  require $secrets_directory . '/settings.secrets.php';
}

if (file_exists($app_root . '/' . $site_path . '/settings.local.php')) {
  include $app_root . '/' . $site_path . '/settings.local.php';
}
