# Multi-stage build for Angular application
# Stage 1: Build the Angular app
FROM node:20-alpine AS build

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies (including dev dependencies for build)
RUN npm ci

# Copy source code
COPY . .

# Build the Angular app for production
RUN npm run build

# Stage 2: Serve the app with Nginx
FROM nginx:alpine

# Copy the built app from the previous stage
COPY --from=build /app/dist/digihelp/ /usr/share/nginx/html/

# Remove default nginx config and copy custom one
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 81
EXPOSE 81

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]