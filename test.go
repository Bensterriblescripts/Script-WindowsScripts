package main

import "fmt"

func main() {
	user := getUser()
	fmt.Println(user)
}

func getUser() string {
	if user.IDNumber == "" {
		return "User not found"
	}
	return user.Name
}
