# ---------- BUILD STAGE ----------
FROM node:18 AS builder

WORKDIR /app

# 1. зависимости (кэшируемый слой)
COPY package*.json ./
RUN npm ci

# 2. код
COPY . .

# 3. билд фронта
RUN npm run build


# ---------- RUNTIME STAGE ----------
FROM node:18-alpine

WORKDIR /app

# копируем ВСЁ уже готовое из builder
COPY --from=builder /app /app

EXPOSE 3000

CMD ["npm", "start"]