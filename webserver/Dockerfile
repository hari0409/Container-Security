FROM node:19-buster
WORKDIR /app
COPY package.json ./
RUN npm i 
COPY . .
EXPOSE 3000 
CMD ["npm","run","dev"]

# Build the image using the command sudo docker build -t webserver:1.0 .
# Start the image using the command sudo docker run -p 3000:3000 -d webserver:1.0
# Start a shell in it using the command sudo docker exec -it container_id
# Get the running containers using the command sudo docker ps
# Get all the existing images using the command sudo docker images
# Run bash script using cmd sudo bash secure.bash 