# Linqiny training - Lab1 : CentOS 7 + Java + Tomcat

Automatisation de l'installation de Java 10 et d'Apache Tomcat 9 sur une VM CentOS 7.

## Architecture

```
Navigateur Windows -> localhost:8080 -> VirtualBox (NAT, redirection de port) -> CentOS 7 -> Tomcat 9.0.65 -> Java 10.0.2
```

| Composant | Version |
|---|---|
| Hyperviseur | Oracle VirtualBox |
| Système | CentOS 7 (Minimal) |
| Java | OpenJDK 10.0.2 |
| Serveur d'applications | Apache Tomcat 9.0.65 |

## Contenu du dépôt

- `config.conf` : URLs, chemins et port
- `install.sh` : script d'installation automatique

## Guide d'installation

1. Créer une VM CentOS 7 (2 Go de RAM, disque de 20 Go) et l'installer.
2. Activer le réseau NAT et ajouter la redirection de port TCP 8080 -> 8080.
3. Dans la VM, récupérer le dépôt et lancer le script :

```
sudo yum -y install git
git clone https://github.com/louayhmida14-code/linqiny-lab1.git
cd linqiny-lab1
bash install.sh
```

4. Ouvrir http://localhost:8080 dans le navigateur.

## Déploiement d'un exemple Java

```
sudo mkdir -p /opt/tomcat/webapps/hello
echo '<%= "Bonjour depuis Tomcat, Java " + System.getProperty("java.version") %>' | sudo tee /opt/tomcat/webapps/hello/index.jsp
```

Résultat visible sur http://localhost:8080/hello

## Remarque

CentOS 7 n'est plus maintenu : le script redirige les dépôts yum vers vault.centos.org.
