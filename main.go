package main

import (
	"fmt"
	"net/http"
	"os"
	"strings"

	"github.com/codegangsta/martini-contrib/binding"
	"github.com/dingotiles/dingo-api/terminal"
	"github.com/dingotiles/dingo-postgresql-agent/config"
	"github.com/go-martini/martini"
	"github.com/martini-contrib/render"
)

func main() {
	m := martini.Classic()
	m.Use(render.Renderer(render.Options{
		Directory:  "public",
		Extensions: []string{".tmpl", ".html"},
		IndentJSON: true, // Output human readable JSON
	}))
	m.Get("/", func(r render.Render) {
		r.HTML(200, "terminal-demo", "")
	})
	m.Get("/tutorial/:tutorial", func(params martini.Params, r render.Render, res http.ResponseWriter) {
		data, err := Asset(fmt.Sprintf("data/tutorial/%s.txt", params["tutorial"]))
		if err != nil {
			res.WriteHeader(404)
			return
		}
		tutorialData := terminal.NewWindow(string(data), params["tutorial"])
		r.HTML(200, "tutorial", tutorialData)
	})
	m.Get("/health", func(r render.Render) {
		r.JSON(200, map[string]interface{}{"health": "ok"})
	})
	m.Post("/api", binding.Bind(config.ContainerStartupRequest{}), func(req config.ContainerStartupRequest, r render.Render) {
		fmt.Printf("Recv: container start request: %v\n", req)
		name := "patroni1"
		patroniScope := req.ClusterName
		waleEnvVars := constructReturnedEnvVars(patroniScope, filterWaleEnvVars())
		staticResponse := map[string]interface{}{
			"cluster": map[string]interface{}{
				"name":  name,
				"scope": patroniScope,
			},
			"wale_env": waleEnvVars,
			// Example:
			// 	AWS_ACCESS_KEY_ID=AWS_ACCESS_KEY_ID
			// 	AWS_SECRET_ACCESS_KEY=AWS_SECRET_ACCESS_KEY
			// 	WAL_S3_BUCKET=WAL_S3_BUCKET
			// 	WALE_S3_ENDPOINT=https+path://s3.amazonaws.com:443
			// 	WALE_S3_PREFIX=s3://${WAL_S3_BUCKET}/backups/test-cluster-scope/wal/
			"postgresql": map[string]interface{}{
				"admin": map[string]interface{}{
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
				"uri": os.Getenv("ETCD_HOST_PORT"),
			},
		}
		r.JSON(200, staticResponse)
	})
	m.Run()
}

func filterWaleEnvVars() []string {
	return filterWaleEnvVarsFromList(os.Environ())
}

func filterWaleEnvVarsFromList(environ []string) []string {
	waleEnvCount := 0
	walePrefixes := []string{"WAL", "AWS", "WABS", "GOOGLE", "SWIFT", "PATRONI", "ETCD", "CONSUL"}
	for _, envVar := range environ {
		for _, prefix := range walePrefixes {
			if strings.Index(envVar, prefix) == 0 && !strings.HasSuffix(envVar, "=") {
				waleEnvCount++
			}
		}
	}
	waleEnvVars := make([]string, waleEnvCount)
	// waleEnvVars[0] = fmt.Sprintf("PATRONI_SCOPE=%s", patroniScope)
	waleEnvIndex := 0
	for _, envVar := range environ {
		for _, prefix := range walePrefixes {
			if strings.Index(envVar, prefix) == 0 && !strings.HasSuffix(envVar, "=") {
				waleEnvVars[waleEnvIndex] = envVar
				waleEnvIndex++
			}
		}
	}
	return waleEnvVars
}

// Some returned env vars are constructed based on other values
//   WALE_S3_PREFIX=s3://${WAL_S3_BUCKET}/backups/{{patroniScope}}/wal/
func constructReturnedEnvVars(patroniScope string, environ []string) []string {
	environ = append(environ, fmt.Sprintf("PATRONI_SCOPE=%s", patroniScope))
	for _, envVar := range environ {
		if strings.Index(envVar, "WAL_S3_BUCKET") == 0 {
			parts := strings.Split(envVar, "=")
			waleS3Prefix := fmt.Sprintf("WALE_S3_PREFIX=s3://%s/backups/%s/wal/", parts[1], patroniScope)
			environ = append(environ, waleS3Prefix)
		}
	}
	return environ
}
