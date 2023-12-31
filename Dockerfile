FROM ubuntu:22.04 as base

# Update the system
RUN apt-get update -y

# Install Python and pip
RUN apt-get install -y python3 python3-pip

# Make Python3 as the default Python
RUN ln -s /usr/bin/python3 /usr/bin/python

# Make pip3 as the default pip
RUN ln -s /usr/bin/pip3 /usr/bin/pip

# Check Python and pip version
RUN python --version
RUN pip --version

RUN python -m venv /opt/venv

# 2 stage: install deps using mounted cache
FROM base AS dependencies
COPY requirements.txt .
RUN --mount=type=cache,target=/root/.cache/pip,sharing=locked \
    /opt/venv/bin/pip install -r requirements.txt

# Etapa final: copiar el código y usar el virtualenv
FROM base AS final
COPY --from=dependencies /opt/venv/ /opt/venv/
