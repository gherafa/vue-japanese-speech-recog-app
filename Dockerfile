# Stage 1: Build & Test
FROM node:18 AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all source code
COPY . .

# Run tests
RUN npm test

# Build the production app
RUN npm run build

# Stage 2: Production Nginx
FROM nginx:stable-alpine

# Copy build output from build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80
