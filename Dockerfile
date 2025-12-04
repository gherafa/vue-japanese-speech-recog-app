# Stage 1: Build & Test
FROM node:20 AS build

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# Add TS shim
RUN echo "declare module '*.vue' { import { DefineComponent } from 'vue'; const component: DefineComponent<{}, {}, any>; export default component }" > src/shims-vue.d.ts

# Type check
RUN npm install -D vue-tsc
RUN npx vue-tsc --noEmit

# Build production
RUN npm run build

# Stage 2: Nginx
FROM nginx:stable-alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
