# --- Build stage ---
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# --- Serve stage ---
FROM node:20-alpine
WORKDIR /app
COPY --from=build /app ./
ENV PORT=5173
EXPOSE 5173
CMD ["npm", "start"]
