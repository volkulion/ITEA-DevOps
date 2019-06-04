FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY ["WebDockkerMonitoring.csproj", ""]
RUN dotnet restore "WebDockkerMonitoring.csproj"
COPY . .

FROM build AS publish
RUN dotnet publish "WebDockkerMonitoring.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "WebDockkerMonitoring.dll"]
