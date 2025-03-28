#!/bin/bash

# Script to run apt update && apt upgrade and reboot at 4 AM daily.

# Set the time for the task to run (4 AM)
TARGET_TIME="04:00"

# Log file for recording actions
LOG_FILE="/var/log/apt_upgrade_reboot.log"

# Function to log messages
log_message() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Function to perform apt update and upgrade
perform_apt_update_upgrade() {
  log_message "Starting apt update and upgrade process."

  # Run apt update
  if ! apt update &>> "$LOG_FILE"; then
    log_message "Error: apt update failed."
    exit 1
  fi

  # Run apt upgrade -y (automatically answer yes to prompts)
  if ! apt upgrade -y &>> "$LOG_FILE"; then
    log_message "Error: apt upgrade failed."
    exit 1
  fi
  log_message "Apt update and upgrade completed successfully."
}

# Function to check if a reboot is needed
check_reboot_needed() {
  if [ -f /var/run/reboot-required ]; then
    log_message "Reboot required."
    return 0
  else
    log_message "Reboot not required."
    return 1
  fi
}

# Function to reboot the system
reboot_system() {
  log_message "Rebooting system."
  if ! reboot &>> "$LOG_FILE"; then
    log_message "Error: Reboot command failed."
    exit 1
  fi
}

# Main script logic
log_message "Script started."

# Check if it's the target time
current_time=$(date '+%H:%M')
if [ "$current_time" == "$TARGET_TIME" ]; then
  log_message "Target time reached ($TARGET_TIME). Proceeding with apt update, upgrade, and reboot check."
  
  perform_apt_update_upgrade
  
  if check_reboot_needed; then
    reboot_system
  fi
else
  log_message "Not the target time. Exiting. Current time: $current_time"
fi

log_message "Script finished."
exit 0
