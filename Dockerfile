# Build stage

FROM node:18

ENV NODE_OPTIONS=--openssl-legacy-provider

# install node packages - cache for faster future builds
WORKDIR /src/nav-app
COPY nav-app/package*.json nav-app/patch-webpack.js .
# install packages and build 
RUN npm install --unsafe-perm --legacy-peer-deps

# NOTE on legacy-peer-deps:
# The --legacy-peer-deps flags is included to bypass the dependency peer resolution conflict that arises between Angular
# and @angular-devkit/build-angular@0.1100.7, the latter of which has peerDependency: karma: '~5.1.0'. However,
# upgrading karma to 5.1.0 cascades into a litany of other dependency conflicts, which would ultimately require us to
# upgrade from Angular v11 to v12. Therefore, legacy-peer-deps will be allowed until a major framework upgrade can occur

# give user permissions
RUN chown -R node:node ./

# copy over needed files
USER node
COPY nav-app/ ./

WORKDIR /src
COPY layers/*.md ./layers/

COPY *.md ./

WORKDIR /src/nav-app
EXPOSE 4200

CMD npm start
