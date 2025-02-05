FROM maven:3.9.9-eclipse-temurin-17 AS builder 
WORKDIR /app
COPY . .
RUN mvn package -DskipTests


FROM eclipse-temurin:17-jdk-alpine AS runtime
LABEL project="java" \
      author="vijay"
ARG USERNAME="john"
ARG GROUP="john"
RUN addgroup -S ${GROUP} && adduser -S ${USERNAME} -G ${GROUP}
WORKDIR /apps
COPY --from=builder /app/target/*.jar /apps/shopzier-1.0-snapshot.jar
RUN chown ${USERNAME}:${GROUP} /apps/shopzier-1.0-snapshot.jar
EXPOSE 8080
USER ${USERNAME}
CMD ["java", "-jar", "shopzier-1.0-snapshot.jar", "--host", "0.0.0.0"]
