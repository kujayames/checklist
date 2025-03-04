package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	_ "github.com/lib/pq"
)

var db *sql.DB

func init() {
	var err error
	dsn := fmt.Sprintf("host=postgres user=postgres password=postgres dbname=postgres sslmode=disable")
	db, err = sql.Open("postgres", dsn)
	if err != nil {
		log.Fatal("Error connecting to database:", err)
	}
}

func handler(w http.ResponseWriter, r *http.Request) {
	var count int
	err := db.QueryRow("SELECT COUNT(*) FROM visits").Scan(&count)
	if err != nil {
		http.Error(w, "Failed to get visit count", http.StatusInternalServerError)
		return
	}
	count++
	_, _ = db.Exec("INSERT INTO visits DEFAULT VALUES")

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)

	json.NewEncoder(w).Encode(map[string]int{"count": count})
}

func main() {
	http.HandleFunc("/", handler)
	log.Println("Server is running on port 8080...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
