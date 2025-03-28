#!/bin/bash

# Schedule the pihole -up command to run every day at 6 AM.

(crontab -l 2>/dev/null; echo "0 6 * * * pihole -up") | crontab -