FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY app/*.csproj ./app/
RUN dotnet restore

# copy everything else and build app
COPY app/. ./app/
WORKDIR /source/app
RUN dotnet publish -c debug -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "s2i-dotnetcore-ex.dll"]
