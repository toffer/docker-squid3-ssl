Docker-Squid3-SSL
=================

A Squid3 caching proxy with HTTPS enabled.

Problem
-------
How many times do you run `docker pull ubuntu`? Tired of waiting for it 
to download over and over?

Cache it!

Details
-------
* Ubuntu 13.10 (Saucy Salamander).
* Squid (Version 3.3.8).
* Built from source, with --enable-ssl.
* Self-signed certificate automatically generated on startup.
* Configured to cache Docker images (default config for Squid3 doesn't cache images)

License
-------
MIT license. Copyright (c) 2013 Tom Offermann.
