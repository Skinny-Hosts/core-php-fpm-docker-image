# Here are the images of PHP-FPM with aditional packages and using its Alpine version.
## Running

Use docker-compose to run services:

`docker-compose up`

A php file are placed in www folder and this folder is mounted as volume to /var/www/html, which is the root of the virtual host.

## How to build and publish a new version of this image to Docker Hub.

### Building images to publish updates

An easy method is to build with docker-compose. Docker Compose file is prepared to receive the image version from the .env file, so check it before build.

`docker-compose build --no-cache`

This {image name}:{version} will be used to reference this image during the publish operation.

**Versions** should be consistent with repo releases and that present into Dockerfiles.

### Publishing new version

#### Login

First, do login. If you are a member of the Core Team, at this moment you should use your own credentials from Docker Hub.

`docker login -u {your username}`

As auto build is not configured yet, publishing images versions are made manually.

Eg.:

Publishing, a release to core nginx web server:

`docker push marcosfreitas/core-php-fpm-web-server:{version}`