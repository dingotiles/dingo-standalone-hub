package main

import (
	"fmt"
	"os"

	"github.com/go-martini/martini"
	"github.com/martini-contrib/render"
)

func main() {
	m := martini.Classic()
	m.Use(render.Renderer(render.Options{
		Directory:  "templates",                // Specify what path to load the templates from.
		Layout:     "layout",                   // Specify a layout template. Layouts can call {{ yield }} to render the current template.
		Extensions: []string{".tmpl", ".html"}, // Specify extensions to load for templates.
		Charset:    "UTF-8",                    // Sets encoding for json and html content-types. Default is "UTF-8".
		IndentJSON: true,                       // Output human readable JSON
	}))
	m.Get("/", func() string {
		return "Hello world!"
	})
	m.Get("/api", func(r render.Render) {
		staticResponse := map[string]interface{}{
			"cluster": map[string]interface{}{
				"scope_name": "demo-cluster",
			},
			"wale_mode": "aws",
			"wale_env": []string{
				fmt.Sprintf("AWS_ACCESS_KEY_ID=%s", os.Getenv("AWS_ACCESS_KEY_ID")),
				fmt.Sprintf("AWS_SECRET_ACCESS_KEY=%s", os.Getenv("AWS_SECRET_ACCESS_KEY")),
				fmt.Sprintf("WAL_S3_BUCKET=%s", os.Getenv("WAL_S3_BUCKET")),
				fmt.Sprintf("WALE_S3_ENDPOINT=%s", os.Getenv("WALE_S3_ENDPOINT")),
			},
			"postgresql": map[string]interface{}{
				"admin": map[string]interface{}{
					"username": "admin-username",
					"password": "admin-password",
				},
				"superuser": map[string]interface{}{
					"username": "superuser-username",
					"password": "superuser-password",
				},
				"appuser": map[string]interface{}{
					"username": "appuser-username",
					"password": "appuser-password",
				},
			},
			"etcd": map[string]interface{}{
				"uri": os.Getenv("ETCD_URI"),
			},
		}
		r.JSON(200, staticResponse)
	})
	m.Run()

}
