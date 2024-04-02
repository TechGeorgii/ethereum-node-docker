# Docker containers for Ethereum node

This is the Docker Compose to launch [Ethereum node](https://ethereum.org/en/developers/docs/nodes-and-clients/run-a-node/). 
It uses Geth as execution client, Prysm as consensus client.

## Motivation
Official docs for [Geth](https://geth.ethereum.org/docs/fundamentals) and [Prysm](https://docs.prylabs.network/docs/getting-started) do not explain 
all challenges to run a node in docker containers. That's why I decided to create docker compose files that can be used by everyone to spin off 
your own node. I am also writing it for myself to remember how to do certain things.

## Architecture
Docker compose contains 3 services:

### geth
This is execution client [Geth](https://geth.ethereum.org/docs/fundamentals), its main purpose is to listen to network's transactions, execute them and keep latest
Ethereum state and database data.

### beacon
A [beacon node](https://docs.prylabs.network/docs/how-prysm-works/beacon-node) (also called a consensus node) , implements a proof-of-stake consensus mechanism.

### ubuntu
This is the service running in the same Docker network as node services and is used to access them.
It contains `Geth` and utils like `curl`, `ping`, `telnet`. To access services `geth` and `beacon` enter the container:

`docker exec -it gsavchenko-node-ubuntu /bin/bash`

Then you can attach to geth to use geth console
`geth attach http://gsavchenko-mainnet-geth:8545`. For more monitoring options see [this tutorial](https://docs.prylabs.network/docs/monitoring/checking-status).
Instead of `localhost` you must use names of services like in `geth attach http://gsavchenko-mainnet-geth:8545` command.

You can also use [Clef](https://geth.ethereum.org/docs/tools/clef/introduction) from this service. First time you need to init master seed as
`clef init` and generate keystore accounts `clef newaccount`. Then you can just run `clef` in separate terminal and you'll be able confirm requests from `geth` (for instance, when `eth.accounts` is called 
in geth console):

`clef --ipcdisable --http --http.addr=0.0.0.0 --http.vhosts=* --nousb`

## Files
Volume mappings are created to persist files outside of containers. These are host machine's paths:
- `/home/gsavchenko/.clef` – clef's master seed (**change to your own**, here is `gsavchenko` user in the path)
- `/crypto/mainnet/ethereum/keystore` – clef's keystore
- `/crypto/mainnet` – geth's data
- `/crypto/mainnet/ethereum` – beacon's data.

## External ports to be opened out of Docker host machine
- 30303 (tcp + udp) - geth node listener (tcp) and discovery (udp)
- 13000 (tcp) - beacon node data
- 12000 (udp) - beacon node discovery
