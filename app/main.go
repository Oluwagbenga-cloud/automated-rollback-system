package main

import (
	"log"
	"os"

	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.New()

	router.Use(gin.Logger())

	router.GET("/health", func(c *gin.Context) {
		failDeployment := os.Getenv("FAIL_DEPLOYMENT")
		if failDeployment == "true" {
			log.Println("Health check failed")
			c.JSON(500, gin.H{
				"message": "unhealthy",
			})
			return
		}

		log.Println("Health check passed")
		c.JSON(200, gin.H{
			"message": "healthy",
		})
	})

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("Starting server on port %s", port)
	router.Run(":" + port)
}