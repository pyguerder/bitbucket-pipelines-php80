# Bitbucket Pipelines PHP 8.0 image

[![](https://images.microbadger.com/badges/version/pyguerder/bitbucket-pipelines-php80.svg)](https://microbadger.com/images/pyguerder/bitbucket-pipelines-php80 "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/pyguerder/bitbucket-pipelines-php80.svg)](https://microbadger.com/images/pyguerder/bitbucket-pipelines-php80 "Get your own image badge on microbadger.com")

## Based on Ubuntu 18.04

### Packages installed

- `php8.0-zip`, `php8.0-xml`, `php8.0-mbstring`, `php8.0-curl`, `php8.0-json`, `php8.0-imap`, `php8.0-mysql`, `php8.0-tokenizer`, `php8.0-xdebug`, `php8.0-intl`, `php8.0-soap`, `php8.0-pdo`, `php8.0-cli`, `php8.0-apcu` and `php8.0-gd`
- wget, curl, unzip
- Composer 2
- Mysql 8 (or 5.7 if you use `pyguerder/bitbucket-pipelines-php80:mysql5`)
- Node + Yarn

### Sample `bitbucket-pipelines.yml`

```YAML
image: pyguerder/bitbucket-pipelines-php80
pipelines:
  default:
    - step:
        script:
          - service mysql start
          - mysql -h localhost -u root -proot -e "CREATE DATABASE test;"
          - composer install --no-interaction --no-progress --prefer-dist
          - ./vendor/phpunit/phpunit/phpunit -v --coverage-text --colors=never --stderr
```
