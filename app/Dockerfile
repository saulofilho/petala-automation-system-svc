# Use Node.js official image
FROM node:18

# Set the working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY /package.json ./
RUN yarn install

# Copy the rest of the application code
COPY . .

# Build the app
RUN yarn build

# Expose port 3001
EXPOSE 3000

# Start the app
CMD ["yarn", "start"]
