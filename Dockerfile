FROM node:20-alpine As development

WORKDIR /usr/src/app

ARG DATABASE_URL
ARG PORT=3000
ARG TCP=3001
ENV DATABASE_URL=${DATABASE_URL}
ENV PORT=${PORT}
ENV TCP=${TCP}

COPY package.json ./
COPY package-lock.json ./
COPY tsconfig.json tsconfig.json
COPY nest-cli.json nest-cli.json

RUN npm i

COPY . .

RUN npm install -r --force

RUN npx prisma migrate dev
RUN npx prisma generate
RUN npx prisma db seed
RUN npm run build

EXPOSE ${PORT}
EXPOSE ${TCP}

FROM node:20-alpine as production

ARG NODE_ENV=production
ARG DATABASE_URL
ARG PORT=3000
ARG TCP=3001
ENV DATABASE_URL=${DATABASE_URL}
ENV PORT=${PORT}
ENV TCP=${TCP}

WORKDIR /usr/src/app

COPY package.json ./
COPY package-lock.json ./
COPY prisma ./prisma

RUN npm install --prod
RUN npx prisma generate

COPY --from=development /usr/src/app/dist ./dist

EXPOSE ${PORT}
EXPOSE ${TCP}

CMD ["npm", "run", "start:prod"]