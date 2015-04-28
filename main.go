package main

import (
	"log"
	"net/http"
	"os"
)

func main() {

	router := NewRouter()

	port := "8080"
	if os.Getenv("HTTP_PLATFORM_PORT") != "" {
        port = os.Getenv("HTTP_PLATFORM_PORT")
    }

	log.Fatal(http.ListenAndServe(":" + port, router))
}
