# ---------- BUILD ----------
    FROM node:18 AS builder

    WORKDIR /app
    
    COPY package*.json ./
    RUN npm install
    
    COPY . .
    
    RUN npm run build || echo "no build step"
    
    
    # ---------- RUNTIME ----------
    FROM node:18-alpine
    
    WORKDIR /app
    
    COPY package*.json ./
    RUN npm install --production
    
    COPY --from=builder /app /app
    
    EXPOSE 3000
    
    CMD ["npm", "start"]