
# Use a base image with Java (OpenJDK 17 in this case)
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the Spring Boot JAR file to the container
# Ensure that the JAR file is named `myapp.jar` (or the correct name of your built JAR)
COPY target/myapp.jar myapp.jar

# Expose the port on which the Spring Boot app will run (default is 8080)
EXPOSE 8080

# Define environment variables if needed (e.g., for database access or other configurations)
# ENV MY_ENV_VAR=value

# Command to run the Spring Boot application
CMD ["java", "-jar", "myapp.jar"]
