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

## Installation and setup

Choose the section that matches your environment:

1. [Local development on a regular Linux/macOS environment](#local-development-on-a-regular-linuxmacos-environment)
2. [Local development on Fedora Silverblue with VS Code and toolbox](#local-development-on-fedora-silverblue-with-vs-code-and-toolbox)
3. [Production environment](#production-environment)
4. [Optional Ansible/Vagrant workflow](#ansiblevagrant)

### Local development on a regular Linux/macOS environment

Use this workflow when you want to run the backend directly on your machine.
SQLite is the simplest option for getting started, while MySQL is useful when
you want local development to resemble production more closely.

1. Install the required tools:
   - PHP with the extensions needed by this project
   - Composer
   - Either SQLite or MySQL, depending on the database you want to use
2. Install the PHP dependencies:

   ```bash
   composer install
   ```

3. Create a local environment file:

   ```bash
   cp .env.dist .env
   ```

4. Pick one database option and set `DATABASE_URL` accordingly:
   - **SQLite** (default in `.env.dist`):

     ```dotenv
     DATABASE_URL="sqlite:///%kernel.project_dir%/var/data.db"
     ```

   - **MySQL**:

     ```dotenv
     DATABASE_URL="mysql://strichliste:32YourPassWord42@127.0.0.1:3306/strichliste?serverVersion=8.0.36&charset=utf8mb4"
     ```

5. Create the database schema:

   ```bash
   mkdir -p var
   php bin/console doctrine:schema:create
   ```

6. Start the application with your usual local Symfony or PHP web server setup.

### Local development on Fedora Silverblue with VS Code and toolbox

Use this workflow when you develop on an immutable OS such as Fedora
Silverblue. The recommended approach is to keep the host system untouched,
install the development tools inside a `toolbox` container, and open the
repository from VS Code in that toolbox-backed environment.

1. Create and enter a dedicated toolbox:

   ```bash
   toolbox create --container strichliste-dev
   toolbox enter strichliste-dev
   ```

2. Install the development tools inside the toolbox.

   For **SQLite**:

   ```bash
   sudo dnf install -y php php-cli php-sqlite php-xml php-mbstring php-json php-intl php-zip composer sqlite
   ```

   For **MySQL**:

   ```bash
   sudo dnf install -y php php-cli php-mysqlnd php-xml php-mbstring php-json php-intl php-zip composer community-mysql community-mysql-server
   ```

3. Verify the toolbox has the expected tools available:

   ```bash
   php -v
   composer --version
   ```

   For SQLite, also verify:

   ```bash
   sqlite3 --version
   ```

   For MySQL, also verify:

   ```bash
   mysql --version
   ```

4. Open the repository in VS Code using your preferred toolbox-compatible
   workflow, then open a terminal inside the toolbox.

5. Install the project dependencies:

   ```bash
   composer install
   ```

6. Create your local environment file:

   ```bash
   cp .env.dist .env
   ```

7. Configure `.env` for your chosen database:
   - **SQLite**: keep the default `DATABASE_URL` from `.env.dist`.
   - **MySQL**: replace `DATABASE_URL` with your MySQL connection string.

8. Create the database schema:

   ```bash
   mkdir -p var
   php bin/console doctrine:schema:create
   ```

9. Start the local PHP server:

   ```bash
   php -S 127.0.0.1:8000 -t public
   ```

   You can then open `http://127.0.0.1:8000` in your browser.

### Production environment

Use this workflow when you want to deploy the backend for real users instead of
running it as a local development setup.

1. Provision the target system with:
   - PHP and the required PHP extensions
   - Composer
   - A web server or PHP application runtime suitable for Symfony deployments
   - A production database server, typically MySQL
2. Deploy the project files to the server.
3. Install the PHP dependencies:

   ```bash
   composer install --no-dev --optimize-autoloader
   ```

4. Create the environment configuration for production. Start from `.env.dist`
   and provide a production `DATABASE_URL` and any other environment-specific
   settings through your deployment process.
5. Prepare the database and application data directory:

   ```bash
   mkdir -p var
   php bin/console doctrine:schema:create --env=prod
   ```

6. Configure your web server or PHP runtime to serve the application from the
   `public/` directory.
7. Start or reload the production services.

If you want to automate provisioning, the `contrib/ansible` directory contains
an example Ansible-based setup.

### Ansible/Vagrant

The `contrib/ansible` directory contains an optional Ansible + Vagrant setup for
provisioning a VM. That setup is useful if you specifically want to develop or
test inside a virtual machine, but it is not required for normal local
development in VS Code.

## API Documentation

For a full documentation or the strichliste2 API, please see the API.md file.

## Config Documentation

For documentation of the config parameters in `config/services.yml`, please read the Config.md file.
