FROM node:19-buster
WORKDIR /agent
RUN apt-get update && apt-get install -y lsb-release && apt-get clean all 
RUN curl -so wazuh-agent-4.3.9.deb https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.3.9-1_amd64.deb && WAZUH_MANAGER='localhost' WAZUH_AGENT_GROUP='default' dpkg -i ./wazuh-agent-4.3.9.deb
WORKDIR /app
COPY package.json ./
RUN npm i 
COPY . .
EXPOSE 3000 
CMD ["/bin/bash", "-c", "npm run dev;update-rc.d wazuh-agent defaults 95 10;service wazuh-agent start"]

# Build the image using the command sudo docker build -t webserver:1.0 .
# Start the image using the command sudo docker run -p 3000:3000 -d webserver:1.0
# Start a shell in it using the command sudo docker exec -it container_id
# Get the running containers using the command sudo docker ps
# Get all the existing images using the command sudo docker images