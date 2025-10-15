# Stage 1: Build the WAR file
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy project files and build
COPY . .
RUN mvn clean package -DskipTests

# Stage 2: Deploy to Tomcat 9 (Java 17)
FROM tomcat:9.0-jdk17

# Remove default ROOT app
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy the WAR from the build stage and rename to ROOT.war
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
