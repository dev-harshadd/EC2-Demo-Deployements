# ===============================
# Stage 1 — Build JAR with Maven
# ===============================
FROM maven:3.8.8-openjdk-17 AS builder

# Set working directory
WORKDIR /app

# Copy Maven descriptor first (to cache dependencies)
COPY pom.xml .

# Pre-download dependencies (helps speed up builds)
RUN mvn dependency:go-offline

# Copy the rest of the source code
COPY src ./src

# Build the application (skip tests for faster CI)
RUN mvn clean package -DskipTests

# ===============================
# Stage 2 — Run Spring Boot JAR
# ===============================
FROM openjdk:17-jdk-slim

WORKDIR /app

# Copy only the built JAR from previous stage
COPY --from=builder /app/target/MicroService-0.0.1-SNAPSHOT.jar app.jar

# Expose application port
EXPOSE 8082

# Start the application
ENTRYPOINT ["java", "-jar", "app.jar"]

