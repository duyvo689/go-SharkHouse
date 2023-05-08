package main

import (
	"database/sql"
	"log"

	"github.com/duyvo689/sharkhome/api"
	db "github.com/duyvo689/sharkhome/db/sqlc"
)

func main() {
	conn, err := sql.Open("postgres", "postgresql://root:sharkhome123@localhost:5433/shark_home?sslmode=disable")

	store := db.NewStore(conn)

	server := api.NewServer(store)

	if err != nil {
		log.Fatal("cannot create server", err)
	}

	err = server.Start("0.0.0.0:8080")
}
