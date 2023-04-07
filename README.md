# Here is the image of PHP-FPM with additional packages and using its Alpine version.

![Docker](https://github.com/Skinny-Hosts/core-php-fpm-docker-image/workflows/Docker/badge.svg?branch=master)

## Running

Use docker-compose to run service:

`docker-compose up`

A php file are placed in www folder and this folder is mounted as volume to /var/www/html, which is the root of the virtual host.

### New Releases

Our images are hosted into GitHub Container Registry.
New releases are made automatically from push/pull-requests events to the branch **master**.

#### Releasing
Two images are built with two tags:

- "latest"
- a numeric tag

For "latest" is automatically labeled at the PR merges.

For numeric version, the new tag (v.1.2.3) should be pushed to **master** to trigger another build process.

### Performance Improvements

Some `pm` default values are changed on `/usr/local/etc/php-fpm.d/www.conf` file. This is a experimental configuration to boost the PHP-FPM on highly consumed projects. It is totally up to you to configure it based on your project and experience.

These are all the properties that are customized currently:

```
Automatically adjusts the number of child processes based on incoming requests for optimized performance and resource usage.
pm = dynamic

Maximum number of child processes to spawn
pm.max_children = 400

Defines the number of child processes that are spawned when PHP-FPM is started or restarted
pm.start_servers = 80

The desired minimum number of idle server processes
pm.min_spare_servers = 20

The desired maximum number of idle server processes
pm.max_spare_servers = 100

The maximum number of requests each child process should handle
pm.max_requests = 500

The number of seconds after which an idle process will be terminated
pm.process_idle_timeout = 10s;

The number of seconds after which a child process will be terminated if it hasn't responded to a request
pm.request_terminate_timeout=60s;

The number of seconds after which a child process will be terminated if it hasn't finished processing a request
pm.response_terminate_timeout=120s;

Enables logging for slow requests
slowlog = log/$pool.log.slow
catch_workers_output = yes
```

**For the configurations above, there are available env vars for you customize these values:**

```
PHP_PM=dynamic
PHP_PM_MAX_CHILDREN=400
PHP_PM_START_SERVER=80
PHP_PM_MIN_SPARE_SERVERS=20
PHP_PM_MAX_SPARE_SERVERS=100
PHP_PM_MAX_REQUESTS=500
PHP_PM_IDLE_TIMEOUT=10s
PHP_PM_REQUEST_TERMINATE_TIMEOUT=60s
PHP_PM_RESPONSE_TERMINATE_TIMEOUT=120s
```
