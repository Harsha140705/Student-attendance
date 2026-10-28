# Minimal Lightweight Runtime Image (Eclipse Temurin 21 JRE Alpine)
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Add non-root application user for container security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

COPY target/attendance-backend-1.0.0.jar app.jar

EXPOSE 8080

ENV SPRING_PROFILES_ACTIVE=prod
ENV SERVER_PORT=8080

ENTRYPOINT ["java", "-XX:+UseG1GC", "-XX:MaxRAMPercentage=75.0", "-jar", "app.jar"]
