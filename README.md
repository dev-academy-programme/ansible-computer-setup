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

## Install Ansible

1. Install [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## Setup hosts `(inventory.ini)`

All computers should have a unique static IP address. This is necessary to
identify the machines in the network.

1. If `inventory.ini` is empty, create the file and populate it with the target machines. Use `inventory.ini.example` as a template.

```ini
[auckland]
; eda is the user name and 192.168.1.xxx is the IP address of the machine, where xxx is the unique number for the machine.
eda@192.168.1.xxx

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

1. If all machines are reachable, move to the next step.

## Run Ansible Playbooks (METHOD 1)

### Update the Operating System and packages

In this step, we will update the operating system and install the necessary packages.

1. Run the following command

```sh
ansible-playbook -i inventory.ini run-1.yml
```

1. Restart/Reboot all machines.

```sh
ansible all -m reboot -b i inventory.ini
```

1. Expect to see a lot of output in red, but then the output will turn yellow.
   This is normal.

At this point, the machines should have been updated and rebooted.

### Reset the machine

Here we will use the `run-2.yml` playbook to reset the machine to a clean state.

1. Run the following command

```sh
ansible-playbook -i inventory.ini run-2.yml
```

NOTE: This playbook may fail at at a step where it tries to push the changes
to github. If this happens, go to github and confirm that the commit was made.

Press CTRL+C to stop the playbook and move to the next step.

### Chrome

This last playbook will setup the pinned bookmarks in chrome and it requires
you to go to each machine and do the following steps:

1. Open chrome and open a new tab.
1. Click on the `+` icon to create a new bookmark and enter any dummy name in
   the `Name` and `URL` fields.
1. Close the browser.
1. Repeat for all machines.
1. Run the last playbook to reset the pinned bookmarks.

```sh
ansible-playbook -i inventory.ini run-3.yml
```

Congratulations 🎉, the machines are now ready for the next cohort.

## Run Ansible Playbooks (METHOD 2)

### Creating a new account

If you need to create a new account, you can use the `new-account.yml` playbook.
This playbook will run all of the previous steps and create a new account.

This playbook creates a brand new account with the username defined in the
`inventory.ini` file. This way don't have to deal with clearing cookies, forms,
cache, or artifacts from the previous account.

1. Run the following command

```sh
ansible-playbook -i inventory.ini new-account.yml
```
