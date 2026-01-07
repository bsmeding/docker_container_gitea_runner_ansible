FROM gitea/act_runner:0.2.13

LABEL maintainer="b@rtsmeding.nl"
LABEL description="Gitea Act Runner with Ansible and Python packages"

# Install base dependencies (Alpine)
RUN apk add --no-cache \
      python3 \
      py3-pip \
      py3-virtualenv \
      ca-certificates \
      git \
      curl \
      openssh-client \
      sshpass \
      nodejs \
      npm \
    && update-ca-certificates

# Create and use a dedicated virtualenv for Python tooling
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv "$VIRTUAL_ENV" \
    && "$VIRTUAL_ENV/bin/pip" install --no-cache-dir --upgrade pip setuptools wheel
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Copy and install requirements into venv
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt \
    && rm -f /tmp/requirements.txt

# Add entrypoint
COPY docker-entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 0755 /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
