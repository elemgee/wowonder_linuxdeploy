#!/bin/bash
# This script is intended to automate as much as possible, the
# installation and configuration of a WebObjects server. The goal is to
# have a complete working WebObjects environment (apache, WebObjects
# (wotaskd/womonitor)) running on a linux server at the end of this
# script.
# 
# 
# This script was initially developed with the opensuse studio
# environment in mind, but it shouldn't be too hard to adapt this for
# other distributions.
# 
# 
# The biggest opensuse issue is probably the java configuration and the
# "alternatives" structure that allows you to move between different
# versions or environments (I will not say "easily" but it's at least
# possible and the entertainment value of dancing around as you shoot at
# your own feet is probably worth something ... to someone other than
# the foot shootee)
# 
# This script is based primarily on the instructions found at
# http://wiki.wocommunity.org/display/WO/Deploying+on+Linux along with
# some experimentation of my own. A Thousand Thanks to Pascal Robert,
# Paul Yu, Amendeo Mantica, Johan Hemselmans, Brian Elsmore, Kieran
# Kelleher, David LeBer, Joe Little, Danielle C. Robert R
# Tupelo-Schneck, Julius Spencer and anyone else who contributed to that
# page or it's predecessors
#
# $Id$

################################################################################
# ENVIRONMENT SETUP
# common pieces that are probably good candidates for command line arguments
#
export NEXT_ROOT=/srv/www/WebObjects
export JAVA_APPS=$NEXT_ROOT/Local/Library/WebObjects/JavaApplications
export WO_INSTALLATION_RESOURCES=$NEXT_ROOT/installation

export WOUSER=appserver
export WOGRP=appserveradm

# useful commands 
export SUDO=`which sudo`
export UPDATE_ALTERNATIVES=`which update-alternatives`
 
export GROUPADD=`which groupadd`
export USERADD=`which useradd`
export CHMOD=`which chmod`
export CHOWN=`which chown`


export WGET=`which wget`
export CURL=`which curl`
export GIT=`which git`

################################################################################
# INSTALL JAVA
# This is probably somewhat specific to OpenSuSE so this is a good candidate
# for distribution specific modification
#
# Because the download and licensing of Java is more restrictive than can be 
# dealt with in a basic script like this (and because I want to steer clear 
# of things that will piss off large legal departments like that of Oracle
# Corporation) you must download the java package before running this script.
# This is probably another good candidate for a command line switch that handles
# this more gracefully.

export JAVA_SE_SDK_FILE=$WO_INSTALLATION_RESOURCES/jdk-6u33-linux-x64.bin
export PATH_VERSION=jdk1.6.0_33 # this can probably be parsed from the value above...
$CHMOD +x $JAVA_SE_SDK_FILE
$JAVA_SDK_FILE

$UPDATE_ALTERNATIVES --install /usr/bin/java java /opt/java/$PATH_VERSION/jre/bin/java 0
$UPDATE_ALTERNATIVES --install /usr/bin/javac javac /opt/java/$PATH_VERSION/bin/javac 0 
$UPDATE_ALTERNATIVES --install /usr/bin/javaws javaws /opt/java/$PATH_VERSION/bin/javaws 0 
$UPDATE_ALTERNATIVES --install /usr/lib/java java_sdk /opt/java/$PATH_VERSION 0


################################################################################
# install WebObjects
cd $WO_INSTALLATION_RESOURCES
$CURL -C  -O http://wocommunity.org/documents/tools/WOInstaller.jar 
java -jar $WO_INSTALLATION_RESOURCES/WOInstaller.jar 5.4.3 $NEXT_ROOT
$SUDO $GROUPADD $WOGRP
$SUDO $USERADD -g $WOGRP $WOUSER
echo "export NEXT_ROOT=$NEXT_ROOT" >> ~appserver/.bash_profile


################################################################################
# install Wonder

cd $WO_INSTALLATION_RESOURCES
$GIT clone https://github.com/projectwonder/wonder.git


# install mod_WebObjects from Project WONder


################################################################################
# install demo app 

# configure womonitor and wotaskd
mkdir -p $JAVA_APPS
cd $WO_INSTALLATION_RESOURCES
$CURL -C -O http://jenkins.wocommunity.org/job/Wonder/lastSuccessfulBuild/artifact/Root/Roots/wotaskd.tar.gz
tar zxf wotaskd.tar.gz
rm wotaskd.tar.gz
$CURL -C -O http://jenkins.wocommunity.org/job/Wonder/lastSuccessfulBuild/artifact/Root/Roots/JavaMonitor.tar.gz
tar zxf JavaMonitor.tar.gz
rm JavaMonitor.tar.gz
$CHOWN -R $WOUSER:$WOGRP $NEXT_ROOT/Local
$CHOWN -R $WOUSER:$WOGRP $NEXT_ROOT/Library
$CHOWN 750 $NEXT_ROOT/Local/Library/WebObjects/JavaApplications/JavaMonitor.woa/JavaMonitor
chmod 750 $NEXT_ROOT/Local/Library/WebObjects/JavaApplications/wotaskd.woa/Contents/Resources/SpawnOfWotaskd.sh
chmod 750 $NEXT_ROOT/Local/Library/WebObjects/JavaApplications/wotaskd.woa/wotaskd 




# install Jenkins




