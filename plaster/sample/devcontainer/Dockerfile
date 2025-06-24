FROM mcr.microsoft.com/powershell:lts-debian-12

# Install git for version control
RUN apt-get update && \
    apt-get install -y git

# Set PowerShell as the default shell
SHELL ["pwsh", "-Command"]

# Create the PowerShell profile directory if it doesn't exist
RUN New-Item -ItemType Directory -Path $PROFILE -Force

WORKDIR /workspace