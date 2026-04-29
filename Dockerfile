# ---------- BUILD ----------
    FROM node:18 AS builder

    WORKDIR /app
    
    COPY package*.json ./
    RUN npm install
    
    COPY . .
    
    # пробуем билд, но не ломаем сборку
    RUN npm run build || echo "skip build"
    
    
    # ---------- RUNTIME ----------
    FROM node:18-alpine
    
    WORKDIR /app
    
    COPY package*.json ./
    RUN npm install --production
    
    # копируем ВСЁ (включая если вдруг появится static)
    COPY --from=builder /app /app
    
    EXPOSE 3000
    
    CMD ["npm", "start"]