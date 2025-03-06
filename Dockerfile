# Use a base image with Java (OpenJDK 17 in this case)
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the Spring Boot JAR file to the container
COPY target/my-app-1.0-SNAPSHOT.jar myapp.jar

# Expose the port on which the Spring Boot app will run (default is 8080)
EXPOSE 8080

# Command to run the Spring Boot application
CMD ["java", "-jar", "myapp.jar"]
