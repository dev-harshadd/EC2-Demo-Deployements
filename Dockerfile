# Base image
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy the JAR file into container
COPY target/MicroService-0.0.1-SNAPSHOT.jar app.jar

# Expose the port your app runs on
EXPOSE 8082

# Run the JAR file
ENTRYPOINT ["java", "-jar", "app.jar"]
