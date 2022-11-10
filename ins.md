# Docker Container Security:

## Dockle Image Scanner
* Download docker using the command `VERSION=$(
 curl --silent "https://api.github.com/repos/goodwithtech/dockle/releases/latest" | \
 grep '"tag_name":' | \
 sed -E 's/.*"v([^"]+)".*/\1/' \
) && curl -L -o dockle.deb https://github.com/goodwithtech/dockle/releases/download/v${VERSION}/dockle_${VERSION}_Linux-64bit.deb`
* Install dockle `sudo dpkg -i dockle.deb && rm dockle.deb`
* Check for image dockle `sudo dockle image_name 1>dockle_webserver.txt`

---

## Trivy Vulnerability Scanner
* Get the package `wget https://github.com/aquasecurity/trivy/releases/download/v0.20.1/trivy_0.20.1_Linux-64bit.deb`
* Install using `sudo dpkg -i trivy_0.20.1_Linux-64bit.deb`
* Update DB by `trivy fs --exit-code 1 .`
* Run the scan by `trivy image image_name 1>trivy_webserver.txt`

---

## Hadolint Dockerfile Scan
* Install Hadolint by `sudo wget -O /bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.16.3/hadolint-Linux-x86_64`
* Change execution permission `sudo chmod +x /bin/hadolint`
* Run the scan by `hadolint Dockerfile_path`

## 