This project is made using the course:learn docker from boot.dev

````markdown
## Docker Commands & Notes

---

### 🔹 Docker Basics

```bash
docker images                   # list of docker images
docker ps -a                   # see all containers, even those that aren't running
docker stop <CONTAINER_ID>     # stop the running container
docker rm <CONTAINER_ID>       # remove the container
````

---

### 🔸 Docker Volumes

Docker volumes are pieces of storage on disk. They do **not** disappear when a container is restarted, shut down, or replaced.

```bash
docker volume create <volume_name>
docker volume ls
docker volume inspect <volume_name>
```

#### Example:

```bash
docker run -d \
  -e NODE_ENV=development \
  -e url=http://localhost:3001 \
  -p 3001:2368 \
  -v ghost-vol:/var/lib/ghost \
  ghost
```

* `-d` runs the image in detached mode to avoid blocking the terminal.
* `-e NODE_ENV=development` sets an environment variable within the container. This tells Ghost to run in "development" mode.
* `-e url=http://localhost:3001` tells Ghost to be accessible via that URL on the host.
* `-p 3001:2368` does port-forwarding between the container and the host machine.
* `-v ghost-vol:/var/lib/ghost` mounts the `ghost-vol` volume to persist Ghost CMS data.

👉 Navigate to [http://localhost:3001/](http://localhost:3001/) in your browser to see Ghost CMS.

---

### 🔧 Running Inside a Container

```bash
docker exec <CONTAINER_ID> ls           # executes the ls command inside the container
docker exec -it <CONTAINER_ID> /bin/sh  # interactive shell session inside container
```

* `-i` makes the exec command interactive
* `-t` gives us a TTY (keyboard interface)
* `/bin/sh` gives a shell session

---

### 🌐 Networking & Load Balancing

#### Block network access:

```bash
--network none  # stops the container from connecting to any external networks
```

#### Create an application server named `caddy1` in a custom network:

```bash
docker network create caddytest

docker run -d \
  --name caddy1 \
  --network caddytest \
  -v $PWD/index1.html:/usr/share/caddy/index.html \
  caddy
```

---

### ⚖️ Load Balancing with Caddy

* A custom bridge network lets containers communicate with each other.
* Load balancer is exposed to the internet; app servers are accessible only via the load balancer.

#### Configure load balancer:

1. Stop and remove any containers that aren't `caddy1` or `caddy2`.
2. Create a file called `Caddyfile`:

```
localhost:80

reverse_proxy caddy1:80 caddy2:80 {
    lb_policy round_robin
}
```

This tells Caddy to:

* Listen on `localhost:80`
* Round-robin traffic between `caddy1:80` and `caddy2:80`
* Work because all containers are on the same network (`caddytest`)

#### Run the load balancer:

```bash
docker run -d \
  --network caddytest \
  -p 8880:80 \
  -v $PWD/Caddyfile:/etc/caddy/Caddyfile \
  caddy
```

👉 Visit [http://localhost:8880/](http://localhost:8880/)
Refresh to see traffic switching between servers.

---

### 📦 Go Server with Docker

* Built a server and dockerized it (ran it inside Docker).
* Copied the binary files from local system to container.
* Built Dockerfile into an image and started a new container:
* Go is particularly Docker-friendly due to: Static binaries (no runtime dependencies), Fast build + small image sizes, Easy cross-compilation

```bash
docker build . -t goserver:latest
docker run -p 8010:8010 goserver
```

### 🐹 Why Go is Great in Docker

* Static binary: no runtime dependencies
* Small image size
* Simple to build and deploy

---

### 📊 Docker Logs & Monitoring

```bash
docker logs [OPTIONS] CONTAINER         # show logs
docker stats [OPTIONS] [CONTAINER...]   # live resource usage
docker top CONTAINER                    # processes running inside container
```

Use:

* `stats` for whole-container resource usage
* `top` for process-level visibility

#### Resource Limits:

```bash
--memory="512m"    # limit container memory
--cpus="1.0"       # limit CPU shares
```

---

### ✅ Summary

* Created a custom bridge network `caddytest`
* Launched application servers `caddy1` and `caddy2` in the same network
* Configured and deployed a Caddy-based load balancer
* Dockerized and ran a Go server
* Learned how to inspect, manage, and monitor containers

```

