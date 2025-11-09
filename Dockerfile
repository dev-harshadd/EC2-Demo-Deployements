# ===============================
# Stage 1 — Build JAR with Maven
# ===============================
FROM maven:3.8.8-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy the pom first to leverage caching
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code and build
COPY src ./src
RUN mvn clean package -DskipTests

# ===============================
# Stage 2 — Run Spring Boot JAR
# ===============================
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app

# Copy only the final JAR from builder stage
COPY --from=builder /app/target/MicroService-0.0.1-SNAPSHOT.jar app.jar

# Expose your app port
EXPOSE 8082

# Start the app
ENTRYPOINT ["java", "-jar", "app.jar"]
