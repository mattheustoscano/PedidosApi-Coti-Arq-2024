#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER app
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["PedidosApi.Services/PedidosApi.Services.csproj", "PedidosApi.Services/"]
COPY ["PedidosApi.Application/PedidosApi.Application.csproj", "PedidosApi.Application/"]
COPY ["PedidosApi.Domain/PedidosApi.Domain.csproj", "PedidosApi.Domain/"]
COPY ["PedidosApi.InfraStructure/PedidosApi.Infra.Data.csproj", "PedidosApi.InfraStructure/"]
COPY ["PedidosApi.InfraStructure/PedidosApi.Infra.Messages.csproj", "PedidosApi.InfraStructure/"]
RUN dotnet restore "./PedidosApi.Services/./PedidosApi.Services.csproj"
COPY . .
WORKDIR "/src/PedidosApi.Services"
RUN dotnet build "./PedidosApi.Services.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./PedidosApi.Services.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "PedidosApi.Services.dll"]