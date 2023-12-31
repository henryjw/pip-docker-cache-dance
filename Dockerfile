FROM python:3.8.17-slim-bullseye AS base

RUN python -m venv /opt/venv

# 2 stage: install deps using mounted cache
COPY requirements.txt .
RUN --mount=type=cache,target=/root/.cache/pip,sharing=locked \
    /opt/venv/bin/pip install -r requirements.txt \
    && echo "pip cache size: $(du -sh /root/.cache/pip)"
