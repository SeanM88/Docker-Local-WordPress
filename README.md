# Docker Local WordPress

<!-- Table of Contents -->
<details open>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about">About</a>
      <ul>
        <li><a href="#feature">Features</a></li>
      </ul>
    </li>
    <li>
      <a href="#usage">Usage</a>
      <ul>
        <li><a href="#requirements">Requirements</a></li>
        <li><a href="#setup">Setup</a></li>
        <li><a href="#regular-docker-usage">Regular Docker Usage</a></li>
      </ul>
    </li>
  </ol>
</details>

## About

Easy local WordPress developement environment using Docker Compose.

### Features

- **Docker containers for:**
  - [WordPress](https://hub.docker.com/_/wordpress)
  - [nginx web server](https://hub.docker.com/_/nginx)
  - [MySQL database](https://hub.docker.com/_/mysql)
  - [PHPMyAdmin](https://hub.docker.com/_/phpmyadmin)
- `.env.example` template for easy project config using a `.env` file
- **custom nginx config for:**
  - custom development domain (e.g. myapp.test)
  - redirecting HTTP requests to HTTPS
  - proxying missing images & static files from a production site
- **Shell scripts for:**
  - creating TLS/SSL certificate (signed by local CA)
  - importing a MySQL database dump

## Usage

### Requirements

- [Docker](https://www.docker.com/get-started)

### Setup

1. **Grab the Repo** - first clone or download this repository to your computer.

2. **Initial Project Configuration** - before actually running anything in Docker, be sure to first:
    1. **Set environment variables** - copy the `.env.example` file into a `.env` file in the project root and update the values to suit your project.
    2. **Update `/etc/hosts` file** - add entry for custom development domain to `/etc/hosts` file (e.g. `127.0.0.1 mysite.test`) either using provided `update-hosts.sh` script or by manually editing the file directly.
    3. **Generate TLS/SSL certificates** - use the provided `setup-certs.sh` script to automatically create certificates needed to enforce HTTPS.

3. **Start Docker** - now we're ready to actually start Docker and run our containers using Docker Compose:

    ```sh
    docker compose up -d
    ```

4. **Import a Database (Optional)** - optionally, you can import an existing database by placing the exported database file in the `/config/database` directory (see `/config/database/README.md` for expected filename format) and then running the provided `import-db.sh` script.
    - alternatively, you can also use the `docker exec` command to import a database file, see [Docker reference page](https://docs.docker.com/engine/reference/commandline/exec/) for `docker exec` command more info.

5. **Visit Local Development Site** - if everythings working as expected, you should be able to visit your new Docker power local WordPress installation by visiting the domain you specified in your project's `.env` file.

### Regular Docker Usage

**Stoping Docker** - when you're finished working, to stop running containers use:

  ```sh
  docker compose down
  ```

**Starting Docker** - to start Docker containers back up, run:

  ```sh
  docker compose up -d
  ```
