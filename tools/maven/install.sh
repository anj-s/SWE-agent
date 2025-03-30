#!/usr/bin/env bash

apt-get update && apt-get install -y --allow-downgrades --no-install-recommends \
    temurin-17-jdk=17.0.13.0.0+11 \
    maven=3.8.7-1 && \
    # Clean up to reduce image size
    apt-get clean && rm -rf /var/lib/apt/lists/*


export PATH=$PATH:/usr/share/maven/bin