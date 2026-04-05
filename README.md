# Dumpster-Archiver

This container image collects dumpster diving spots from https://www.dumpstermap.org/page/about and uploads them to https://huggingface.co/datasets/Hitchwiki/dumpster-diving-spots.

# Deployment

Runs monthly via anacron on @tillwenke's machine.

## Setup

1. Create a `.env` file with `HF_TOKEN` (Hugging Face write token)

2. Ensure Docker is installed and the user running anacron can access it.

3. Add to `/etc/anacrontab`:
   ```bash
   sudo sh -c 'echo "@monthly 15    dumpster-archiver    /home/till/recurring_tasks/dumpster-archiver/run.sh" >> /etc/anacrontab'
   ```

Logs are written to `run.log` in this directory.
