# Use the official .NET SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the .csproj file and restore the project dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the application code to the container
COPY . ./

# Build the application
RUN dotnet publish -c Release -o out

# Use the official .NET runtime image to run the application
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

# Set the working directory for the runtime
WORKDIR /app

# Copy the published files from the build stage
COPY --from=build /app/out .

# Expose port 80
EXPOSE 80

# Set the entry point for the container to run the application
ENTRYPOINT ["dotnet", "weather_app.dll"]
