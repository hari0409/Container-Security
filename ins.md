# Docker Container Security:

## Clair Image Scanner:
* Create Directory `mkdir -p clair/docker-compose-data/clair-config`
* Pull compose files `wget https://raw.githubusercontent.com/jgsqware/clairctl/master/docker-compose.yml --directory-prefix=clair/docker-compose-data/`
* Donwload Config file `wget https://raw.github.com/jgsqware/clairctl/master/docker-compose-data/clair-config/config.yml --directory-prefix=clair/clair-config/`
* Move into the directory `cd clair/docker-compose-data`
* Run the container using the image `docker-compose up`
* Scan the image `docker-compose exec clairctl clairctl analyze -l image_name 1>clair_webserver.txt`

---

## Dockle Image Scanner
* Download docker using the command `curl --silent "https://api.github.com/repos/goodwithtech/dockle/releases/latest" | \ grep '"tag_name":' | \ sed -E 's/.*"v([^"]+)".*/\1/' \ ) && curl -L -o dockle.deb https://github.com/goodwithtech/dockle/releases/download/v${VERSION}/dockle_${VERSION}_Linux-64bit.deb`
* Install dockle `sudo dpkg -i dockle.deb && rm dockle.deb`
* Check for image dockle `sudo dockle image_name 1>dockle_webserver.txt`

---

## Trivy Vulnerability Scanner
* Get the package `wget https://github.com/aquasecurity/trivy/releases/download/v0.20.1/trivy_0.20.1_Linux-64bit.deb`
* Install using `sudo dpkg -i trivy_0.20.1_Linux-64bit.deb`
* Update DB by `trivy fs --exit-code 1 .`
* Run the scan by `trivy image image_name 1>trivy_webserver.txt`

---

