
FROM openjdk:17-jdk-alpine
WORKDIR /app
COPY target/my-app-1.0-SNAPSHOT.jar myapp.jar
CMD ["java", "-jar", "myapp.jar"]
