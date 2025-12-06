# Design

## Overview（highly personality）

## Status

### Software

- System Status

- Log View

### Hardware

- Internal Device Status

- External Device Status

### NetworkStatus

- Channel Scan

- Speed Status

- Wireless Status

## System

### General

- Info Setting

- Language Setting

- Time Setting

- Log Setting

- Performance Setting

### Security

- SSH Security (Final)

	- Password

	- Permission

- Luci Security

	- Password

	- HTTPS

## Application

### Manage

### OpenClash (Final)

- Overview

- Fast Operation

- All Operation

### SmartDNS

### DDNS

### WebSSH

### Other App...

## Network

### Network Intertface

### Wireless Network

### Router

### DHCP/DNS

### FireWall

### Dialog

## App

### Security

### Customize

### Import / Export

### Device

### MCP

## Main Topic 6

## Frontend Route

### /app

- /security

- /customize

- /config

- /device

- /mcp

### /framework

- /titleBar

- /pathBar

- /actionBtn

### /{device_name}

- /middleware

	- /{middleware_name}

- /page

	- /{page_name}

## Database

### {device}

- info

	- Luci

		- username

		- password

		- unknown certificate

		- baseURL

	- SSH

	- id

	- name

- mcp

	- mcpThing

- customization

	- {middleware}

		- {page}

		- {middleware}

### app

- passkey

- security

