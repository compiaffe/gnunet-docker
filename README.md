# gnunet-docker
A Dockerfile (and maybe later docker-compose.yml) for getting a running GNUnet docker container.

## Build it
This will take quite a while and will consume a bit of data.

```bash
docker build -t gnunet .
```

## Start it from the newly created gnunet image
Start a container from `gnunet` image, which can access /dev/net/tun, has access to the host network. We are going to name it `gnunet1`.

Note the `--rm` that will delete the container as soon as you stop it and `-ti` gives you an interactive terminal.

#### Linux Users
```bash
docker run \
  --rm \
  -ti \
  --privileged \
  --name gnunet1 \
  --net=host \
  -v /dev/net/tun:/dev/net/tun \
  gnunet
```

#### Mac Users
```bash
docker run \
  --rm \
  -it \
  --privileged \
  --name gnunet1 \
  -p 2086:2086 \
  -p 2086:2086/udp \
  -p40001-40200:40001-40200 \
  -p40001-40200:40001-40200/udp \
  gnunet
```

This terminal will keep on printing to screen at the moment. So go on in a new terminal please.

Don't worry about warnings too much...

## Check if you are connected
Open a new terminal and connect to the container we just started:

```bash
docker exec -it gnunet1 gnunet-peerinfo -i
```

If you get a list of peers, all is good.
