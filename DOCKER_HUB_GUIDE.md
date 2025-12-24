# Guide til at bygge og pushe til Docker Hub

## Forudsætninger

1. **Docker Desktop** skal være installeret og køre
2. **Node.js og npm** skal være installeret (til at bygge frontend)
3. **Go** skal være installeret (til at bygge backend)
4. **Docker Hub konto** - hvis du ikke har en, opret én på https://hub.docker.com

## Trin 1: Log ind på Docker Hub

Åbn en terminal og log ind:

```bash
docker login
```

Indtast dit Docker Hub brugernavn og password.

## Trin 2: Brug build scriptet

### Windows (PowerShell)

```powershell
./build-and-push.ps1 -DockerUsername "dit-dockerhub-brugernavn" -ImageName "glkvm-cloud" -Tag "latest"
```

Eller med en specifik version tag:

```powershell
./build-and-push.ps1 -DockerUsername "dit-dockerhub-brugernavn" -ImageName "glkvm-cloud" -Tag "v1.4.0-custom"
```

### Linux/Mac (Bash)

```bash
chmod +x build-and-push.sh
DOCKER_USERNAME="dit-dockerhub-brugernavn" TAG="latest" ./build-and-push.sh
```

## Trin 3: Manuel metode (hvis du foretrækker det)

Hvis du vil gøre det manuelt, følg disse trin:

### 3.1: Byg frontend

```bash
cd ui
npm install
npm run build
cd ..
```

### 3.2: Byg Go binary

```bash
# Windows
$env:CGO_ENABLED = "0"
$env:GOOS = "linux"
$env:GOARCH = "amd64"
go build -ldflags "-s -w" -o rttys

# Linux/Mac
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags "-s -w" -o rttys
```

### 3.3: Byg Docker image

```bash
docker build -t dit-dockerhub-brugernavn/glkvm-cloud:latest .
```

### 3.4: Push til Docker Hub

```bash
docker push dit-dockerhub-brugernavn/glkvm-cloud:latest
```

## Trin 4: Brug dit custom image

Efter du har pushet dit image, kan du opdatere `docker-compose/.env` filen:

```env
GLKVM_IMAGE=dit-dockerhub-brugernavn/glkvm-cloud:latest
```

Eller kør direkte:

```bash
docker pull dit-dockerhub-brugernavn/glkvm-cloud:latest
docker run -p 443:443 -p 10443:10443 -p 5912:5912 dit-dockerhub-brugernavn/glkvm-cloud:latest
```

## Multi-platform builds (valgfrit)

Hvis du vil bygge til flere platforme (AMD64, ARM64, etc.):

```bash
# Opret buildx builder
docker buildx create --name mybuilder --use
docker buildx inspect --bootstrap

# Byg og push til flere platforme
docker buildx build --platform linux/amd64,linux/arm64 \
  -t dit-dockerhub-brugernavn/glkvm-cloud:latest \
  --push .
```

## Versioning

Det er god praksis at bruge version tags:

```bash
# Tag med version nummer
docker build -t dit-dockerhub-brugernavn/glkvm-cloud:v1.4.0 .
docker build -t dit-dockerhub-brugernavn/glkvm-cloud:latest .

# Push begge tags
docker push dit-dockerhub-brugernavn/glkvm-cloud:v1.4.0
docker push dit-dockerhub-brugernavn/glkvm-cloud:latest
```

## Automatisk build med GitHub Actions (valgfrit)

Du kan også sætte GitHub Actions op til at bygge automatisk. Jeg kan hjælpe med det hvis du ønsker det.

## Bemærkninger

- **GOOS=linux** er vigtigt fordi Docker containeren kører Linux, selv på Windows/Mac
- **CGO_ENABLED=0** sikrer at binæren er statisk kompileret
- Dit custom image vil indeholde din ændring til `buildRedirectHost` funktionen
- Husk at holde dit image opdateret når du laver ændringer
