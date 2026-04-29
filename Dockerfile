# ---------- BUILD ----------
    FROM node:18 AS builder

    WORKDIR /app
    
    COPY package*.json ./
    RUN npm ci
    
    COPY . .
    RUN npm run build
    
    
    # ---------- RUNTIME ----------
    FROM node:18-alpine
    
    WORKDIR /app
    
    COPY package*.json ./
    RUN npm install --production
    
    # backend
    COPY --from=builder /app/src /app/src
    
    # фронт
    COPY --from=builder /app/dist /app/static
    
    EXPOSE 3000
    
    CMD ["npm", "start"]