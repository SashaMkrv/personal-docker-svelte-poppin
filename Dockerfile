ARG NODE_VERSION=20.14.0

FROM node:${NODE_VERSION}-alpine as base

WORKDIR /usr/src/app

#########
FROM base as deps
COPY ./package*.json /usr/src/app/
RUN npm install

#########
FROM base as final

ENV NODE_ENV dev

## Would have been good if I kept the changes I made
## used adduser instead of useradd, because useradd was not found
## -u 1001 is the key of the user
## -s sets the user shell
## -D uhhh sets or makes the user home maybe?
RUN adduser -Ds /bin/sh -u 1001 app

COPY . .

RUN chown -R app /usr/src/app

USER app

COPY --from=deps /usr/src/app/node_modules ./node_modules

EXPOSE 5000
EXPOSE 5050
EXPOSE 35729

ENV HOST=0.0.0.0

## entry point is in the docker compose file instead.
# CMD npm run dev --host