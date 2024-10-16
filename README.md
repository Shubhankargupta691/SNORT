# Snort with Docker

This repository contains a Docker setup for Snort, an open-source network intrusion detection system (NIDS). This setup allows you to easily deploy Snort in a containerized environment.

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Getting Started](#getting-started)
- [Building the Docker Image](#building-the-docker-image)
- [Running Snort](#running-snort)
- [Configuration](#configuration)
- [Custom Rules](#custom-rules)

## Features

- Real-time network traffic analysis
- Packet logging
- Easy deployment with Docker
- Customizable rules

## Requirements

- Docker
- Docker Compose (optional, for multi-container setups)

# Dockerfile Overview
The provided Dockerfile sets up Snort with the following:

Installs Snort and its dependencies
Creates a user and group for Snort
Configures necessary directories for logs and rules

## Getting Started

### Clone the Repository

```bash
git clone https://github.com/Shubhankargupta691/SNORT.git

cd snort
```

# Building the Docker Image
To build the Docker image, you can run the provided `build.sh` script:

```bash
./build.sh
```
## Customizing the Image Name
By default, the script builds the Docker image with the name snort2-image. **If you want to change the image name**, you can edit the ```build.sh``` file. Look for the following line:

```bash
docker build -t snort2-image .
```

# Running Snort

### After building the image, run the ```run.sh``` script to create a separate network for Snort, run the container, and execute it, in one go.

```bash
./run.sh
```
## Inside ```run.sh```:

1. **Create Docker Network**

   To create a Docker network, use the following command:

   ```bash
   docker network create --driver=bridge --opt com.docker.network.bridge.enable_ip_masquerade=true snort2_network
   ```
2. **Run a Container with Privileged Access**

    Use the command below to run a Snort container. The username for the container is ```snorty``
    
    ```bash
    docker run --rm --name snort2 -h snort2 -u snorty --privileged --network snort2_network -d -it snort2-image2 /bin/bash
    ```
3. **Execute a Command in the Running Container**

    To open an interactive shell inside the running Snort container, use the following command:

    ```bash
    docker exec -it --user root snort2 /bin/bash
    ```

# Configuration

## Change the Root Password

Once inside the container, you can change the root password using the following command:

```bash
passwd
```
You will be prompted to enter a new password. Make sure to set your own secure password for the root user.

## Setting Up ```$HOME_NET``` in Snort

### 1. Open the Snort configuration file:

    sudo nano /etc/snort/snort.conf

### 2. Locate the ```$HOME_NET``` definition, usually formatted as:
    
    ipvar HOME_NET any

### 3. Modify the IP address to reflect your network ```example```:
    
    ipvar HOME_NET 192.168.0.0/24

## Enable Promiscuous Mode

To enable promiscuous mode on the network interface, use the following command:

```bash
ip link set <network_interface_name> promisc on
```

You will find ```PROMISC``` in the title ```<BROADCAST,RUNNING,PROMISC,MULTICAST>```  when promiscuous mode is on.

Replace ```<network_interface_name>``` with the name of the network interface you wish to set to promiscuous mode (e.g., eth0). Replace ```<network_interface_name> ``` with the name of the network interface you wish to set to promiscuous mode (e.g., eth0). 

you can check your ```<network_interface_name>``` using ```ifconfig``` command.

## Start Snort 
TO test Snort's configuration and ensure that it is correctly set up.

```bash
snort -T -i <network_interface_name> -c /etc/snort/snort.conf
```
### Example 

My ```<network_interface_name>``` is eth0

```bash
snort -T -i eth0 -c /etc/snort/snort.conf
```

# Custom Rules

## **Add Custom Rules**

   You can add your own custom rules to Snort by editing the `local.rules` file located at `/etc/snort/rules/local.rules` within the container. To do this, open the file with a text editor:

   ```bash
   nano /etc/snort/rules/local.rules
   ```
   ### **Here how you can create your own rules**

  Write your custom rules: A basic rule format is:

   ```bash
    alert <protocol> <source_ip> <source_port> -> <dest_ip> <dest_port> (msg:"Your message"; sid:1000001; rev:1;)
   ```

   # Example

## 1. Rule to alert on ICMP (ping):

    alert icmp any any -> $HOME_NET any (msg: "ICMP Ping Detected"; sid:100001; rev:1;)

## 2. Rule for detecting SSH authentication:

    alert tcp any any -> $HOME_NET any (msg: "SSH AUTHENTICATION ATTEMP"; sid:100002; rev:1;)


# Run Snort using root user:

    snort -q -l /var/log/snort -i network_interface -A console -c /etc/snort/snort.conf

## NOTE: 
If no error is generated then it's working fine. 

## Example

    snort -q -l /var/log/snort -i eth0 -A console -c /etc/snort/snort.conf







