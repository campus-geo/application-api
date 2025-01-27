# Grab the X_VERSION build argument
ARG X_VERSION=unknown-development

# Base image for running the application
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 8080

# Build the application
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG TARGETPLATFORM
ARG BUILDPLATFORM

# Retrieve the X_VERSION arg
ARG X_VERSION

WORKDIR /src
COPY ["ApplicationApi/ApplicationApi.csproj", "ApplicationApi/"]
RUN dotnet restore "./ApplicationApi/ApplicationApi.csproj"
COPY . .
WORKDIR "/src/ApplicationApi"

# Replace the const string X_VERSION with the build argument
RUN sed -i "s/public const string X_VERSION = \"unknown-development\";/public const string X_VERSION = \"$X_VERSION\";/g" Program.cs

RUN dotnet build "./ApplicationApi.csproj" -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "./ApplicationApi.csproj" -c Release -o /app/publish

# Final stage: run the application
FROM base AS final

# Retrieve the X_VERSION arg
ARG X_VERSION

# Set the X_VERSION runtime environment variable
ENV X_VERSION=$X_VERSION

WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ApplicationApi.dll"]
