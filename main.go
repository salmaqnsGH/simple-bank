package main

import (
	"database/sql"
	"log"

	_ "github.com/lib/pq"
	"github.com/salmaqnsGH/simplebank/api"
	db "github.com/salmaqnsGH/simplebank/db/sqlc"
	"github.com/salmaqnsGH/simplebank/db/util"
)

func main() {
	config, err := util.LoadConfig(".") // in the same dir
	if err != nil {
		log.Fatal("Cannot load config:", err)
	}

	conn, err := sql.Open(config.DBDriver, config.DBSource)
	if err != nil {
		log.Fatal("Cannot connect to database:", err)
	}

	store := db.NewStore(conn)
	server, err := api.NewServer(config, store)
	if err != nil {
		log.Fatal("Cannotcreate server:", err)
	}

	err = server.Start(config.ServerAddress)
	if err != nil {
		log.Fatal("cannot start server")
	}
}
