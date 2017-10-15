<?php

/**
 * @file
 * Create artifacts/db_backup_id file.
 *
 * Get the last database backup's id from artifacts/db_backups.json and write it
 * to artifacts/db_backup_id.
 */

// Store artifacts path.
$artifacts_path = $argv[1];

// Read backups.json and decode it.
$db_backups_json = file_get_contents($artifacts_path . '/db_backups.json');
$db_backups = json_decode($db_backups_json);

$last_db_backup = NULL;
$last_db_backup_completed = 0;

if (is_array($db_backups)) {
  foreach ($db_backups as $backup) {
    // Search for the last backup.
    if ($backup->completed > $last_db_backup_completed) {
      $last_db_backup = $backup;
      $last_db_backup_completed = $backup->completed;
    }
  }
  // Write out last backup id to artifacts/db_backup_id.
  if ($last_db_backup != NULL) {
    $db_backup_id = fopen($artifacts_path . '/db_backup_id', 'w') or die("Unable to create $artifacts_path/db_backup_id file!");
    fwrite($db_backup_id, $last_db_backup->id);
    fclose($db_backup_id);
  }
  else {
    echo "No dabatase backup file found. Cannot create $artifacts_path/db_backup_id!";
    exit(1);
  }
}
else {
  echo "File $artifacts_path/db_backups.json should contain an array!";
  exit(1);
}
