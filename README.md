# Template Docker ROS

Build docker image with:

```bash
./build_image.sh
```

Run docker container with:

```bash
./run_container
```

You can exec the running container with:

```bash
docker exec -it template_docker_ros bash
```

Copy and mount the ROS packages you want to have in your docker container.
