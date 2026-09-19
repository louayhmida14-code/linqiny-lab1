#!/bin/bash
set -e
source "$(dirname "$0")/config.conf"

# 1. Depots yum : CentOS 7 est en fin de vie, on pointe vers le vault
sudo sed -i -e '/mirrorlist/d' -e 's/^#baseurl/baseurl/' -e 's/mirror.centos.org/vault.centos.org/' /etc/yum.repos.d/CentOS-*.repo
sudo yum clean all

# 2. Java 10
cd /tmp
if [ ! -x "$JAVA_HOME/bin/java" ]; then
  curl -LO "$JAVA_URL"
  sudo mkdir -p "$JAVA_HOME"
  sudo tar xzf "$(basename "$JAVA_URL")" -C "$JAVA_HOME" --strip-components=1
fi

# 3. Tomcat 9
if [ ! -x "$TOMCAT_HOME/bin/startup.sh" ]; then
  curl -LO "$TOMCAT_URL"
  sudo mkdir -p "$TOMCAT_HOME"
  sudo tar xzf "$(basename "$TOMCAT_URL")" -C "$TOMCAT_HOME" --strip-components=1
fi

# 4. Tomcat utilise Java 10
echo "export JAVA_HOME=$JAVA_HOME" | sudo tee "$TOMCAT_HOME/bin/setenv.sh" > /dev/null
sudo chmod +x "$TOMCAT_HOME/bin/setenv.sh"

# 5. Pare-feu puis demarrage
sudo firewall-cmd --permanent --add-port=${PORT}/tcp || true
sudo firewall-cmd --reload || true
sudo "$TOMCAT_HOME/bin/shutdown.sh" 2>/dev/null || true
sleep 3
sudo "$TOMCAT_HOME/bin/startup.sh"
echo "Termine : http://localhost:${PORT}"
