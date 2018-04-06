#!/bin/bash

# backup current users
mkdir -p /backup/.etc
rsync -a /etc/passwd /backup/.etc/passwd
rsync -a /etc/shadow /backup/.etc/shadow
rsync -a /etc/gshadow /backup/.etc/gshadow
rsync -a /etc/group /backup/.etc/group