FROM node:20-alpine As development

WORKDIR /usr/src/app

ARG DATABASE_URL
ARG PORT=3000
ENV DATABASE_URL=${DATABASE_URL}
ENV PORT=${PORT}

COPY package.json ./
COPY package-lock.json ./
COPY tsconfig.json tsconfig.json
COPY nest-cli.json nest-cli.json

RUN npm i

COPY . .

RUN npm install -r --force

RUN npx prisma migrate dev
RUN npx prisma generate
RUN npm run build

FROM node:20-alpine as production

ARG NODE_ENV=production
ARG DATABASE_URL
ARG PORT=3000
ENV DATABASE_URL=${DATABASE_URL}
ENV PORT=${PORT}

WORKDIR /usr/src/app

COPY package.json ./
COPY package-lock.json ./
COPY prisma ./prisma

RUN npm install --prod
RUN npx prisma generate

COPY --from=development /usr/src/app/dist ./dist

EXPOSE 3000

CMD ["npm", "run", "start:prod"]