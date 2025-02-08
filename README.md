# Installing Docker in a remote server using Ansible script and running in Visual Studio Code using devcontainers

This repository is to run Ansible scripts to update Ubuntu in a remote server and to install Docker on it. The objective is to have a server that can later receive containerized applications.

## Prerequisites

- Ubuntu - I am running this in Ubuntu 24.10
- Docker installed and running
- Visual Studio Code installed
- VS Code Remote - Containers extension installed
- An Ubuntu remote server ready to work by ssh with a key deployed

## Setup Instructions

### Clone the Repository

Clone the project repository to your local machine:

```bash
git clone --depth 1 https://github.com/eduardoshanahan/devcontainers-deploy-docker new-project-name
cd new-project-name
rm -rf .git/
```

### Ensure you have an ssh key to connect to your remote server

The server will need to have a public ssh key uploaded, and you will need the corresponding private key in your local machine.

If you don't have a local key, you can create one with:

```bash
ssh-keygen -t ed25519 -a 100 -C "What am I going to do with this key" -f ~/.ssh~/bananas 
```  

and follow the instructions to have it applied in your server.

You can test that the ssh key works by running:

```bash
ssh -i ~/.ssh/bananas remoteuserbananas@bananas.com
```

### Configure Environment Variables

Copy the .env.example file to .env and update it with your details:

```bash
cp .devcontainer/.env.example .devcontainer/.env
```

Edit the .env file:

```bash
code .devcontainer/.env
```

Fill in the following details:

```dotenv
HOST_UID=1000 # Replace with your user's UID (run id -u to check)
HOST_GID=1000 # Replace with your user's GID (run id -g to check)
HOST_USERNAME="Your Name" # Replace with your user's name (run whoami to check)
GIT_USER_NAME="Your Name" # Replace with your Git username
GIT_USER_EMAIL="<your.email@example.com>" # Replace with your Git email
```

### Build and Launch the Dev Container

Open the project in VS Code:

Launch the Dev Container by running the provided script. This will ensure that all the environment variables are set correctly. Tis is important, because if they are empty VS Code will behave in strange ways (I saw the files missing, or root applied as the owner of the files created):

```bash
./launch_vscode.sh
```

### Verify the Setup

#### SSH is working

Make sure that SSH agent is running in your local machine. If it is not, you can start it with :

```bash
eval "$(ssh-agent -s)"
```

#### Ansible is working

Test a connection with the remote server set in inventory/hosts.yml:

```bash
cd /src
ansible remoteservers -m ping -i inventory/hosts.yml
```

#### Git configuration: repeated from devcontainers-git

Once the Dev Container is running, verify the following:

- User Permissions: The container should run as the same user as your host machine, avoiding permission issues.

```bash
whoami
```

- Git Configuration: Check that Git is configured correctly by running:

```bash
git config --global --list
```

Ensure the user.name and user.email match the values you provided in the .env file.

## Work in the Dev Container

You can now work on the project inside the Dev Container. All Git operations (commits, pushes, etc.) will use the configured Git user, ensuring consistency across environments.

### Additional hosts.yml configuration

```yml
remoteservers:
  hosts:
    "bananas.com":
      ansible_initial_user: "initial_username"
      ansible_initial_key_comment: "OVH Ubuntu user for initial deployment, replace after first call"
      ansible_deployment_user: "deployment_username"
      ansible_deployment_key_comment: "OVH Ubuntu user for deployment"
      ansible_ssh_common_args: "-o ForwardAgent=yes"
      ansible_python_interpreter: "/usr/bin/python3.10"
```

### Running the project

```bash
ansible-playbook run_all.yml
```

### Additional VS Code Settings

The .devcontainer/settings.json file includes recommended settings for the project, such as:

- Tab size: 2 spaces
- Format on save
- Default terminal shell: /bin/bash

These settings are automatically applied when working in the Dev Container.

## Troubleshooting

### Permission Issues

If you encounter permission issues, ensure that the HOST_UID and HOST_GID in the .env file match your host machine's user ID and group ID. You can check these values by running:

```bash
id -u # UID
id -g # GID
```

### Git Configuration

If Git is not configured correctly, you can manually set the Git user name and email inside the container:

```bash
git config --global user.name "Your Name"
git config --global user.email "<your.email@example.com>"
```

### Docker Issues

Ensure Docker is running and you have the necessary permissions to use it. If you encounter Docker-related issues, refer to the Docker documentation: <https://docs.docker.com/>

### SSH Key Permissions

Ensure that your SSH key (~/.ssh/bananas) has the correct permissions (typically chmod 600 ~/.ssh/bananas).

### Firewall/Network

Verify that there are no firewall or network restrictions blocking SSH access to the server.

## Project Structure

```scss
git-base/
├── .devcontainer/
│   ├── Dockerfile
│   ├── devcontainer.json
│   ├── .env
│   └── .env.example
├── launch_vscode.sh
├── src/
│   └── inventory/
│   └── roles/
│   └── ansible.cfg
│   └── run_all.yml
├── README.md
└── ... (other project files)
```

- .devcontainer/
  - Dockerfile: Defines the Docker image for the Dev Container.
  - devcontainer.json: Configures the Dev Container for VS Code.
  - settings.json: Recommended VS Code settings for the project.
  - .env.example: Template for environment variables.
  - .env: Environment variables (created by you).
- launch_vscode.sh: Script to launch VS Code with the Dev Container.
- src/: Directory for the project content itself
