[![Docker Automated Build](https://img.shields.io/docker/automated/t7tran/gcloud-pubsub-emulator.svg)](https://hub.docker.com/r/t7tran/gcloud-pubsub-emulator/) [![Docker Build Status](https://img.shields.io/docker/build/t7tran/gcloud-pubsub-emulator.svg)](https://hub.docker.com/r/t7tran/gcloud-pubsub-emulator/builds/) [![Docker Pulls](https://img.shields.io/docker/pulls/t7tran/gcloud-pubsub-emulator.svg)](https://hub.docker.com/r/t7tran/gcloud-pubsub-emulator/) [![Docker Stars](https://img.shields.io/docker/stars/t7tran/gcloud-pubsub-emulator.svg)](https://hub.docker.com/r/t7tran/gcloud-pubsub-emulator/) [![License](https://img.shields.io/github/license/t7tran/docker-gcloud-pubsub-emulator.svg)](https://raw.githubusercontent.com/t7tran/docker-gcloud-pubsub-emulator/blob/master/LICENSE.md)

# [Google Cloud Pub/Sub Emulator Image](https://hub.docker.com/r/t7tran/gcloud-pubsub-emulator/)

[*Cloud Pub/Sub*](https://cloud.google.com/pubsub/) is a global service for real-time and reliable messaging and streaming data

This image provides a dockerized version of the *Google Cloud Pub/Sub Emulator*. It is intended to be used as a service on development environments (it **SHOULD NOT** be used in production environments). You can check *Cloud Pub/Sub* documentation on [Google Cloud Platform documentation website](https://cloud.google.com/pubsub/docs/).

## Usage
The following shell statement show the most simple execution of the provided image. It will execute the *Pub/Sub Emulator* that will listen on port 8538.

```sh
docker run --rm --tty --interactive --publish 8538:8538 --name pubsub t7tran/gcloud-pubsub-emulator
```

The image is much more useful when it is used in a CD/CI automated environment. The following example shows how to configure the *Pub/Sub Emulator* to be used in a [*Wercker*](http://www.wercker.com/) development pipeline.

```sh
box: python:3.5

dev:
  services:
    - name: pubsub
      id: t7tran/gcloud-pubsub-emulator
      cmd: start --host-port 0.0.0.0:8538

  steps:
    - script:
      name: Define Pub/Sub environment variables
      code: |
        ADDR=$PUBSUB_PORT_8538_TCP_ADDR
        PORT=$PUBSUB_PORT_8538_TCP_PORT
        export PUBSUB_EMULATOR_HOST=$ADDR:$PORT

    - internal/shell:
      cmd: bash
```

## Configuration
The most important configuration parameters of the *Pub/Sub emulator* image are the host/port value the server will listen on and the directory where data files will be placed. By default, the image is configured to listen on `127.0.0.1:8538` and store its files in the `/data` directory. This behavior can be changed by providing the correct command-line options.

The following example shows how to start the *Pub/Sub emulator* to listen on `192.168.1.3:12345` and to store its files in the `/pubsub-data` directory.

```sh
docker run --rm --tty --interactive --name pubsub t7tran/gcloud-pubsub-emulator start --host-port=192.168.1.3:12345 --data-dir=/pubsub-data
```

**NOTE**: Wercker's documentation can be checked online on [Wercker Documentation Website](http://devcenter.wercker.com/docs/home)

## Helpers

Assuming the above commands were used to launch the container, the following commands can be used. Just run the command to reveal its syntax. 

```sh
docker exec -it pubsub publish # publish some data to a topic
docker exec -it pubsub pull # pull (await) message(s) from a subscription
docker exec -it pubsub pull-data # pull (await) data from a subscription
docker exec -it pubsub ack # acknowledge a message from a subscription
docker exec -it pubsub pull-ack # pull (await) data from a subscription then acknowledge upon receipt
```