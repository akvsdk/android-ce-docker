#!/bin/bash
java -jar /opt/agent.jar -jnlpUrl JENKINS-SERVER-jnlpURL -secret SECRET-CODE -workDir "/var/jenkins_home" >/var/jenkins_home/agent.log 2>&1 &