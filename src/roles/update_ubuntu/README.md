# Update Ubuntu Role

This role updates the Ubuntu system packages and performs system upgrades.

## What it does

- Updates package cache (`apt update`)
- Upgrades all packages (`apt upgrade`)
- Ensures system is up to date with latest security patches

## Usage

This role is typically run as part of initial server setup or regular maintenance.

## Configuration

No configuration required - this role uses default Ubuntu package management settings.

## Security

- Updates include security patches
- Helps maintain system security by keeping packages current
- Should be run regularly as part of maintenance schedule
