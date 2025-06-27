# -------- Stage 1: Build the application --------
FROM openjdk:8-jdk-alpine as builder

# Install required tools (like bash and curl if needed)
RUN apk add --no-cache bash curl

# Create app directory
RUN mkdir -p /app/source

# Copy project files into the container
COPY . /app/source

# Set working directory
WORKDIR /app/source

# Make the Maven wrapper executable
RUN chmod +x mvnw

# Build the application
RUN ./mvnw clean package -DskipTests

# -------- Stage 2: Create runtime image --------
FROM openjdk:8-jdk-alpine

# Create app directory
RUN mkdir -p /app

# Copy the jar from the builder stage
COPY --from=builder /app/source/target/*.jar /app/app.jar

# Expose the application port
EXPOSE 8080

# Run the app
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app/app.jar"]

