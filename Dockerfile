FROM eclipse-temurin:17-jdk as builder
COPY .  /shopzier
WORKDIR /shopzier
RUN mvn clean package


FROM eclipse-temurin:17-jdk-alpine as runtime
LABEL project="java" \
      author="vijay"
ARG USERNAME="john"
ARG WORKDIR="/apps"
ARG GROUP="john"
RUN addgroup -S ${GROUP} && adduser -S ${USER} -G ${GROUP}
WORKDIR ${WORKDIR}
COPY --from=builder --chown=${USERNAME}:${GROUP} **/target/*.jar /apps/shopzier-1.0-snapshot.jar
EXPOSE 8080
CMD [ "java","-jar","shopzier-1.0-snapshot.jar","--", "--host", "0.0.0.0" ]