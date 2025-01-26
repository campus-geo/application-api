# Base image for running the application
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 8080

# Build the application
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG TARGETPLATFORM
ARG BUILDPLATFORM
WORKDIR /src
COPY ["ApplicationApi/ApplicationApi.csproj", "ApplicationApi/"]
RUN dotnet restore "./ApplicationApi/ApplicationApi.csproj"
COPY . .
WORKDIR "/src/ApplicationApi"
RUN dotnet build "./ApplicationApi.csproj" -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "./ApplicationApi.csproj" -c Release -o /app/publish

# Final stage: run the application
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ApplicationApi.dll"]
