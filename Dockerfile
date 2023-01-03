# Start from the code-server Debian base image
FROM codercom/code-server:4.9.1

USER coder

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Install unzip + rclone (support for remote filesystem)
RUN sudo apt-get update && sudo apt-get install unzip -y
RUN curl https://rclone.org/install.sh | sudo bash

# Copy rclone tasks to /tmp, to potentially be used
COPY deploy-container/rclone-tasks.json /tmp/rclone-tasks.json

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# You can add custom software and dependencies for your environment below
# -----------

RUN sudo apt install openjdk-17-jdk openjdk-17-jre -y

# Install a VS Code extension:
# Note: we use a different marketplace than VS Code. See https://github.com/cdr/code-server/blob/main/docs/FAQ.md#differences-compared-to-vs-code
# RUN code-server --install-extension esbenp.prettier-vscode
RUN code-server --install-extension esbenp.prettier-vscode
RUN code-server --install-extension max-ss.cyberpunk
RUN code-server --install-extension pkief.material-icon-theme
RUN code-server --install-extension redhat.java
RUN code-server --install-extension vscjava.vscode-java-debug
RUN code-server --install-extension vscjava.vscode-java-dependency
RUN code-server --install-extension vscjava.vscode-java-pack
RUN code-server --install-extension vscjava.vscode-java-test
RUN code-server --install-extension vscjava.vscode-java-debug
RUN code-server --install-extension vscjava.vscode-maven
RUN code-server --install-extension formulahendry.code-runner

# Install apt packages:
# RUN sudo apt-get install -y ubuntu-make

# Copy files: 
# COPY deploy-container/myTool /home/coder/myTool

# -----------

# Port
ENV PORT=8080

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
