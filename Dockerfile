# ---------- BUILD ----------
    FROM node:18 AS builder

    WORKDIR /app
    
    COPY package*.json ./
    RUN npm install
    
    COPY . .
    
    # webpack + node18
    ENV NODE_OPTIONS=--openssl-legacy-provider
    
    RUN npm run build
    
    
    # ---------- RUNTIME ----------
    FROM node:18-alpine
    
    WORKDIR /app
    
    COPY package*.json ./
    RUN npm install --production
    
    # копируем всё
    COPY --from=builder /app /app
    
    EXPOSE 3000
    
    CMD ["npm", "start"]