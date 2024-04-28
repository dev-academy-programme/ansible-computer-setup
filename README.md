# About

This repository contains the Ansible playbooks to reset a machine after a cohort ends.
The ansible scripts allows you to reset the machine to a clean state and ready for the next cohort.

## Directory structure

```sh
.
├── README.md
├── ansible.cfg
├── gnome-terminal-settings.dconf   # Terminal settings (colors and fonts)
├── images
│   └── daa-wallpaper.png
├── inventory.ini                   # Contains the target machines
├── new-account.yml                 # Create a new account
├── run-1.yml                       # Run this playbook first
├── run-2.yml
├── run-3.yml
├── ssh-keys                        # Contains all the ssh keys
│   ├── id_gh_daa
│   └── id_gh_daa.pub
└── tasks                           # Contains all the tasks
    ├── chrome.js
    ├── chrome.yml
    ├── directories.yml
    ├── dock.yml
    ├── firefox.js
    ├── firefox.yml
    ├── gnome.yml
    ├── node.yml
    ├── os.yml
    ├── ssh.yml
    ├── vscode.yml
    └── zsh.yml
```

## Install

1. Install [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## Setup hosts

1. Populate the `inventory.ini` file with the target machines.

```ini
[auckland]
eda@192.168.1.xxx

[auckland:vars]
; populate the necessary variables here, such as ansible_user, ansible_ssh_pass, etc.
```

## SSH keys

This step is necessary to configure the ssh keys for github and `git iam` to work.

1. Generate new ssh keys by following the instructions from your wiki
2. Copy both files to the `ssh-keys` directory

## Run

1. Run `ansible-playbook -i inventory.ini run-1.yml` to run the first part of the playbook.
1. Reboot all machines.
1. Open chrome and open a new tab.
1. Click on the `+` icon to create a new bookmark and enter any dummy name in the `Name` and `URL` fields.
1. Close the browser.
1. Run `ansible-playbook -i inventory.ini run-2.yml` to run the second part of the playbook. This playbook will setup the pinned bookmarts to the homepage in chrome.

## Verify

1. Go to the cohort org and verify that all machines have successfully committed by checking the README.md file.

