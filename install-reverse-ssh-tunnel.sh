#!/usr/bin/env sh

set -euo pipefail

# Install gcloud cli
if ! command -v gcloud &> /dev/null
then
    echo "gcloud not found. Installing..."
    curl -Lo google-cloud-sdk.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-331.0.0-darwin-x86_64.tar.gz
    tar xvzf google-cloud-sdk.tar.gz
    ./google-cloud-sdk/install.sh
else
    echo "Found gcloud."
fi

gcloud auth login
gcloud config set project pubsubplayground-11081991

# Creating SSH keys
echo "Creating SSH keys"
ssh-keygen -t RSA -f operation_nigeria -C operation-nigeria@alexdrawbond.com -N ""
ssh-add -K operation_nigeria
echo "SSH keys created"
echo "Adding SSH keys to Compute Engine"
export op_nigeria_key=$(cat operation_nigeria.pub)
echo "operation-nigeria:$op_nigeria_key operation-nigeria@alexdrawbond.com" > compute-keys
gcloud compute instances add-metadata reverse-ssh --metadata-from-file ssh-keys=compute-keys

# Add launchd daemon
sed -i.bu "s~SCRIPT_LOCATION~$(pwd)~g" com.alexdrawbond.run-reverse-ssh-tunnel.plist
sudo cp com.alexdrawbond.run-reverse-ssh-tunnel.plist /Library/LaunchDaemons/
launchctl load /Library/LaunchDaemons/com.alexdrawbond.run-reverse-ssh-tunnel.plist
echo "Reverse SSH tunnel daemon installed" 

