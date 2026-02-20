FROM gitea/act_runner:0.3.0

LABEL maintainer="b@rtsmeding.nl"
LABEL description="Gitea Actions job image with Ansible, Molecule, Node and Docker CLI"

# Base tooling
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
      docker-cli \
    && update-ca-certificates

# Create Python virtualenv
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv "$VIRTUAL_ENV" \
    && "$VIRTUAL_ENV/bin/pip" install --no-cache-dir --upgrade pip setuptools wheel
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install Python requirements
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt \
    && pip check \
    && rm -f /tmp/requirements.txt

# Sanity checks
RUN node --version \
    && npm --version \
    && docker --version \
    && python --version \
    && ansible --version || true

# Entrypoint
COPY docker-entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 0755 /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]