# gnunet-docker
A Dockerfile (and maybe later docker-compose.yml) for getting a running GNUnet docker container.

## Build it
This will take quite a while and will consume a bit of data.

    docker build -t gnunet .

## Start it directly from the newly created gnunet image
Start a container from image 'gnunet' which can access /dev/net/tun, has access to the host network and we are going to name it 'gnunet_base'.

Note the '--rm' that will delete the container as soon as you stop it. --ti just gives you an interactive terminal. '/bin/bash' is the command we execute in the container - a bash shell.

    docker run --rm -ti -v /dev/net/tun:/dev/net/tun --privileged --net=host --name gnunet_base gnunet /bin/bash
    # Inside the container start gnunet
    gnunet-arm -c /etc/gnunet.conf -s

This terminal will keep on printing to screen at the moment. So go on in a new terminal please.

Don't worry about warnings too much...

## Check if you are connected
Open a new terminal and connect to the container we just started:

    docker exec -ti gnunet_base /bin/bash
    # Inside the container see your peers
    gnunet-peerinfo -i

If you get a list of peers, all is good.
