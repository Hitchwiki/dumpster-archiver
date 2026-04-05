# Dumpster-Archiver

Scrapes dumpster diving spots from dumpstermap.org and uploads them as a Hugging Face dataset.

## How it runs

- `run.sh` builds and runs the Docker container locally
- Scheduled monthly via anacron (`/etc/anacrontab`)
- Container needs `HF_TOKEN` in `.env` for Hugging Face uploads

## Structure

- `image/` — Docker image (Dockerfile, run.py, requirements.txt)
- `run.sh` — entry point called by anacron
