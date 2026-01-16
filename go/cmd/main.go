package main

import (
	"core/mobile"
	"fmt"
)

func main() {
	fmt.Println("School App Backend CLI")
	// Test init
	err := mobile.Init(":memory:")
	if err != "" {
		fmt.Printf("Error initializing: %s\n", err)
	} else {
		fmt.Println("Backend initialized successfully (in-memory)")
	}
}
