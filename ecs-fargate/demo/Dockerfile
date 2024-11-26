# Stage 1: Build the application
FROM maven:3.9.9-amazoncorretto-17-alpine AS build

WORKDIR /app

# Copy pom.xml and install dependencies (to leverage Docker cache)
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline

# Copy the source code and build the application
COPY src /app/src
RUN mvn clean package -DskipTests

# Stage 2: Create the runtime image
FROM amazoncorretto:17-alpine AS runtime

WORKDIR /app

# Copy only the JAR file from the build stage
COPY --from=build /app/target/demo-0.0.1-SNAPSHOT.jar /app/demo.jar

# Expose the application port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "/app/demo.jar"]
