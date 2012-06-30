# StatsD Installer w/ Librato Metrics

This is a basic installation script and service for installing [Etsy's node.js StatsD server](https://github.com/etsy/statsd) on CentOS 6, as well as the [Librato Metrics](https://metrics.librato.com/) [backend](https://github.com/librato/statsd-librato-backend).

It logs to ``/var/log/statsd``, installs the config in ``/etc/statsd/local.js`, and lets you use CentOS' `service statsd start`.

The init.d script (`statsd.sh`) is roughly based off of [this script by nariyu](https://gist.github.com/1211413). 