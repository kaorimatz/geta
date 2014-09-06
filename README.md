# Geta

[![Code Climate](http://img.shields.io/codeclimate/github/kaorimatz/geta.svg?style=flat)](https://codeclimate.com/github/kaorimatz/geta)

## Description

Create the cobbler system record for your existing linux system based on the information collected through SSH.

## Usage

Run `geta` on the host that can login the target host via SSH:

    Usage: geta [options] <hostname>
        -n, --name              Specify system name.
        -p, --profile           Specify profile name to which system belongs.
            --ssh-user          Login with the given user.
            --ssh-password      Login with the given password.
        -h, --help              Display this help message.

## Example

Create a system record named `app1` which belongs to `fedora-20-x86_64` profile from `host1`:

    geta --name=app1 --profile=fedora-20-x86_64 host1 

Check the created system record:

    cobbler system report --name=app1

## Install

    gem install geta
