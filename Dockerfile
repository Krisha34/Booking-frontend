# --- Build stage ---
FROM node:20-alpine AS build
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm ci

# Copy the rest of the app and build it
COPY . .
RUN npm run build

# --- Serve stage ---
FROM node:20-alpine
WORKDIR /app

# Install a lightweight static file server
RUN npm install -g serve

# Copy only the built files
COPY --from=build /app/dist ./dist

# Set the port for Azure
ENV PORT=5173
EXPOSE 5173

# Serve the built frontend
CMD ["serve", "-s", "dist", "-l", "5173"]
