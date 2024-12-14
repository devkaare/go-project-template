FROM golang:1.23 AS build
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go install github.com/a-h/templ/cmd/templ@latest && \ 
    templ generate 
RUN go build -o main cmd/api/main.go

FROM build AS dev 
RUN go install github.com/air-verse/air@latest
EXPOSE ${PORT}
CMD ["air", "-c", ".air.toml"]

FROM build AS prod
EXPOSE ${PORT}
CMD ["./main"]
