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
├── delete-account.yml              # Deletes the old account
├── run-1.yml                       # Run this playbook first
├── run-2.yml
├── run-3.yml
├── ssh-keys                        # Contains all the ssh keys
│   ├── id_gh_daa
│   └── id_gh_daa.pub
└── tasks                           # Contains all the tasks
    ├── chrome.js                   # Chrome bookmarks
    ├── chrome.yml                  # Playbook for chrome bookmarks
    ├── directories.yml             # Deletes directories and creates new ones
    ├── dock.yml                    # Adds the necessary apps to the dock
    ├── firefox.js                  # Firefox bookmarks
    ├── firefox.yml                 # Playbook for firefox bookmarks
    ├── gnome.yml                   # Gnome settings
    ├── node.yml                    # Installs nodejs and nvm
    ├── os.yml                      # Updates the OS and packages (sometimes it fails)
    ├── ssh.yml                     # Configures the ssh keys
    ├── vscode.yml                  # Installs vscode and extensions
    └── zsh.yml                    # Installs zsh and oh-my-zsh and copies the zshrc file
```

## Pre-requisites

1. The ansible playbooks expect that the github organization and the ssh keys for `git iam` are already setup.

2. Before you begin, ensure that you have connected to all devices in the network by SSH at least once. This is necessary to add the devices to the known hosts file.

```sh
ssh user@192.168.20.xxx
```

When prompted, type `yes` to add the device to the known hosts file, enter the password, and then exit the connection by typing `exit`. 

Now you can proceed with the following steps. You only need to do this once.

## Install Ansible

1. Install [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## Setup hosts `(inventory.ini)`

All computers should have a unique static IP address. This is necessary to
identify the machines in the network.

1. If `inventory.ini` is empty, create the file and populate it with the target machines. Use `inventory.ini.example` as a template.

```ini
[auckland]
; pohutukawa-pohutukawa-2024 is the user name and 192.168.20.xxx is the IP address of the machine, where xxx is the unique number for the machine.
pohutukawa-2024@192.168.20.xxx

[auckland:vars]
; populate the necessary variables here, such as ansible_user, ansible_ssh_pass, etc.
```

The `inventory.ini` file is the only thing you need to add/edit. It contains sensitive information such as the IP address of the machines, the username, and the password.
Treat this just like `env` files.

## SSH keys

This step is necessary to configure the ssh keys for github and `git iam` to work.

1. Generate new ssh keys by following the instructions from Part 1 of the `akl-comp-setup` instruction from the teaching guide. 
2. Create a new directory in the root of this repo called `ssh-keys`and Copy both files, `id_gh_daa` and `id_gh_daa.pub` in there. 

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
- `delete-account.yml`: Deletes the old account (the account of the previous cohort).

This playbook creates a brand new account with the username defined in the
`inventory.ini` file. This way don't have to deal with clearing cookies, forms,
cache, or artifacts from the previous account.

1. Run the following command to create a new account and move to the next once the playbook is done

```sh
ansible-playbook -i inventory.ini run-1.yml
```

1. This playbook runs one at a time and it clones the `test` repo, appends some text to the readme file and it pushes the changes to the repo.

```sh
# This playbook runs one at a time
ansible-playbook -i inventory.ini run-2.yml
```

1. Sign in to the machine and open chrome to create a fake bookmark then close chrome and then run the following command

```sh
ansible-playbook -i inventory.ini run-3.yml
```

1. Delete the old linux account

```sh
ansible-playbook -i inventory.ini delete-account.yml
```

Congratulations 🎉, the machines are now ready for the next cohort.
