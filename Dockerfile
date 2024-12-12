FROM node:22.12-alpine3.20 AS base

ENV DIR=/app
WORKDIR $DIR

ARG "NPM_TOKEN"

FROM base AS dev

ENV NODE_ENV=development
ENV CI=true

RUN npm install -g pnpm@9.15.0

COPY package.json pnpm-lock.yaml ./

RUN echo "//registry.npmjs.org/:_authToken=$NPM_TOKEN" > ".npmrc" && \
  pnpm install --frozen-lockfile && \
  rm -f .npmrc

COPY tsconfig*.json .swcrc nest-cli.json ./
COPY src ./src

EXPOSE $PORT
CMD ["node", "--run", "start:dev"]

FROM base AS build

ENV CI=true

RUN apk update && apk add --no-cache dumb-init=1.2.5-r3 && npm install -g pnpm@9.15.0

COPY package.json pnpm-lock.yaml ./
RUN echo "//registry.npmjs.org/:_authToken=$NPM_TOKEN" > ".npmrc" && \
  pnpm install --frozen-lockfile && \
  rm -f .npmrc

COPY tsconfig*.json .swcrc nest-cli.json ./
COPY src ./src

RUN node --run build && \
  pnpm prune --prod

FROM base AS production

ENV NODE_ENV=production
ENV USER=node

COPY --from=build /usr/bin/dumb-init /usr/bin/dumb-init
COPY --from=build $DIR/package.json .
COPY --from=build $DIR/pnpm-lock.yaml .
COPY --from=build $DIR/node_modules node_modules
COPY --from=build $DIR/dist dist

USER $USER
EXPOSE $PORT
CMD ["dumb-init", "node", "dist/main.js"]