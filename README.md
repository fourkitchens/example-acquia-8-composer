# Example Acquia Drupal 8 Site with CI

Note: this setup has been updated by https://github.com/fourkitchens/example-acquia-8-composer-circle2 which validates under CircleCI.

## Setup

### Git Repo

Copy over the following folders and files to your repository

- circle
- config
- docroot/sites/default/settings.php
- drush
- gulp-tasks
- hooks
- .eslintignore
- .eslintrc
- .gitignore
- .phpcsignore
- circle.yml
- composer.json
- gulp-config.js
- gulpfile.js
- package.json

Feel free to switch out the asset building pieces and linting pieces with your
own. Also to affect the local and prod builds see drush/drushrc.php

### Circle CI

Set up the following Environment Variables on your project.

- `ACQUIA_USER`
    Cloud API E-mail
- `ACQUIA_TOKEN`
    Cloud API Private key. Located in your profile under security.
    See: https://docs.acquia.com/acquia-cloud/api/auth
- `ACQUIA_CANONICAL_ENV`
    Environment to get database from. Usually "prod".
- `ACQUIA_ENDPOINT`
    Cloud API Endpoint. Usually "https://cloudapi.acquia.com/v1".
- `ACQUIA_REALM`
    Cloud API Realm. Usually "prod" or "devcloud".
    See: https://docs.acquia.com/acquia-cloud/api#realm
- `ACQUIA_SITE`
    Cloud API Site parameter.
- `ACQUIA_REPO`
    Acquia git repo url.
- `ACQUIA_BOT_EMAIL`
    Email used to commit deployment commits.
- `ACQUIA_BOT_NAME`
    Display name use for the deployment committer.

Add a ssh key via CircleCI's SSH Permissions page for the user you use with
Acquia that can commit to the repository.

### Acquia

Following the technique documented at [Acquia](https://docs.acquia.com/acquia-cloud/files/system-files/private), ssh into your Acquia environment and run the following:

- `ACQUIA_USER`
    Cloud API E-mail
- `ACQUIA_TOKEN`
    Cloud API Private key. Located in your profile under security.
    See: https://docs.acquia.com/acquia-cloud/api/auth
- `ACQUIA_CANONICAL_ENV`
    Environment to get database from. Usually "prod".
- `ACQUIA_ENDPOINT`
    Cloud API Endpoint. Usually "https://cloudapi.acquia.com/v1".

```
mkdir /mnt/gfs/home/[REPLACE_WITH_SITE]/[REPLACE_WITH_ENV]/nobackup/
echo "ACQUIA_USER=user@email.com" >> /mnt/gfs/home/[REPLACE_WITH_SITE]/[REPLACE_WITH_ENV]/nobackup/bashkeys.sh
echo "ACQUIA_TOKEN=[REPLACE_WITH_ACQUIA_TOKEN]" >> /mnt/gfs/home/[REPLACE_WITH_SITE]/[REPLACE_WITH_ENV]/nobackup/bashkeys.sh
```

## References

If you wish to see a super detailed walkthrough of how it works, see this
[presentation](https://camp.drupal.cornell.edu/sessions/continuous-integration-acquia).
