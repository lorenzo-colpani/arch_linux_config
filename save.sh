#!/bin/bash

# The ultimate script using a centralized list for maximum organization.

# This line ensures the script always runs from its own directory
cd "$(dirname "$0")"

# --- LISTS OF WHAT TO SAVE ---
# Just edit these two lists to control what gets backed up.

# 1. Single files located in your home directory
home_files=(
    ~/.zshrc
    ~/.gitconfig
    ~/.gitignore
    ~/pkglist.txt
)

# 2. Directory names located inside ~/.config/
config_dirs=(
    hypr
    waybar
    kitty
    wlogout
    clipse
)
# --- END OF LISTS ---


# --- Step 1: Update Backups & Lists ---
echo ">>> Updating local backup files..."
sudo -v # Ask for password upfront
mkdir -p etc-backups
sudo cp /etc/default/grub ./etc-backups/grub
sudo cp /etc/mkinitcpio.conf ./etc-backups/mkinitcpio.conf
pacman -Qeq > ~/pkglist.txt
echo "✅ Backups updated."


# --- Step 2: Copy Files from Lists ---
echo ">>> Copying files from your lists..."

# Copy single files from the home directory
for file in "${home_files[@]}"; do
    cp "$file" .
done

# Ensure the .config directory exists before copying into it
mkdir -p .config

# Copy directories from the .config folder
for dir in "${config_dirs[@]}"; do
    rsync -a --delete ~/.config/"$dir"/ .config/"$dir"/
done
echo "✅ Files copied."

one
echo "✅ Files copied."


# --- Step 3: Git Commands ---
COMMIT_MSG="Automated update: $(date +"%Y-%m-%d %H:%M:%S")"
echo ">>> Staging, committing, and pushing..."
git add .
git commit -m "$COMMIT_MSG"
git push --set-upstream origin master

echo "✅ All done!"
