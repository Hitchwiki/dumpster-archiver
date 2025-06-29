FROM python:3.12-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    software-properties-common \
    git \
    && rm -rf /var/lib/apt/lists/*

# Create a writable cache directory
RUN mkdir -p /app/hf_cache && chmod -R 777 /app/hf_cache
ENV HF_HOME=/app/hf_cache

# Set working directory and copy files
WORKDIR /app
COPY requirements.txt ./
COPY run.py ./

RUN pip3 install -r requirements.txt

ENTRYPOINT ["python3", "run.py"]