FROM node:alpine
RUN apk add --no-cache bash wget unzip

ENV APP_DIR=/usr/src/app
ENV SAPUI5_VERSION=1.69.0
ENV SAPUI5_SDK_ZIP=sapui5-sdk-${SAPUI5_VERSION}.zip
ENV SAPUI5_RT_ZIP=sapui5-rt-${SAPUI5_VERSION}.zip
WORKDIR $APP_DIR
COPY app/ .

# Install UI5 tooling
RUN npm config set @sap:registry "https://npm.sap.com" -g
RUN npm install --global @ui5/cli

# SAP UI5 downloading
RUN wget -nv --output-document=/tmp/${SAPUI5_SDK_ZIP} \
    --no-cookies --header "Cookie: eula_3_1_agreed=tools.hana.ondemand.com/developer-license-3_1.txt" \
    https://tools.hana.ondemand.com/additional/${SAPUI5_SDK_ZIP} \
    && unzip -q /tmp/${SAPUI5_SDK_ZIP} \
    && rm /tmp/${SAPUI5_SDK_ZIP}

# Exposing port 8080
EXPOSE 8080

# docker-entrypoint
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]