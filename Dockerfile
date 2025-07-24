# This is a comment

# Use a lightweight debian os
# as the base image
FROM debian:stable-slim

# execute the 'echo "hello world"'
# command when the container runs
COPY docker_test /bin/docker_test
ENV PORT=8991

CMD ["/bin/docker_test"]