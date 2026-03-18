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

The backend supports both SQLite and MySQL for local development. SQLite is
lightweight and easy to start with, while MySQL is a good fit when you want to
mirror a production-like database setup. Choose whichever option matches your
workflow.

1. Install the PHP dependencies:

   ```bash
   composer install
   ```

2. Create a local environment file:

   ```bash
   cp .env.dist .env
   ```

3. Pick one database option and set `DATABASE_URL` accordingly:

   - **SQLite** (default in `.env`):

     ```dotenv
     DATABASE_URL="sqlite:///%kernel.project_dir%/var/data.db"
     ```

   - **MySQL**:

     ```dotenv
     DATABASE_URL="mysql://strichliste:32YourPassWord42@127.0.0.1:3306/strichliste?serverVersion=8.0.36&charset=utf8mb4"
     ```

4. Create the database schema:

   ```bash
   mkdir -p var
   php bin/console doctrine:schema:create
   ```

5. Start the application with your usual local Symfony/PHP web server setup.

### Fedora Silverblue + VS Code

Fedora Silverblue uses an immutable base system, so the easiest way to work on
this project in VS Code is to install the development tools inside a
`toolbox` container and open the repository from there.

1. Create and enter a toolbox for development:

   ```bash
   toolbox create --container strichliste-dev
   toolbox enter strichliste-dev
   ```

2. Install PHP, Composer, and the database support you want inside the toolbox:

   - **SQLite**

     ```bash
     sudo dnf install -y php php-cli php-sqlite php-xml php-mbstring php-json php-intl php-zip composer sqlite
     ```

   - **MySQL**

     ```bash
     sudo dnf install -y php php-cli php-mysqlnd php-xml php-mbstring php-json php-intl php-zip composer community-mysql community-mysql-server
     ```

3. Verify that the tools are available for your chosen setup:

   ```bash
   php -v
   composer --version
   ```

   For SQLite also check:

   ```bash
   sqlite3 --version
   ```

   For MySQL also check:

   ```bash
   mysql --version
   ```

4. In VS Code, install the Remote - Containers / Dev Containers or Toolbox
   workflow you prefer, then open a terminal that runs inside the toolbox and
   continue with the project setup there.

5. Install the PHP dependencies for this project:

   ```bash
   composer install
   ```

6. Create your local environment file:

   ```bash
   cp .env.dist .env
   ```

7. Configure `.env` for either SQLite or MySQL, then create the schema:

   - **SQLite** keeps the default `DATABASE_URL` from `.env.dist`.
   - **MySQL** should replace `DATABASE_URL` with your local or remote MySQL
     connection string.

   ```bash
   mkdir -p var
   php bin/console doctrine:schema:create
   ```

8. Start the local PHP server:

   ```bash
   php -S 127.0.0.1:8000 -t public
   ```

   You can then open `http://127.0.0.1:8000` in your browser.


### Ansible/Vagrant

The `contrib/ansible` directory contains an optional Ansible + Vagrant setup for
provisioning a VM. That setup is useful if you specifically want to develop or
test inside a virtual machine, but it is not required for normal local
development in VS Code.

## API Documentation

For a full documentation or the strichliste2 API, please see the API.md file.


## Config Documentation

For documentation of the config parameters in `config/services.yml`, please read the Config.md file.
