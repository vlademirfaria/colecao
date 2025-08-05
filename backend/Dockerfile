# backend/Dockerfile
# Este arquivo define como construir a imagem Docker para nossa aplicação Go.

# Estágio 1: Build
FROM golang:1.22-alpine AS builder

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# ATUALIZADO: Copia os arquivos de dependências especificando a pasta 'backend'
COPY backend/go.mod backend/go.sum ./
RUN go mod download

# ATUALIZADO: Copia o código fonte do backend e do frontend para dentro do contêiner
COPY backend/ ./
COPY frontend/ ./frontend/

# Compila a aplicação. 
# CGO_ENABLED=0 desabilita o CGO para criar um binário estático.
# -o /app/main cria o arquivo executável 'main' no diretório /app
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/main .

# Estágio 2: Final
# Usamos uma imagem mínima para rodar nossa aplicação, o que a torna mais leve e segura.
FROM alpine:latest

WORKDIR /app

# Copia o binário compilado do estágio 'builder'
COPY --from=builder /app/main .
# Copia a pasta do frontend do estágio 'builder'
COPY --from=builder /app/frontend ./frontend

# Expõe a porta que a nossa aplicação vai usar
EXPOSE 8080

# Comando para executar a aplicação quando o contêiner iniciar
CMD ["/app/main"]
