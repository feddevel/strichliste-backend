# strichliste-backend  [![Build Status](https://travis-ci.org/strichliste/strichliste-backend.svg?branch=master)](https://travis-ci.org/strichliste/strichliste-backend)

strichliste ([ʃtʀɪçˈlɪstə], German word for tally sheet) is a tool to replace a tally sheet inside a hackerspace. It is the first project developed by the hackerspace bootstrap organization.
It’s aim is to provide a no-frills, easy-to-setup and -to-use solution for managing your organization’s snack bar. 

## How it works?

The processes implemented by strichliste inherently assumes to be used by a trusted audience. Each user intending to buy something from your kiosk is required to have a user account with strichliste. This can be done by registering your username (no other data is required).

Once an account is available, buying an item is as simple as deducting the equivalent value of the item from your account. Administrators of strichliste can define a lower or upper bound for the users’ credit balance. For example, administrators can configure that it is not allowed to have a negative balance.

Cashing your account works the same as the inverse of buying an item: Simply charge your account with the given amount and it will take effect immediately.

It’s as simple as that!

## Demo

Curious to see how it works? Check out our Demo at https://demo.strichliste.org

### Recommended workflow

1. Install the PHP dependencies:

   ```bash
   composer install
   ```

2. Create a local environment file:

   ```bash
   cp .env.dist .env
   ```

3. Edit `.env` and configure `DATABASE_URL` for your local database.

4. Create the database schema:

   ```bash
   php bin/console doctrine:schema:create
   ```

5. Start the application with your usual local Symfony/PHP web server setup.


### Ansible/Vagrant

The `contrib/ansible` directory contains an optional Ansible + Vagrant setup for
provisioning a VM. That setup is useful if you specifically want to develop or
test inside a virtual machine, but it is not required for normal local
development in VS Code.


### Fedora Silverblue / Toolbx setup

If you are using **Fedora Silverblue**, the base OS is immutable, so you need a
**Toolbx** container for development tools like PHP and Composer.

#### 1. Create or enter a Toolbox container

```bash
# Create a toolbox (if you haven't already)
toolbox create php-workspace

# Enter the toolbox
toolbox enter php-workspace
```

#### 2. Update packages and install PHP

Inside the toolbox:

```bash
sudo dnf update -y
sudo dnf install -y php php-cli php-mbstring php-xml unzip curl git
```

* `php-cli` – command-line PHP
* `php-mbstring` & `php-xml` – common Composer dependencies
* `unzip` & `curl` – required for Composer installation
* `git` – needed for many PHP projects

#### 3. Install Composer

Still inside the toolbox:

```bash
# Download Composer installer
curl -sS https://getcomposer.org/installer -o composer-setup.php

# Verify installer (optional)
HASH=$(curl -sS https://composer.github.io/installer.sig)
php -r "if (hash_file('sha384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"

# Install globally
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Remove installer
rm composer-setup.php

# Test
composer --version
```

#### 4. Configure VS Code to use the toolbox environment

**Option A – Open VS Code inside the toolbox**

1. Make sure VS Code is installed on your host (Silverblue).
2. Install the **Remote - Containers** extension in VS Code.
3. Use **"Remote - Containers: Open Folder in Container"** and point it to the
   `php-workspace` container so VS Code runs inside it.

**Option B – Use the VS Code integrated terminal**

1. Open your project in VS Code.
2. Open the terminal (<kbd>Ctrl</kbd> + <kbd>\`</kbd>) and enter your toolbox:

```bash
toolbox enter php-workspace
```

Any Composer commands you run in that terminal will execute inside the toolbox.

#### 5. Optional: alias Composer in your host shell

Add the following to `~/.bashrc` or `~/.zshrc` on your host so you can run
`composer` from the VS Code terminal without manually entering the toolbox each
time:

```bash
alias composer="toolbox run --container php-workspace composer"
```


## API Documentation

For a full documentation or the strichliste2 API, please see the API.md file.


## Config Documentation

For documentation of the config parameters in `config/services.yml`, please read the Config.md file.


