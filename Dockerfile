# ---------- BUILD ----------
    FROM node:18 AS builder

    WORKDIR /app
    
    COPY package*.json ./
    RUN npm ci
    
    COPY . .
    
    # билд + вывод структуры
    RUN npm run build && echo "==== BUILD OUTPUT ====" && ls -la && ls -laR
    
    
    # ---------- RUNTIME ----------
    FROM node:18-alpine
    
    WORKDIR /app
    
    COPY package*.json ./
    RUN npm install --omit=dev
    
    # backend
    COPY --from=builder /app/src /app/src
    
    # универсально копируем 
    COPY --from=builder /app /app
    
    EXPOSE 3000
    
    CMD ["npm", "start"]