package main

import (
	"fmt"
	"math/rand"
	"net/http"
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"time"

	"github.com/codegangsta/martini-contrib/binding"
	"github.com/dingotiles/dingo-api/terminal"
	"github.com/dingotiles/dingo-postgresql-agent/config"
	"github.com/go-martini/martini"
	"github.com/martini-contrib/render"
)

const letterBytes = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
const clusterNameRandomLength = 6

var missingRequiredEnvs = []string{}

func main() {
	rand.Seed(time.Now().UnixNano())

	m := martini.Classic()
	m.Use(render.Renderer(render.Options{
		Directory:  "public",
		Layout:     "layout",
		Extensions: []string{".tmpl", ".html"},
		IndentJSON: true, // Output human readable JSON
	}))
	m.Get("/", func(r render.Render, res http.ResponseWriter) {
		terminalWindows, err := buildTerminalWindows()
		if err != nil {
			fmt.Fprintf(os.Stderr, "Could not load assets from data/tutorial/: %s", err)
			res.WriteHeader(500)
			return
		}

		page := struct {
			PageTitle       string
			TerminalWindows map[string]*terminal.Window
		}{
			"Dingo PostgreSQL for Docker",
			terminalWindows,
		}
		r.HTML(200, "index", page)
	})
	m.Get("/tutorial", func(r render.Render, res http.ResponseWriter) {
		terminalWindows, err := buildTerminalWindows()
		if err != nil {
			fmt.Fprintf(os.Stderr, "Could not load assets from data/tutorial/: %s", err)
			res.WriteHeader(500)
			return
		}

		page := struct {
			PageTitle       string
			TerminalWindows map[string]*terminal.Window
		}{
			"Dingo PostgreSQL for Docker",
			terminalWindows,
		}
		r.HTML(200, "tutorial", page)
	})
	m.Get("/health", func(r render.Render) {
		r.JSON(200, map[string]interface{}{"health": "ok"})
	})
	m.Post("/api", binding.Bind(config.ContainerStartupRequest{}), func(req config.ContainerStartupRequest, r render.Render) {
		fmt.Printf("Recv: container start request: %v\n", req)
		missingRequiredEnvs = []string{}

		clusterSpec := config.ClusterSpecification{}
		clusterSpec.Cluster.Name = req.NodeName
		clusterSpec.Cluster.Scope = req.ClusterName

		if os.Getenv("AWS_ACCESS_KEY_ID") != "" {
			clusterSpec.Archives.Method = "s3"
			clusterSpec.Archives.S3.AWSAccessKeyID = requiredEnv("AWS_ACCESS_KEY_ID")
			clusterSpec.Archives.S3.AWSSecretAccessID = requiredEnv("AWS_SECRET_ACCESS_KEY")
			clusterSpec.Archives.S3.S3Bucket = requiredEnv("WAL_S3_BUCKET")
			clusterSpec.Archives.S3.S3Endpoint = requiredEnv("WALE_S3_ENDPOINT")
		} else if os.Getenv("SSH_HOST") != "" {
			clusterSpec.Archives.Method = "ssh"
			clusterSpec.Archives.SSH.Host = requiredEnv("SSH_HOST")
			clusterSpec.Archives.SSH.Port = requiredEnv("SSH_PORT")
			clusterSpec.Archives.SSH.User = requiredEnv("SSH_USER")
			clusterSpec.Archives.SSH.BasePath = requiredEnv("SSH_BASE_PATH")
			clusterSpec.Archives.SSH.PrivateKey = requiredEnv("SSH_PRIVATE_KEY")
		} else if os.Getenv("LOCAL_BACKUP_VOLUME") != "" {
			clusterSpec.Archives.Method = "local"
			clusterSpec.Archives.Local.LocalBackupVolume = requiredEnv("LOCAL_BACKUP_VOLUME")
		} else {
			missingRequiredEnvs = append(missingRequiredEnvs, "AWS_ACCESS_KEY_ID or LOCAL_BACKUP_VOLUME")
		}

		clusterSpec.Etcd.URI = requiredEnv("ETCD_URI")

		clusterSpec.Postgresql.Admin.Password = "admin-password"
		clusterSpec.Postgresql.Superuser.Username = "superuser-username"
		clusterSpec.Postgresql.Superuser.Password = "superuser-password"
		clusterSpec.Postgresql.Appuser.Username = "appuser-username"
		clusterSpec.Postgresql.Appuser.Password = "appuser-password"

		if len(missingRequiredEnvs) != 0 {
			fmt.Println("Missing required env:", missingRequiredEnvs)
			r.JSON(500, map[string]interface{}{"missing-env": missingRequiredEnvs})
			return
		}

		r.JSON(200, clusterSpec)
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

func buildTerminalWindows() (windows map[string]*terminal.Window, err error) {
	clusterName := randomTutorialClusterName()
	tutorialFiles, err := AssetDir("data/tutorial")
	if err != nil {
		return windows, err
	}
	// fmt.Println("Tutorial files loaded:", tutorialFiles)
	tutorialData := map[string]string{}
	for _, tutorialFile := range tutorialFiles {
		data, err := Asset(filepath.Join("data/tutorial", tutorialFile))
		if err != nil {
			fmt.Fprintf(os.Stderr, "Could not load asset %s: %s", tutorialFile, err)
			continue
		}
		tutorialData[tutorialFile] = string(replaceClusterName(data, clusterName))
	}
	return terminal.LoadWindowsFromData(tutorialData), nil
}

func randomTutorialClusterName() string {
	randomSuffix := make([]byte, clusterNameRandomLength)
	for i := range randomSuffix {
		randomSuffix[i] = letterBytes[rand.Intn(len(letterBytes))]
	}

	return fmt.Sprintf("demo-cluster-%s", randomSuffix)
}

func replaceClusterName(template []byte, clusterName string) []byte {
	re := regexp.MustCompile("demo-cluster-replaceme")
	return re.ReplaceAll(template, []byte(clusterName))
}

func requiredEnv(envKey string) string {
	if os.Getenv(envKey) == "" {
		missingRequiredEnvs = append(missingRequiredEnvs, envKey)
	}
	return os.Getenv(envKey)
}
