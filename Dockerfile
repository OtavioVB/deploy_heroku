FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["DeployHeroku/DeployHeroku.csproj", "DeployHeroku/"]
RUN dotnet restore "DeployHeroku/DeployHeroku/DeployHeroku.csproj"
COPY . .
WORKDIR "/src/DeployHeroku"
RUN dotnet build "DeployHeroku/DeployHeroku.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DeployHeroku/DeployHeroku.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DeployHeroku.dll"]