FROM node:24-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm i

COPY . .
RUN npm run build

FROM node:20-alpine AS release

WORKDIR /app

COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/package*.json ./

ENV NODE_ENV=production
RUN npm i --ignore-scripts --omit=dev

ENV PORT=3000
EXPOSE 3000
CMD ["sh", "-c", "node dist/index.js --org-mode --http 0.0.0.0:${PORT}"]
