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

# Add TypeScript shims for Vue (if not present in repo)
# This ensures TS can handle .vue files
RUN echo "declare module '*.vue' { import { DefineComponent } from 'vue'; const component: DefineComponent<{}, {}, any>; export default component }" > src/shims-vue.d.ts

# Optional: install vue-tsc for proper type checking
RUN npm install -D vue-tsc

# Type-check and build the production app
RUN npx vue-tsc --noEmit && npm run build

# Stage 2: Production Nginx
FROM nginx:stable-alpine

# Copy build output from build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80
