#!/bin/bash

# set timezone
timedatectl set-timezone ${timezone}

# install needed packages
apt update -y && \
apt upgrade -y
apt install -y \
  jq \
  curl \
  qemu-guest-agent \
  wget \
  tree \
  nano \
  net-tools \
  unzip \
  traceroute \
  lsof \
  iotop \
  lshw \
  figlet

# Configure colored prompt for user ${user}
cat <<EOT >> /home/${user}/.bashrc

# Prompt color green:
GREEN='\[\e[01;32m\]'
BLUE='\[\e[01;34m\]'
WHITE='\[\e[01;00m\]'
PS1="\$GREEN[\u\$BLUE@\$GREEN\h\$BLUE \w\$GREEN]\$WHITE\$ "
EOT

# Configure colored prompt for user root
cat <<EOT >> /root/.bashrc

# Prompt color red:
GREEN='\[\e[01;32m\]'
BLUE='\[\e[01;34m\]'
WHITE='\[\e[01;00m\]'
RED='\[\e[01;31m\]'
PS1='\[\e[1;31m\]\u\[\e[1;33m\]@\[\e[1;36m\]\h \[\e[1;33m\]\w \[\e[1;34m\]\$ \[\e[0m\]'
EOT


# Configure colored man pages for user ${user}
cat <<EOT >> /home/${user}/.bashrc

# Colored manpages:
export LESS_TERMCAP_mb=\$(printf '\e[01;31m')    # enter blinking mode - red
export LESS_TERMCAP_md=\$(printf '\e[01;35m')    # enter double-bright mode - bold,magenta
export LESS_TERMCAP_me=\$(printf '\e[0m')        # turn off all appearance modes (mb, md, so, us)
export LESS_TERMCAP_se=\$(printf '\e[0m')        # leave standout mode
export LESS_TERMCAP_so=\$(printf '\e[01;33m')    # enter standout mode - yellow
export LESS_TERMCAP_ue=\$(printf '\e[0m')        # leave underline mode
export LESS_TERMCAP_us=\$(printf '\e[04;36m')    # enter underline mode - cyan
EOT

# Configure colored man pages for user root
cat <<EOT >> /root/.bashrc

# Colored manpages:
export LESS_TERMCAP_mb=\$(printf '\e[01;31m')    # enter blinking mode - red
export LESS_TERMCAP_md=\$(printf '\e[01;35m')    # enter double-bright mode - bold,magenta
export LESS_TERMCAP_me=\$(printf '\e[0m')        # turn off all appearance modes (mb, md, so, us)
export LESS_TERMCAP_se=\$(printf '\e[0m')        # leave standout mode
export LESS_TERMCAP_so=\$(printf '\e[01;33m')    # enter standout mode - yellow
export LESS_TERMCAP_ue=\$(printf '\e[0m')        # leave underline mode
export LESS_TERMCAP_us=\$(printf '\e[04;36m')    # enter underline mode - cyan
EOT

# Custom MOTD
echo 'figlet $HOSTNAME' >> /etc/profile

# Custom login screen
cat <<EOT >> /etc/issue
#####################################################################
#                                                                   #
#        Unauthorized access to this machine is prohibited!         #
#        Press <Ctrl-D> if you are not an authorized user!          #
#                                                                   #
#####################################################################


EOT

# reboot system when done
systemctl reboot
