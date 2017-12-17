% TAURUS (1) Container Image Pages
% DL Devops Engineering Tools <dldevopsengineeringtools@worldpay.com>
% August 18, 2017

# NAME

taurus \- Taurus is an automation-friendly framework for Continuous Testing

# DESCRIPTION

The Jenkins slave Taurus image has Taurus installed on top of the OpenShift Jenkins
slave base image.

The taurus image is designed to be run by the atomic command with one of these options:

`run`

Starts the installed container with selected privileges to the host.

`stop`

Stops the installed container

The container itself consists of:

    \- Jenkins slave RHEL 7 base image
    \- OpenJDK 1.8.0
    \- Taurus test framework

Files added to the container during docker build include: /help.1 and the Dockerfile itself

# "USAGE"
To use the taurus container, you can run the atomic command with run or stop
options:

To run the taurus container:

  `atomic run taurus`

To stop the taurus container:

  `atomic stop taurus`

# LABELS
The taurus container includes the following Atomic LABEL settings:
that `atomic` command can leverage:

`RUN`

  LABEL RUN="docker run -d --name ${NAME} ${IMAGE} \
  -v /etc/machine-id:/etc/machine-id:ro \
  -v /etc/localtime:/etc/localtime:ro \
  -e IMAGE=IMAGE -e NAME=NAME"

`STOP`

  LABEL STOP='docker stop ${NAME}'

# HISTORY

TBC
