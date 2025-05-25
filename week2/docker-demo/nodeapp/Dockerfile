# stage 1: builder
FROM node:18-alipne as builder
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
COPY ..
RUN yarn run build

# stage 2: production
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_nodules ./node_modules
ENV MODE_ENV=production
EXPOSE 3000
CMD ["node","dist/index.js"]
