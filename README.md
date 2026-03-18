# strichliste-backend  [![Build Status](https://travis-ci.org/strichliste/strichliste-backend.svg?branch=master)](https://travis-ci.org/strichliste/strichliste-backend)

strichliste ([ʃtʀɪçˈlɪstə], German word for tally sheet) is a tool to replace a tally sheet inside a hackerspace. It is the first project developed by the hackerspace bootstrap organization.
Its aim is to provide a no-frills, easy-to-setup and easy-to-use solution for managing your organization’s snack bar.

## How it works?

The processes implemented by strichliste assume a trusted audience. Each user intending to buy something from your kiosk is required to have a user account with strichliste. This can be done by registering a username; no other data is required.

Once an account is available, buying an item is as simple as deducting the equivalent value of the item from the account. Administrators of strichliste can define a lower or upper bound for users’ credit balances. For example, administrators can configure that negative balances are not allowed.

Cashing up an account works as the inverse of buying an item: simply charge the account with the given amount and it will take effect immediately.

It’s as simple as that!

## Demo

Curious to see how it works? Check out the demo at https://demo.strichliste.org

## Installation and setup

Choose the section that matches your environment:

1. [Local development on Fedora Silverblue with VS Code and toolbox](#local-development-on-fedora-silverblue-with-vs-code-and-toolbox)
2. [Local development on a regular Linux/macOS environment](#local-development-on-a-regular-linuxmacos-environment)
3. [Production environment](#production-environment)
4. [Optional Ansible/Vagrant workflow](#optional-ansiblevagrant-workflow)

### Local development on Fedora Silverblue with VS Code and toolbox

Use this workflow first if you develop on an immutable OS such as Fedora
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

   If one of these commands fails, install the missing package inside the
   toolbox with `dnf`, then rerun the verification command before continuing.

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

### Local development on a regular Linux/macOS environment

Use this workflow when you want to run the backend directly on your machine.
If you are on Fedora Silverblue or another immutable OS, use the toolbox-based
workflow above instead of installing tools directly on the host.
SQLite is the simplest option for getting started, while MySQL is useful when
you want local development to resemble production more closely.

1. Install the required tools for your operating system.

   Example commands you can copy and paste:

   For **Debian/Ubuntu** with **SQLite**:

   ```bash
   sudo apt update
   sudo apt install -y php-cli php-sqlite3 php-xml php-mbstring php-intl php-zip composer sqlite3
   ```

   For **Debian/Ubuntu** with **MySQL**:

   ```bash
   sudo apt update
   sudo apt install -y php-cli php-mysql php-xml php-mbstring php-intl php-zip composer default-mysql-client mysql-server
   ```

   For **Fedora Workstation/Server** with **SQLite**:

   ```bash
   sudo dnf install -y php php-cli php-sqlite php-xml php-mbstring php-json php-intl php-zip composer sqlite
   ```

   For **Fedora Workstation/Server** with **MySQL**:

   ```bash
   sudo dnf install -y php php-cli php-mysqlnd php-xml php-mbstring php-json php-intl php-zip composer community-mysql community-mysql-server
   ```

   For **macOS (Homebrew)** with **SQLite**:

   ```bash
   brew install php composer sqlite
   ```

   For **macOS (Homebrew)** with **MySQL**:

   ```bash
   brew install php composer mysql
   ```

2. Verify the tools are available:

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

   If any of these commands fail, install the missing package for your operating
   system, make sure the binary is available on your `PATH`, and rerun the check
   before continuing with `composer install`.

3. Install the PHP dependencies:

   ```bash
   composer install
   ```

4. Create a local environment file:

   ```bash
   cp .env.dist .env
   ```

5. Pick one database option and set `DATABASE_URL` accordingly:
   - **SQLite** (default in `.env.dist`):

     ```dotenv
     DATABASE_URL="sqlite:///%kernel.project_dir%/var/data.db"
     ```

   - **MySQL**:

     ```dotenv
     DATABASE_URL="mysql://strichliste:32YourPassWord42@127.0.0.1:3306/strichliste?serverVersion=8.0.36&charset=utf8mb4"
     ```

6. Create the database schema:

   ```bash
   mkdir -p var
   php bin/console doctrine:schema:create
   ```

7. Start the application with your usual local Symfony or PHP web server setup.

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

### Optional Ansible/Vagrant workflow

The `contrib/ansible` directory contains an optional Ansible + Vagrant setup for
provisioning a VM. Use it if you specifically want to develop or test inside a
virtual machine; it is not required for the regular local workflows above.

## API Documentation

For full documentation of the strichliste2 API, please see `API.md`.

## Config Documentation

For documentation of the config parameters in `config/services.yml`, please read `Config.md`.
