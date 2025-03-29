# Use official Node.js image as base image
FROM node:16

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json first
# to install dependencies (leverage Docker cache)
COPY package*.json ./

# Install the dependencies defined in package.json
RUN npm install

# Copy the rest of the application files into the container
COPY . .

# Expose the port the app will run on
EXPOSE 3001

# Command to run the app when the container starts
CMD ["node", "index.js"]
