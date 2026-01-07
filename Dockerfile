FROM gitea/act_runner:latest

LABEL maintainer="b@rtsmeding.nl"
LABEL description="Gitea Act Runner with Ansible and Python packages"

# Install Python, Node.js, and Ansible-related dependencies
RUN apk update && \
    apk add --no-cache \
        python3 \
        py3-pip \
        py3-virtualenv \
        openssh \
        sshpass \
        git \
        curl \
        nodejs \
        npm && \
    pip3 install --upgrade pip setuptools --break-system-packages

# Copy and install requirements
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt --break-system-packages && rm /tmp/requirements.txt

# Add entrypoint
COPY docker-entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
