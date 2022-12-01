postgrecmd:
	docker exec -it postgres14 bash

postgres14:
	docker run --name postgres14 --network simplebank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:14-alpine

execpostgres14:
	docker exec -it postgres14 /bin/sh

createdb:
	docker exec -it postgres14 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres14 dropdb simple_bank

initschema:
	migrate create -ext sql -dir db/migration -seq init_schema

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

migrateup1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up 1

migratedown1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down 1

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

createcontainer:
	docker run --name simplebank --network simplebank-network -p 8080:8080 -e GIN_MODE=release -e DB_SOURCE="postgresql://root:secret@postgres14:5432/simple_bank?sslmode=disable" simplebank:latest

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/salmaqnsGH/simplebank/db/sqlc Store

.PHONY: postgrecmd postgres14 execpostgres14 createdb dropdb initschema migrateup migratedown migrateup1 migratedown1 sqlc test server mock