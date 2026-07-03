# TaskWarrior Sync Container

A docker container sync task warrior tasks with taskchampion sync server and caldav (or another
service [see syncall](https://github.com/bergercookie/syncall) for more details) to use a mobile
make mobile usage for taskwarrior less pain-in-the-\*.

> [!NOTE]\
> Currently in "alpha - PoC - WiP state" => workforme ¯\\\_(ツ)\\\_/¯ -- I will try my best to make
> it as usable as possible and combine it with the docker compose of the [taskchampion-sync-server](https://github.com/GothenburgBitFactory/taskchampion-sync-server)

## Prerequirements

- taskchampion-sync-server setup
- caldav server (or other available sync with mobile app)
- copy env.example file (will be used to configure syncs)

## Usage

Run container with env file and mount sync-state folder to make sync persistent (uses pickle to
store sync state => will cause errors when state is not provided and second run):

> [!IMPORTANT]\
> If you change the usename the mount path need to be adjusted as well.

```bash
podman build -t synctw .
podman run --env-file=.env -v ./sync-state/:/home/synctw/.config/syncall/ --name synctw --replace synctw:latest
```
