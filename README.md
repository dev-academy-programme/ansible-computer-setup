# About

This repository contains the Ansible playbooks to reset the campus computers after a cohort ends.
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

## Pre-requisites

1. The ansible playbooks expect that the github organization and the ssh keys for `git iam` are already setup.

2. Before you begin, ensure that you have connected to all devices in the network by SSH at least once. This is necessary to add the devices to the known hosts file.

```sh
ssh user@192.168.20.xxx
```

When prompted, type `yes` to add the device to the known hosts file, then exit the connection by typing `exit`.

Now you can proceed with the following steps. You only need to do this once.

## Install Ansible

1. Install [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## Setup hosts `(inventory.ini)`

All computers should have a unique static IP address. This is necessary to
identify the machines in the network.

1. If `inventory.ini` is empty, create the file and populate it with the target machines. Use `inventory.ini.example` as a template.

```ini
[auckland]
; matai-matai-2024 is the user name and 192.168.20.xxx is the IP address of the machine, where xxx is the unique number for the machine.
matai-2024@192.168.20.xxx

[auckland:vars]
; populate the necessary variables here, such as ansible_user, ansible_ssh_pass, etc.
```

## SSH keys

This step is necessary to configure the ssh keys for github and `git iam` to work.

1. Generate new ssh keys by following the instructions from your wiki
2. Copy both files, `id_gh_daa` and `id_gh_daa.pub` to the `ssh-keys/` directory

## Ping the machines

1. Run the following command to ping all the machines in the inventory file.

```sh
ansible -i inventory.ini -m ping all
```

1. If all machines are reachable, you should see the following output in green
   and no red lines.

```sh
192.168.1.xxx | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

## Run Ansible Playbooks

I highly recommend to run the playbooks to target a maximum of 2 machines at a time.
To get your self familiar with the workflow I suggest you run the playbooks on a single
machine first and once you are comfortable with the process, you can run the playbooks on 2 machines.

The playbooks are divided into 3 parts:

- `run-1.yml`: Creates a new Ubuntu account and configures, zsh, gnome, ssh, and directories.
- `run-2.yml`: Clones the `test` repo, appends some text to the readme file and it pushes the changes to the repo. `serial` is set to `1` to avoid git conflicts.
- `run-3.yml`: Sets the bookmarks for chrome. You may need to be close to the machine to create the bookmarks.
- `delete-account.yml`: Deletes the old account

This playbook creates a brand new account with the username defined in the
`inventory.ini` file. This way don't have to deal with clearing cookies, forms,
cache, or artifacts from the previous account.

1. Run the following command

```sh
# before the playbook ends, it will prompt you to open chrome and create fake pinned bookmarks
ansible-playbook -i inventory.ini run-1.yml
# once run-1.yml is done, run the following command
ansible-playbook -i inventory.ini run-2.yml
```

Congratulations 🎉, the machines are now ready for the next cohort.

2. Delete the old linux account

```sh
ansible-playbook -i inventory.ini delete-account.yml
# A prompt will ask you to enter the name of the account to delete (the old cohort's account)
```
