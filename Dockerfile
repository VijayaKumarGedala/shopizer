FROM eclipse-temurin:17-jdk as builder
WORKDIR /shopzier
COPY . .
RUN mvn clean package

# Stage 2: Create a runtime image
FROM eclipse-temurin:17-jdk-alpine as runtime
LABEL project="java" \
      author="vijay"
ARG USERNAME="john"
ARG GROUP="john"
RUN addgroup -S ${GROUP} && adduser -S ${USERNAME} -G ${GROUP}
ARG WORKDIR="/apps"
WORKDIR ${WORKDIR}
COPY --from=builder --chown=${USERNAME}:${GROUP} /shopzier/target/*.jar /apps/shopzier-1.0-snapshot.jar
EXPOSE 8080
USER ${USERNAME}
CMD ["java", "-jar", "shopzier-1.0-snapshot.jar", "--", "--host", "0.0.0.0"]
