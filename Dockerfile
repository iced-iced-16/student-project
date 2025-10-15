# Use Maven to build the WAR file
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Use Jetty to run the WAR
FROM eclipse-temurin:17-jdk
WORKDIR /var/lib/jetty/webapps
RUN apt-get update && apt-get install -y jetty9
COPY --from=build /app/target/*.war /var/lib/jetty/webapps/root.war
EXPOSE 8080
CMD ["java", "-jar", "/usr/share/jetty9/start.jar"]
