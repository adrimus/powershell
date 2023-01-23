FROM ubuntu:latest
EXPOSE 22
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
RUN apt-get update && apt-get install -y \
        openssh-client \
        openssh-server \
        doas; \
    # Install pre-requisite packages.
    apt-get install -y wget apt-transport-https software-properties-common; \
    # Download the Microsoft repository GPG keys
    wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb; \
    # Register the Microsoft repository GPG keys
    dpkg -i packages-microsoft-prod.deb; \
    # Update the list of packages after we added packages.microsoft.com
    apt-get update; \
    # Install PowerShell
    apt-get install -y powershell
#Enable password authentication and add a PowerShell subsystem entry
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i '/# override default of no subsystems/a Subsystem\tpowershell\t/usr/bin/pwsh -sshs -nologo' /etc/ssh/sshd_config 
RUN adduser testuser;echo 'testuser:Test123' | chpasswd

ENTRYPOINT ["sh", "/docker-entrypoint.sh"]
