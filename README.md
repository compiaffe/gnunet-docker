# gnunet-docker
A Dockerfile (and maybe later docker-compose.yml) for getting a running GNUnet docker container.

## Build it
This will take quite a while and will consume a bit of data.

```bash
docker build -t gnunet .
```

## Start it directly from the newly created gnunet image
Start a container from image `gnunet` which can access /dev/net/tun, has access to the host network and we are going to name it `gnunet_base`.

Note the `--rm` that will delete the container as soon as you stop it and `-ti` gives you an interactive terminal.

```bash
docker run \
  --rm \
  -ti \
  -v /dev/net/tun:/dev/net/tun \
  --privileged \
  --net=host \
  --name gnunet_base \
  gnunet
```

This terminal will keep on printing to screen at the moment. So go on in a new terminal please.

Don't worry about warnings too much...

## Check if you are connected
Open a new terminal and connect to the container we just started:

```bash
docker exec -it gnunet_base_new gnunet-peerinfo -i
```

If you get a list of peers, all is good.
