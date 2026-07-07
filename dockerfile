FROM golang:1.26.2-alpine AS builder
WORKDIR /src

COPY go.mod ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o /out/boot-dev-docker ./main.go

FROM alpine:3.22
COPY --from=builder /out/boot-dev-docker /bin/boot-dev-docker
ENV PORT=8991
EXPOSE 8991
CMD ["/bin/boot-dev-docker"]